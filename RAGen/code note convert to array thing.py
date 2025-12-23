import json
import re
import os

# 🏴‍☠️ CONFIGURATION 🏴‍☠️
INPUT_FILENAME = '34593-Notes.json'

def parse_and_sort_booty():
    print(f"--- 🏴‍☠️ OPENING THE MANIFEST: {INPUT_FILENAME} 🏴‍☠️ ---")
    
    if not os.path.exists(INPUT_FILENAME):
        print(f"🚫 ARRRGH! '{INPUT_FILENAME}' is missing! Check your map (folder)!")
        return

    with open(INPUT_FILENAME, 'r', encoding='utf-8') as f:
        try:
            data = json.load(f, strict=False)
        except Exception as e:
            print(f"💥 KRAKEN ATTACK (JSON Error): {e}")
            return

    # 1. PARSE THE DATA INTO A DICTIONARY
    grouped_loot = {}
    
    # Map long names to the short codes you want
    loc_map = {
        "Rio De Janeiro": "Rio",
        "Cairo": "Cairo",
        "Madrid": "Madrid",
        "Singapore": "Singapore",
        "Dubai": "Dubai"
    }

    for entry in data:
        note = entry.get("Note", "")
        address = entry.get("Address", "")
        
        # Regex to capture: Profile X, (Type) Cup
        profile_match = re.search(r"Profile (\d+)", note)
        cup_match = re.search(r"(Bronze|Silver|Gold) Cup", note)
        
        # Find Location
        found_loc = None
        for long_name, short_name in loc_map.items():
            if long_name in note:
                found_loc = short_name
                break
        
        if profile_match and cup_match and found_loc:
            p_num = int(profile_match.group(1)) # Store as int for easier sorting later if needed
            cup_type = cup_match.group(1)
            
            # Key: RioBronzeP1
            var_name = f"{found_loc}{cup_type}P{p_num}"
            
            if var_name not in grouped_loot:
                grouped_loot[var_name] = []
            
            grouped_loot[var_name].append(address)

    # 2. 🖨️ THE ORDERED PRINTING 🖨️
    # We define the EXACT order we want to sail in
    
    ordered_locations = ["Rio", "Cairo", "Madrid", "Singapore", "Dubai"]
    ordered_cups = ["Bronze", "Silver", "Gold"]
    ordered_profiles = range(1, 7) # 1 to 6

    print("--- 💎 START OF ORDERED LOOT 💎 ---\n")

    for loc in ordered_locations:
        for cup in ordered_cups:
            for p_num in ordered_profiles:
                
                # Construct the key we are looking for (e.g., RioBronzeP1)
                target_key = f"{loc}{cup}P{p_num}"
                
                # Check if we actually found treasure for this specific combo
                if target_key in grouped_loot:
                    addresses = grouped_loot[target_key]
                    
                    print(f"{target_key} = [")
                    
                    # Print in rows of 4
                    chunk_size = 4
                    for i in range(0, len(addresses), chunk_size):
                        chunk = addresses[i:i + chunk_size]
                        row_str = ", ".join(chunk)
                        print(f"    {row_str},")
                    
                    print("]\n")
                else:
                    # Optional: Print if a specific cup/profile is missing? 
                    # Uncomment the line below if you want to know what's missing
                    # print(f"// ⚠️ No loot found for {target_key}")
                    pass

    print("--- 🏴‍☠️ MANIFEST COMPLETE 🏴‍☠️ ---")

if __name__ == "__main__":
    parse_and_sort_booty()
