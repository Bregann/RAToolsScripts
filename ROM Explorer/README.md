# ROM Explorer

Browse a game's code in plain English, see which RAM each function reads and writes, and build up names, labels and notes for RetroAchievements work.

Supported now: **Game Boy / Game Boy Color** (.gb, .gbc), **Game Boy Advance** (.gba), **PlayStation** (.cue/.bin, .iso, or the boot .exe), **PlayStation 2** (.iso, or the boot ELF) and **GameCube / Wii** (.iso/.gcm, Dolphin .rvz/.wia, or main.dol) **Nintendo DS** (.nds) and **PlayStation Portable** (.iso, .cso, or a decrypted EBOOT.BIN / .prx).


## Getting started (Windows)
1. Install **Python 3.10 or newer** from python.org (tick "Add python.exe to PATH").
2. Unzip ROM Explorer anywhere and double-click **Start ROM Explorer.bat**. The first start downloads the parts it needs, then opens ROM Explorer in your browser.
3. The **Setup** page opens. Work down it: every step is checked for you, with buttons that do the fiddly bits (install missing parts, scan your PC for emulators and folders, add ROM Explorer to the Claude app, turn on emulator links, test everything). Come back to it any time from the **Setup** button at the top.

## Run it (Windows)
1. Install Python 3.10 or newer from python.org (tick "Add Python to PATH").
2. Double-click **Start ROM Explorer.bat**. It installs the one dependency (capstone) the first time, then opens the app in your browser at http://127.0.0.1:8765/.
3. Go to **Settings** and paste your folders. Then pick a game under **Games**.

From a terminal instead: `pip install -r requirements.txt` then `python -m romx` (options: `--port 9000`, `--no-browser`).

The app only listens on your own computer (127.0.0.1). Close the window to stop it.

## Where things are kept
- **Settings**: `%APPDATA%\ROM Explorer\settings.json`
- **Projects folder**: one `<game>.romx.json` per game with your function names, labels, notes and value names. Back this up.
- **Work folder**: the analysis cache (safe to delete; it is rebuilt) and exported notes files.

## RetroAchievements code notes
Set your emulator folders (RALibretro, RAPCSX2, ...) in Settings. In a game's **Project & notes** tab, enter the RA game ID and press **Import code notes**: it reads `RACache\Data\<id>-Notes.json` and adds each note as a labelled address. Or copy the notes table from the game's Code Notes page on retroachievements.org and paste it into the box there. Lines like `0x02 = Gold` become value names, so the code reads "If Difficulty is 2 (Gold)". Nothing is uploaded.

## Game Boy notes
- Addresses are shown as bank:address (`02:4243` is address 0x4243 in ROM bank 2), and unnamed functions as `sub_02_4243`.
- The tool follows bank switches (writes to 0x2000-0x3FFF, and helpers that do that) and far-call helpers that take the bank in a register and the address in HL. Those helpers are named SwitchBank and FarCall automatically; rename them if you like.
- Hardware registers (LCDC, SVBK, P1 and so on) are labelled for you.
- Games that run their logic as "scripts" (lists of routine addresses, each routine ending with a jump to a small RAM routine that fetches the next one) are detected: those routines are found from the script data and their last step reads "Go on to the next script command".
- Echo RAM (0xE000-0xFDFF) labels, such as a note at 0xFB63, are matched to the same memory at 0xC000-0xDDFF.
- RetroAchievements addresses for GB/GBC are the Game Boy addresses (WRAM at 0xC000, HRAM at 0xFF80). Code can't tell which GBC WRAM bank is switched in at 0xD000, so those show as bank 1.

## PlayStation 2 notes
- The boot ELF is found through `BOOT2` in SYSTEM.CNF. If the ELF still has its symbol table, functions and global variables get the developers' own names.
- RA addresses are the EE RAM address (0x00100000-0x01FFFFFF); the scratchpad (0x70000000) is at RA 0x02000000.
- PS2-only instructions (128-bit MMI and vector-unit ops) show as raw instructions in the code view.
- Only the main ELF is read. Code some games load later from other files on the disc isn't included yet.

## GameCube / Wii notes
- The tool reads main.dol from the disc. GameCube .iso/.gcm work directly. Wii .iso files are encrypted, so convert them to RVZ in Dolphin first (right-click the game > Convert File... > RVZ, keep zstd compression), or open a main.dol you extracted with Dolphin.
- RA addresses: MEM1 (0x80000000) is at 0, and Wii MEM2 (0x90000000) at 0x10000000, matching RetroAchievements.
- Globals reached through r13 and r2 (the small-data bases set in __start) are followed, so `lwz r6,-0x7f20(r13)` shows the real address.
- Functions reached only through pointers (often C++ virtual methods in vtables) are found and marked as such.
- Code in REL modules (loaded later from the disc) isn't read yet.
- For Ghidra there's also the GameCube Loader extension, which can open main.dol and REL files directly: https://github.com/Cuyler36/Ghidra-GameCube-Loader

