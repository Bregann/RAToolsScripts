import re

# 👇 PASTE YOUR GIANT LIST OF N0 LINES BETWEEN THE TRIPLE QUOTES 👇
input_data = """
N0:0x100439ca:"[Bitflag] Profile 7 - Silver Box 13 Unlocked\r\nbit7 = Unlocked"
N0:0x100439cb:"[Bitflag] Profile 7 - Silver Box 14 Unlocked\r\nbit7 = Unlocked"
N0:0x100439cc:"[Bitflag] Profile 7 - Silver Box 15 Unlocked\r\nbit7 = Unlocked"
N0:0x100439cd:"[Bitflag] Profile 7 - Silver Box 16 Unlocked\r\nbit7 = Unlocked"
N0:0x100439ce:"[Bitflag] Profile 7 - Silver Box 17 Unlocked\r\nbit7 = Unlocked"
N0:0x100439cf:"[Bitflag] Profile 7 - Silver Box 18 Unlocked\r\nbit7 = Unlocked"
N0:0x100439d0:"[Bitflag] Profile 7 - Silver Box 19 Unlocked\r\nbit7 = Unlocked"
N0:0x100439d1:"[Bitflag] Profile 7 - Silver Box 20 Unlocked\r\nbit7 = Unlocked"
N0:0x100439d2:"[Bitflag] Profile 7 - Silver Box 21 Unlocked\r\nbit7 = Unlocked"
N0:0x100439d3:"[Bitflag] Profile 7 - Silver Box 22 Unlocked\r\nbit7 = Unlocked"
N0:0x100439d4:"[Bitflag] Profile 7 - Silver Box 23 Unlocked\r\nbit7 = Unlocked"
N0:0x100439d5:"[Bitflag] Profile 7 - Silver Box 24 Unlocked\r\nbit7 = Unlocked"
N0:0x100439d6:"[Bitflag] Profile 7 - Silver Box 25 Unlocked\r\nbit7 = Unlocked"
N0:0x100439d7:"[Bitflag] Profile 7 - Silver Box 26 Unlocked\r\nbit7 = Unlocked"
N0:0x100439d8:"[Bitflag] Profile 7 - Silver Box 27 Unlocked\r\nbit7 = Unlocked"
N0:0x100439d9:"[Bitflag] Profile 7 - Silver Box 28 Unlocked\r\nbit7 = Unlocked"
N0:0x100439da:"[Bitflag] Profile 7 - Silver Box 29 Unlocked\r\nbit7 = Unlocked"
N0:0x100439db:"[Bitflag] Profile 7 - Silver Box 30 Unlocked\r\nbit7 = Unlocked"
N0:0x100439dc:"[Bitflag] Profile 7 - Silver Box 31 Unlocked\r\nbit7 = Unlocked"
N0:0x100439dd:"[Bitflag] Profile 7 - Silver Box 32 Unlocked\r\nbit7 = Unlocked"
N0:0x100439de:"[Bitflag] Profile 7 - Silver Box 33 Unlocked\r\nbit7 = Unlocked"
N0:0x100439df:"[Bitflag] Profile 7 - Silver Box 34 Unlocked\r\nbit7 = Unlocked"
N0:0x100439e0:"[Bitflag] Profile 7 - Silver Box 35 Unlocked\r\nbit7 = Unlocked"
N0:0x100439e1:"[Bitflag] Profile 7 - Silver Box 36 Unlocked\r\nbit7 = Unlocked"
N0:0x100439e2:"[Bitflag] Profile 7 - Silver Box 37 Unlocked\r\nbit7 = Unlocked"
N0:0x100439e3:"[Bitflag] Profile 7 - Silver Box 38 Unlocked\r\nbit7 = Unlocked"
N0:0x100439e4:"[Bitflag] Profile 7 - Silver Box 39 Unlocked\r\nbit7 = Unlocked"
N0:0x100439e5:"[Bitflag] Profile 7 - Silver Box 40 Unlocked\r\nbit7 = Unlocked"
N0:0x100439e6:"[Bitflag] Profile 7 - Silver Box 41 Unlocked\r\nbit7 = Unlocked"
N0:0x100439e7:"[Bitflag] Profile 7 - Silver Box 42 Unlocked\r\nbit7 = Unlocked"
N0:0x100439e8:"[Bitflag] Profile 7 - Silver Box 43 Unlocked\r\nbit7 = Unlocked"
N0:0x100439e9:"[Bitflag] Profile 7 - Silver Box 44 Unlocked\r\nbit7 = Unlocked"
N0:0x100439ea:"[Bitflag] Profile 7 - Silver Box 45 Unlocked\r\nbit7 = Unlocked"
N0:0x100439eb:"[Bitflag] Profile 7 - Silver Box 46 Unlocked\r\nbit7 = Unlocked"
N0:0x100439ec:"[Bitflag] Profile 7 - Silver Box 47 Unlocked\r\nbit7 = Unlocked"
N0:0x100439ed:"[Bitflag] Profile 7 - Silver Box 48 Unlocked\r\nbit7 = Unlocked"
N0:0x100439ee:"[Bitflag] Profile 7 - Silver Box 49 Unlocked\r\nbit7 = Unlocked"
N0:0x100439ef:"[Bitflag] Profile 7 - Silver Box 50 Unlocked\r\nbit7 = Unlocked"
N0:0x100439f0:"[Bitflag] Profile 7 - Silver Box 51 Unlocked\r\nbit7 = Unlocked"
N0:0x100439f1:"[Bitflag] Profile 7 - Silver Box 52 Unlocked\r\nbit7 = Unlocked"
N0:0x100439f2:"[Bitflag] Profile 7 - Silver Box 53 Unlocked\r\nbit7 = Unlocked"
N0:0x100439f3:"[Bitflag] Profile 7 - Silver Box 54 Unlocked\r\nbit7 = Unlocked"
N0:0x100439f4:"[Bitflag] Profile 7 - Silver Box 55 Unlocked\r\nbit7 = Unlocked"
N0:0x100439f5:"[Bitflag] Profile 7 - Silver Box 56 Unlocked\r\nbit7 = Unlocked"
N0:0x100439f6:"[Bitflag] Profile 7 - Silver Box 57 Unlocked\r\nbit7 = Unlocked"
N0:0x100439f7:"[Bitflag] Profile 7 - Silver Box 58 Unlocked\r\nbit7 = Unlocked"
N0:0x100439f8:"[Bitflag] Profile 7 - Silver Box 59 Unlocked\r\nbit7 = Unlocked"
N0:0x100439f9:"[Bitflag] Profile 7 - Silver Box 60 Unlocked\r\nbit7 = Unlocked"
N0:0x100439fa:"[Bitflag] Profile 7 - Silver Box 61 Unlocked\r\nbit7 = Unlocked"
N0:0x100439fb:"[Bitflag] Profile 7 - Silver Box 62 Unlocked\r\nbit7 = Unlocked"
N0:0x100439fc:"[Bitflag] Profile 7 - Silver Box 63 Unlocked\r\nbit7 = Unlocked"
N0:0x100439fd:"[Bitflag] Profile 7 - Silver Box 64 Unlocked\r\nbit7 = Unlocked"
N0:0x100439fe:"[Bitflag] Profile 7 - Silver Box 65 Unlocked\r\nbit7 = Unlocked"
N0:0x100439ff:"[Bitflag] Profile 7 - Silver Box 66 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a00:"[Bitflag] Profile 7 - Silver Box 67 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a01:"[Bitflag] Profile 7 - Silver Box 68 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a02:"[Bitflag] Profile 7 - Silver Box 69 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a03:"[Bitflag] Profile 7 - Silver Box 70 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a04:"[Bitflag] Profile 7 - Silver Box 71 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a05:"[Bitflag] Profile 7 - Silver Box 72 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a06:"[Bitflag] Profile 7 - Silver Box 73 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a07:"[Bitflag] Profile 7 - Silver Box 74 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a08:"[Bitflag] Profile 7 - Silver Box 75 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a09:"[Bitflag] Profile 7 - Silver Box 76 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a0a:"[Bitflag] Profile 7 - Silver Box 77 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a0b:"[Bitflag] Profile 7 - Silver Box 78 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a0c:"[Bitflag] Profile 7 - Silver Box 79 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a0d:"[Bitflag] Profile 7 - Silver Box 80 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a0e:"[Bitflag] Profile 7 - Silver Box 81 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a0f:"[Bitflag] Profile 7 - Silver Box 82 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a10:"[Bitflag] Profile 7 - Silver Box 83 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a11:"[Bitflag] Profile 7 - Silver Box 84 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a12:"[Bitflag] Profile 7 - Silver Box 85 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a13:"[Bitflag] Profile 7 - Silver Box 86 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a14:"[Bitflag] Profile 7 - Silver Box 87 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a15:"[Bitflag] Profile 7 - Silver Box 88 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a16:"[Bitflag] Profile 7 - Silver Box 89 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a17:"[Bitflag] Profile 7 - Silver Box 90 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a28:"[Bitflag] Profile 7 - Gold Box 1 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a29:"[Bitflag] Profile 7 - Gold Box 2 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a2a:"[Bitflag] Profile 7 - Gold Box 3 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a2b:"[Bitflag] Profile 7 - Gold Box 4 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a2c:"[Bitflag] Profile 7 - Gold Box 5 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a2d:"[Bitflag] Profile 7 - Gold Box 6 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a2e:"[Bitflag] Profile 7 - Gold Box 7 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a2f:"[Bitflag] Profile 7 - Gold Box 8 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a30:"[Bitflag] Profile 7 - Gold Box 9 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a31:"[Bitflag] Profile 7 - Gold Box 10 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a32:"[Bitflag] Profile 7 - Gold Box 11 Unlocked\r\nbit7 = Unlocked"
N0:0x10043a33:"[Bitflag] Profile 7 - Gold Box 12 Unlocked\r\nbit7 = Unlocked"
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
