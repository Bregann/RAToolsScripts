import re

# 👇 PASTE YOUR GIANT LIST OF N0 LINES BETWEEN THE TRIPLE QUOTES 👇
input_data = """
N0:0x10043a4c:"[Bitflag] Profile 7 - Scuba Diving Chart - Bottlenose Dolphin\r\nbit2 = Found"
N0:0x10043a4d:"[Bitflag] Profile 7 - Scuba Diving Chart - Loggerhead Sea Turtle\r\nbit2 = Found"
N0:0x10043a4e:"[Bitflag] Profile 7 - Scuba Diving Chart - Ocellaris Clownfish\r\nbit2 = Found"
N0:0x10043a4f:"[Bitflag] Profile 7 - Scuba Diving Chart - Pink Clownfish\r\nbit2 = Found"
N0:0x10043a50:"[Bitflag] Profile 7 - Scuba Diving Chart - Indo-Pacific Sergeant\r\nbit2 = Found"
N0:0x10043a51:"[Bitflag] Profile 7 - Scuba Diving Chart - Semicircle Angelfish\r\nbit2 = Found"
N0:0x10043a52:"[Bitflag] Profile 7 - Scuba Diving Chart - Threadfin Butterflyfish\r\nbit2 = Found"
N0:0x10043a53:"[Bitflag] Profile 7 - Scuba Diving Chart - Moorish Idol\r\nbit2 = Found"
N0:0x10043a54:"[Bitflag] Profile 7 - Scuba Diving Chart - Blue Tang\r\nbit2 = Found"
N0:0x10043a55:"[Bitflag] Profile 7 - Scuba Diving Chart - Striated Frogfish\r\nbit2 = Found"
N0:0x10043a56:"[Bitflag] Profile 7 - Scuba Diving Chart - Luna Lionfish\r\nbit2 = Found"
N0:0x10043a57:"[Bitflag] Profile 7 - Scuba Diving Chart - Black Clownfish\r\nbit2 = Found"
N0:0x10043a58:"[Bitflag] Profile 7 - Scuba Diving Chart - Humpback Whale\r\nbit2 = Found"
N0:0x10043a59:"[Bitflag] Profile 7 - Scuba Diving Chart - Whale Shark\r\nbit2 = Found"
N0:0x10043a5a:"[Bitflag] Profile 7 - Scuba Diving Chart - Napoleon Fish\r\nbit2 = Found"
N0:0x10043a5b:"[Bitflag] Profile 7 - Scuba Diving Chart - Longnose Butterflyfish\r\nbit2 = Found"
N0:0x10043a5c:"[Bitflag] Profile 7 - Scuba Diving Chart - Red Gurnard\r\nbit2 = Found"
N0:0x10043a5d:"[Bitflag] Profile 7 - Scuba Diving Chart - Manta Ray\r\nbit2 = Found"
N0:0x10043a5e:"[Bitflag] Profile 7 - Scuba Diving Chart - Scalloped Hammerhead\r\nbit2 = Found"
N0:0x10043a5f:"[Bitflag] Profile 7 - Scuba Diving Chart - Giant Spider Crab\r\nbit2 = Found"
N0:0x10043a60:"[Bitflag] Profile 7 - Scuba Diving Chart - Warty Frogfish\r\nbit2 = Found"
N0:0x10043a61:"[Bitflag] Profile 7 - Scuba Diving Chart - Beluga Whale\r\nbit2 = Found"
N0:0x10043a62:"[Bitflag] Profile 7 - Scuba Diving Chart - Moon Jellyfish\r\nbit2 = Found"
N0:0x10043a63:"[Bitflag] Profile 7 - Scuba Diving Chart - Leafy Sea Dragon\r\nbit2 = Found"
N0:0x10043a64:"[Bitflag] Profile 7 - Scuba Diving Chart - Beluga Whale (baby)\r\nbit2 = Found"
N0:0x10043a65:"[Bitflag] Profile 7 - Scuba Diving Chart - King Penguin\r\nbit2 = Found"
N0:0x10043a66:"[Bitflag] Profile 7 - Scuba Diving Chart - Yellow Watchman Goby\r\nbit2 = Found"
N0:0x10043a67:"[Bitflag] Profile 7 - Scuba Diving Chart - White-Spotted Puffer\r\nbit2 = Found"
N0:0x10043a68:"[Bitflag] Profile 7 - Scuba Diving Chart - Spotted Garden Eel\r\nbit2 = Found"
N0:0x10043a69:"[Bitflag] Profile 7 - Scuba Diving Chart - Yellow Boxfish\r\nbit2 = Found"
N0:0x10043a6a:"[Bitflag] Profile 7 - Scuba Diving Chart - Yellow Boxfish (baby)\r\nbit2 = Found"
N0:0x10043a6b:"[Bitflag] Profile 7 - Scuba Diving Chart - Ocean Sunfish\r\nbit2 = Found"
N0:0x10043a6c:"[Bitflag] Profile 7 - Scuba Diving Chart - Potato Cod\r\nbit2 = Found"
N0:0x10043a6d:"[Bitflag] Profile 7 - Scuba Diving Chart - Bigfin Reef Squid\r\nbit2 = Found"
N0:0x10043a6e:"[Bitflag] Profile 7 - Scuba Diving Chart - Nautilus\r\nbit2 = Found"
N0:0x10043a6f:"[Bitflag] Profile 7 - Scuba Diving Chart - Monkfish\r\nbit2 = Found"
N0:0x10043a70:"[Bitflag] Profile 7 - Scuba Diving Chart - Oarfish\r\nbit2 = Found"
N0:0x10043a71:"[Bitflag] Profile 7 - Scuba Diving Chart - Sea-firefly\r\nbit2 = Found"
N0:0x10043a72:"[Bitflag] Profile 7 - Scuba Diving Chart - Black Manta Ray\r\nbit2 = Found"
N0:0x10043a73:"[Bitflag] Profile 7 - Scuba Diving Chart - Coelacanth\r\nbit2 = Found"
"""