## Nintendo DS notes
- Reads the ARM9 program (the game), the ARM7 program, and every ARM9 overlay. Compressed ARM9 programs and overlays (the DS "BLZ" compression) are unpacked automatically.
- Code is a mix of ARM and Thumb; the tool follows BL/BLX calls across the two.
- Overlays load into the same RAM at different times, so their functions show with the overlay number: `ov03:021A0000`, named `sub_ov03_021A0000`. A call from the ARM9 program into overlay RAM is matched to the first overlay that has code there, which can be the wrong one when several overlays share that space.
- RA addresses: main RAM 0x02000000 (4 MB, mirrored up to 0x02FFFFFF) is at 0.
- Most DS text lives in files on the cartridge's file system (message archives), not in the code, so the Text tab only shows strings inside the ARM9 program for now.
- Ghidra: the ARM9 program is sent, with each function marked ARM or Thumb. Overlays aren't sent yet.

## Connect to Claude
ROM Explorer can run as an MCP server, so Claude can dig through a game with you on your normal Claude plan (no API key).

1. Start ROM Explorer, go to **Settings > Connect to Claude** and press **Add to the Claude desktop app**. Or paste the setting shown there into Claude > Settings > Developer > Edit Config. For Claude Code, run the `claude mcp add` line shown there.
2. Quit and reopen the Claude desktop app. ROM Explorer shows under the tools button in a chat.
3. Ask away: "In Robot Wars, find what counts the fight clock and name the function that resets it", "compare save states 1 and 2 for a byte that went down by 1", "explain AwardPrize".

Claude can: list and open games, get a project overview, search, read functions (key steps, every instruction, or Ghidra C), look up an address and everything that touches it, find text and who uses it, compare save states, hex-dump a state, add save states, import or export code notes, start Ghidra, and **name functions and label addresses**. Its names and labels go into the same project files as yours, and the web UI picks them up when you next click.

The web UI doesn't need to be running for Claude to use it. Claude starts its own copy (`romx_mcp.py`, or `python -m romx --mcp`).

## Live: Claude and a running emulator
With ROM Explorer connected to Claude, Claude can also connect to the emulator the game is running in ("connect to DuckStation"), and then read and change RAM live (by RA address, with your labels), pause, step, set breakpoints, take screenshots, press buttons, save/load states, snapshot RAM into the project, and record how values change while you play. With a debugger link it can **watch an address and stop on the exact instruction that writes it**, then tell you which function that is.

| Emulator | Turn on | Port | What works |
|---|---|---|---|
| RetroArch (any core) | Settings > Network > Network Commands | 55355 | RAM (RA addresses), states, pause, frame advance; value-change watching |
| DuckStation | Enable GDB Server (in the Advanced settings; turn on "Show Debug Menu"/advanced options if hidden) | 2345 | RAM, pause/step, registers, breakpoints, write/read watchpoints |
| PCSX2 | Settings > Advanced > Enable PINE | 28011 | RAM, states; value-change watching. If your PCSX2 build has a GDB server, give its port too for breakpoints and watchpoints |
| PPSSPP | Settings > Tools > Developer tools > Allow remote debugger | shown there | RAM, pause/step, registers, breakpoints, memory watchpoints, buttons, screenshots, states |
| mGBA | Tools > Start GDB server | 2345 | RAM, pause/step, registers, breakpoints, watchpoints |
| melonDS | Enable the GDB stub (Emu settings, DevTools tab, in recent versions) | 3333 | as mGBA |
| Dolphin | its GDB stub if your build has one (give the port); otherwise nothing to turn on | | GDB: as mGBA. Without: RAM only, read from Dolphin's process (Windows) |

Screenshots and button presses for emulators without their own (everything but PPSSPP) work on Windows by capturing the emulator's window and typing keys into it. For buttons, tell ROM Explorer your key bindings in **Settings > Emulator keys**, one emulator per line, for example `pcsx2: Cross = X, Circle = C, Start = Enter, Up = Up, savestate = F1, loadstate = F3`.

Not tested on the real emulators yet: the GDB link was tested against QEMU's GDB server, and the others against stand-ins that follow each emulator's protocol.

