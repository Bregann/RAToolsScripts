import json

def keep_it_crusty(file_path):
    with open(file_path, 'r') as f:
        data = json.load(f)
    
    if isinstance(data, dict):
        data = [data]

    for entry in data:
        # Address formatting (still gotta look snatched) 💎
        raw_addr = entry.get("Address", "0").replace("0x", "")
        formatted_addr = f"0x{raw_addr.zfill(8)}"
        
        # We use encode('unicode_escape') to keep the \r and \n visible!
        # Then we decode it back to a string so it prints properly.
        raw_note = entry.get("Note", "")
        escaped_note = raw_note.encode('unicode_escape').decode('utf-8')
        
        # The savage final result 🐍
        print(f"N0:{formatted_addr}:\"{escaped_note}\"")

# Don't let the ship sink, use the right filename!
keep_it_crusty('loot.json')