# 🏴‍☠️ SET YOUR DESTINY HERE
OFFSET_VAL = 0x11A0 
MODE = "+"  # Use "-" to subtract or "+" to add! ⚓

print(f"--- 🏴‍☠️ { 'YEETING' if MODE == '-' else 'BOOSTING' } BY {hex(OFFSET_VAL)} 🏴‍☠️ ---")

# 1. SPLIT BY "N0:" INSTEAD OF NEWLINES
raw_chunks = ("\n" + input_data).split("\nN0:")
chunks = [c for c in raw_chunks if c.strip()]

for chunk in chunks:
    full_line = "N0:" + chunk.strip()
    
    # Regex to capture the prefix, address, and the crusty notes
    match = re.match(r"(N0:)(0x[0-9a-fA-F]+)(:.*)", full_line, re.DOTALL)
    
    if match:
        prefix = match.group(1)        # N0:
        old_addr_str = match.group(2)  # The Hex Address
        rest_of_text = match.group(3)  # The notes
        
        # 📈 DO THE PIRATE MATH (Switching between add/sub)
        old_val = int(old_addr_str, 16)
        if MODE == "-":
            new_val = old_val - OFFSET_VAL
        else:
            new_val = old_val + OFFSET_VAL
            
        # Keep it 8-digit hex for that crisp look 💎
        new_addr_str = f"0x{max(0, new_val):08x}"
        
        # 🔧 KEEPING THE NOTES EXACTLY AS THEY ARE
        # We ensure the internal \r\n are preserved as literal text
        flat_text = rest_of_text.replace('\r', '').replace('\n', r'\r\n')
        
        # STITCH IT UP 🧵
        print(f"{prefix}{new_addr_str}{flat_text}")

print("--- 🏴‍☠️ MISSION ACCOMPLISHED. SLAY. 🏴‍☠️ ---")
input("Press Enter to abandon ship...")