## Save states
Open a game, go to **Save states**, and add states of that game: pick them from your save state folders (set in Settings), paste a path, or upload. Each state is read once and kept with the project; press **Re-read** after saving over the same slot in the emulator.

Then compare them like RetroAchievements' memory inspector, over as many states as you like: for each state say how the value compares to the state before (same, changed, went up, went down, went up/down by N) and optionally what the value is. Results show each address's label, its value in every state, and the code that reads or writes it. Tick **Only addresses the code uses** to cut out noise. Labelled addresses also show their value in each state.

Which states it can read:
- **GBA:** mGBA states (RetroArch's mGBA core, or mGBA itself).
- **Game Boy / Color:** Gambatte states (RetroArch's Gambatte core). Not tested on a real state yet.
- **PS1, PS2, PSP, DS, GameCube/Wii:** the tool looks for the game's own code inside the state to find where RAM is, so it should work with most emulators whose states it can unpack: RetroArch, DuckStation, PCSX2 (.p2s), PPSSPP, melonDS and others. Not tested on real states yet.
- **Dolphin** states use a compression the tool can't read yet. Dump MEM1 from Dolphin's Memory view (mem1.raw) and add that instead. Wii MEM2 isn't read yet.
- A raw RAM dump of exactly the console's RAM size works for any console.

## Addresses: RA or console
On PSP, GameCube/Wii, PS1, PS2, DS and GBA, code and data addresses are shown as RetroAchievements addresses by default (PSP 0x08804000 shows as 0x804000). The **Addresses** button at the top switches to the console's own addresses. The function details always show both. Search finds either form. Automatic names like `sub_08804040` keep the console address so they match Ghidra.

## PSP notes
- The game is `PSP_GAME/SYSDIR/EBOOT.BIN` on the UMD image (.iso or .cso; .zso needs `pip install lz4`).
- **Retail EBOOTs are encrypted.** In PPSSPP turn on Settings > Tools > Developer tools > "Dump decrypted EBOOT.BIN on game boot", start the game once, and open the dumped file from `memstick/PSP/SYSTEM/DUMP/` here. If the disc has a plain BOOT.BIN the tool uses that instead.
- The main program is usually a relocatable module (PRX). The tool places it at 0x08804000, where the PSP normally loads it, and applies its relocations. The newer packed relocation format isn't applied yet; the tool says so when a game uses it.
- Imported system calls are named from the module's import table, for example `sceCtrlReadBufferPositive` (controller input) and `sceDisplayWaitVblankStart` (once per frame). A few common ones are built in; others show as `Library_NID`.
- RA addresses: 0x08000000 is at 0, so the game's own RAM starts at RA 0x800000 and a module at 0x08804000 is RA 0x804000.
- The CPU is the Allegrex (MIPS32). Its VFPU vector-maths instructions show raw.
- Ghidra: sent as MIPS little endian at the module's load address. The Allegrex extension (https://github.com/kotcrab/ghidra-allegrex) understands the VFPU instructions too.

## Ghidra (optional): decompiled C
1. Install Ghidra 11 (and a JDK 21) and set its folder in Settings, the folder that has `support\analyzeHeadless.bat`.
2. For PS2, install the Emotion Engine extension in Ghidra (File > Install Extensions): https://github.com/chaoticgd/ghidra-emotionengine-reloaded
3. Open a game, go to **Project & notes** and press **Decompile with Ghidra**. It runs in the background with `romx/ghidra/RomxExport.java`, starting from the functions this tool found. When it's done, every function gets a **Decompiled C** view, with links to your names and labels.

Works for GBA, DS, PS1, PS2, PSP and GameCube/Wii. Game Boy needs a Ghidra extension for its CPU and isn't wired up yet. Results and logs go in `<work folder>\ghidra`.

## Layout
- `romx/platforms/gb.py`, `gba.py`, `ps1.py`: one module per console (`sm83.py` is the Game Boy disassembler) (loading, finding functions and RAM references). `*_plain.py` turns that console's instructions into sentences.
- `romx/core.py`: combines the analysis with your project into what the UI shows.
- `romx/project.py`, `settings.py`, `server.py`, `ui/index.html`.
- `romx/seeds/`: starter projects (Robot Wars: Extreme Destruction and Robot Wars: Metal Mayhem, with their RA notes).
- `tools/make_ps1_test_disc.py`, `make_ps2_test_disc.py`, `make_gc_test_disc.py`, `make_nds_test_rom.py`, `make_psp_test_disc.py`: build tiny test discs (need `pip install keystone-engine pycdlib`).
- `romx/ghidra/RomxExport.java`: the script Ghidra runs.

Adding a console means adding one platform module with the same functions as `ps1.py`.
