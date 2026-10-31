-- ROM Explorer link for mGBA (0.10 or newer). Load it in mGBA: Tools > Scripting... > File > Load script...
-- It lets ROM Explorer (and Claude) read and change RAM, press buttons, take screenshots, save/load states and
-- watch addresses, without slowing the game down (unlike the GDB server).
-- Listens on 127.0.0.1 port 61234. One command per line, one reply per line.

local PORT = 61234
local server, clients = nil, {}
local holds = {}      -- {mask=, frames=}
local watches = {}    -- {client=, addr=, size=, old=, left=}

local function hex(s)
  return (s:gsub(".", function(c) return string.format("%02x", c:byte()) end))
end
local function unhex(h)
  return (h:gsub("..", function(x) return string.char(tonumber(x, 16)) end))
end
local function readv(addr, size)
  if size == 1 then return emu:read8(addr) elseif size == 2 then return emu:read16(addr) else return emu:read32(addr) end
end

local function reply(c, msg) c.sock:send(msg .. "\n") end

local function run(c, line)
  local cmd, rest = line:match("^(%S+)%s*(.*)$")
  if not cmd then return end
  if not emu then return reply(c, "ERR no game loaded") end
  if cmd == "PING" then
    reply(c, "OK mgba " .. (emu:getGameCode() or "") .. " " .. (emu:getGameTitle() or ""))
  elseif cmd == "READ" then            -- READ addr len [addr len ...]  (hex addresses, decimal lengths)
    local out = {}
    for a, n in rest:gmatch("(%x+)%s+(%d+)") do out[#out + 1] = hex(emu:readRange(tonumber(a, 16), tonumber(n))) end
    reply(c, "OK " .. table.concat(out, " "))
  elseif cmd == "WRITE" then           -- WRITE addr hexbytes
    local a, h = rest:match("(%x+)%s+(%x+)")
    local addr, data = tonumber(a, 16), unhex(h)
    for i = 1, #data do emu:write8(addr + i - 1, data:byte(i)) end
    reply(c, "OK")
  elseif cmd == "KEYS" then            -- KEYS mask frames: hold buttons (bits as C.GBA_KEY) for some frames
    local m, f = rest:match("(%d+)%s+(%d+)")
    holds[#holds + 1] = {mask = tonumber(m), frames = tonumber(f), client = c}
    emu:addKeys(tonumber(m))
  elseif cmd == "SAVE" then reply(c, emu:saveStateSlot(tonumber(rest)) and "OK" or "ERR could not save")
  elseif cmd == "LOAD" then reply(c, emu:loadStateSlot(tonumber(rest)) and "OK" or "ERR could not load")
  elseif cmd == "SHOT" then emu:screenshot(rest); reply(c, "OK")
  elseif cmd == "FRAME" then reply(c, "OK " .. emu:currentFrame())
  elseif cmd == "WATCH" then           -- WATCH addr size frames: reply when the value changes (checked every frame)
    local a, s, f = rest:match("(%x+)%s+(%d+)%s+(%d+)")
    local addr, size = tonumber(a, 16), tonumber(s)
    watches[#watches + 1] = {client = c, addr = addr, size = size, old = readv(addr, size), left = tonumber(f), start = emu:currentFrame()}
  elseif cmd == "UNWATCH" then
    for i = #watches, 1, -1 do if watches[i].client == c then table.remove(watches, i) end end
    reply(c, "OK")
  else reply(c, "ERR unknown command " .. cmd) end
end

local function on_data(c)
  while true do
    local data, err = c.sock:receive(4096)
    if not data or #data == 0 then break end
    c.buf = c.buf .. data
    while true do
      local line, rest = c.buf:match("^([^\n]*)\n(.*)$")
      if not line then break end
      c.buf = rest
      local ok, e = pcall(run, c, (line:gsub("\r", "")))
      if not ok then reply(c, "ERR " .. tostring(e)) end
    end
    if not c.sock:hasdata() then break end
  end
end

local function on_frame()
  for i = #holds, 1, -1 do
    local h = holds[i]; h.frames = h.frames - 1
    if h.frames <= 0 then emu:clearKeys(h.mask); table.remove(holds, i); pcall(reply, h.client, "OK") end
  end
  for i = #watches, 1, -1 do
    local w = watches[i]; local v = readv(w.addr, w.size)
    if v ~= w.old then
      pcall(reply, w.client, string.format("CHANGED %d %d %d", w.old, v, emu:currentFrame() - w.start)); table.remove(watches, i)
    else
      w.left = w.left - 1
      if w.left <= 0 then pcall(reply, w.client, "TIMEOUT"); table.remove(watches, i) end
    end
  end
end

local function start()
  if server then return end
  server = socket.bind("127.0.0.1", PORT)
  if not server then console:error("ROM Explorer: couldn't open port " .. PORT); return end
  server:listen()
  server:add("received", function()
    local s = server:accept()
    if not s then return end
    local c = {sock = s, buf = ""}
    clients[#clients + 1] = c
    s:add("received", function() on_data(c) end)
    s:add("error", function()
      for i = #clients, 1, -1 do if clients[i] == c then table.remove(clients, i) end end
      for i = #watches, 1, -1 do if watches[i].client == c then table.remove(watches, i) end end
    end)
  end)
  console:log("ROM Explorer link is on (port " .. PORT .. "). Leave this window open.")
end

callbacks:add("frame", on_frame)
start()
