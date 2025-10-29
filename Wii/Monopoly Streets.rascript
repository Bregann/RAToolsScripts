// Monopoly Streets
// #ID = 35391

// -------------------- Data --------------------
RA_MASK = 0x1FFFFFFF

PropertyPointer = dword_be(0x0057aad0) & 0x1fffffff
GameDataPointer = dword_be(0x005287d4) & 0x1fffffff

Player1ProfileAward = dword_be(GameDataPointer + 0x09d8)
Player2ProfileAward = dword_be(GameDataPointer + 0x157c)
Player3ProfileAward = dword_be(GameDataPointer + 0x2120)
Player4ProfileAward = dword_be(GameDataPointer + 0x2cc4)

function IsInGame() => PropertyPointer != 0x00
function CurrentRuleSet() => dword_be(0x1285033c)

AiPlayer2Difficulty = dword_be(0x12850570)
AiPlayer3Difficulty = dword_be(0x12850574)
AiPlayer4Difficulty = dword_be(0x12850578)

function IsAgainstAIs(minAiType) => 
  dword_be(0x12850570) >= minAiType && dword_be(0x12850570) != 0xffffffff && 
  dword_be(0x12850574) >= minAiType && dword_be(0x12850574) != 0xffffffff &&
  dword_be(0x12850578) >= minAiType && dword_be(0x12850578) != 0xffffffff

function PlayerWonGame() => 
  IsInGame() && 
  Player1ProfileAward > Player2ProfileAward && 
  Player1ProfileAward > Player3ProfileAward && 
  Player1ProfileAward > Player4ProfileAward && 
  prev(Player1ProfileAward) == 0x00

function ptr(base, offsets, accessor=dword_be)
{
    val = base
    val = val & RA_MASK
    
    for i in range(0, length(offsets) - 1)
    {
        addr = val + offsets[i]
        if (i == length(offsets) - 1)
        {
            val = accessor(addr)
        }
        else
        {
            val = dword_be(addr)
            val = val & RA_MASK
        }
    }
    
    return val
}

MenuDataPointer = ptr(dword_be(0x00526888), [0x670, 0x30])

MonopolyBoards = [
  "monopolybl/zones/zone_world1.rpk", //monopoly city
  "monopolyworld/zones/zone_world1.rpk", // landmark city
  "monopolyclassic/zones/zone_world1.rpk", // classic board
  "monopolyclassiccardboard/zones/zone_world1.rpk", // cardboard board
  "monopolyclassiccheese/zones/zone_world1.rpk", // cheese board
  "monopolyclassicice/zones/zone_world1.rpk", // ice board
  "monopolyclassicjungle/zones/zone_world1.rpk", // jungle board
  "monopolyclassicplaza/zones/zone_world1.rpk", // plaza board
  "monopolyclassicsweet/zones/zone_world1.rpk" // sweet board
]

// -------------------- Game Wins --------------------
function GameWonAchievement(achTitle, ruleSet, ruleSetSelected){
  achievement(
    title = achTitle,
    description = "Win a game against any CPU difficulty on the \"" + ruleSet + "\" rule set",
    points = 5,
    type = "Progression",
    trigger = (
      PlayerWonGame() &&
      IsAgainstAIs(0x01) &&
      CurrentRuleSet() == ruleSetSelected
    )
  )
}

GameWonAchievement("A Classic Win", "Official MONOPOLY", 0x00)
GameWonAchievement("Gotta Roll Fast", "Speed Die", 0x01)
GameWonAchievement("Blink and You're Bankrupt", "Short Game", 0x02)
GameWonAchievement("Bidding out the Competition", "Bull Market", 0x03)
GameWonAchievement("The House Always Wins", "Jackpot", 0x04)
GameWonAchievement("Going Once, Going Twice...", "Fast Deal", 0x05)

achievement(
  title = "Master of All Trades",
  description = "Win an \"Official MONOPOLY\" rule set game against three AIs - one on Easy, one on Medium, and one on Hard difficulty",
  points = 10,
  trigger = (
    PlayerWonGame() &&
    ( // every possible combo as it's easier than using hits
      (AiPlayer2Difficulty == 0x01 &&
      AiPlayer3Difficulty == 0x02 &&
      AiPlayer4Difficulty == 0x03)
      ||
      (AiPlayer2Difficulty == 0x01 &&
      AiPlayer3Difficulty == 0x03 &&
      AiPlayer4Difficulty == 0x02)
      ||
      (AiPlayer2Difficulty == 0x02 &&
      AiPlayer3Difficulty == 0x01 &&
      AiPlayer4Difficulty == 0x03)
      ||
      (AiPlayer2Difficulty == 0x02 &&
      AiPlayer3Difficulty == 0x03 &&
      AiPlayer4Difficulty == 0x01)
      ||
      (AiPlayer2Difficulty == 0x03 &&
      AiPlayer3Difficulty == 0x01 &&
      AiPlayer4Difficulty == 0x02)
      ||
      (AiPlayer2Difficulty == 0x03 &&
      AiPlayer3Difficulty == 0x02 &&
      AiPlayer4Difficulty == 0x01)
    )
  )
)

// -------------------- Unlockables --------------------
function PurchaseUnlockable(achTitle, itemName, itemType, points, itemPos, itemUnlockAddr){
  achievement(
    title = achTitle,
  description = "Purchase the \"" + itemName + "\"" + itemType + " from the MONOPOLY Streets Store",
  points = points,
  trigger = (
    MenuDataPointer == itemPos &&
    itemUnlockAddr == 0x02 &&
    prev(itemUnlockAddr) == 0x00
  )
  )
}

PurchaseUnlockable("Officer on Board", "Cop Hat", "token", 5, 0x02, dword_be(0x12a7d0ac))
PurchaseUnlockable("Ironing out the Money", "Iron", "token", 3, 0x05, dword_be(0x12a7d0c4))
PurchaseUnlockable("Bag Secured", "Moneybag", "token", 4, 0x06, dword_be(0x12a7d0cc))

PurchaseUnlockable("Not Very Useful in the Rain!", "Cardboard Board", "board", 3, 0x02, dword_be(0x12a7d09c))
PurchaseUnlockable("Brie-lliant Investment", "Cheese Board", "board", 3, 0x03, dword_be(0x12a7d0a4))
PurchaseUnlockable("Perfect for Winter", "Ice Board", "board", 3, 0x04, dword_be(0x12a7d0dc))
PurchaseUnlockable("Welcome to the Jungle", "Jungle Board", "board", 3, 0x05, dword_be(0x12a7d0e4))
PurchaseUnlockable("Monopoly in the Park", "Plaza Board", "board", 3, 0x06, dword_be(0x12a7d0ec))
PurchaseUnlockable("Warning: Do Not Eat", "Sweet Board", "board", 4, 0x07, dword_be(0x12a7d0f4))
PurchaseUnlockable("A Famous Board", "Landmark City", "board", 5, 0x08, dword_be(0x12a7d0fc))

// -------------------- Property purchases --------------------

function PropertyHousePurchases(achTitle, boardName, boardColourGroup, propertyNames, propertyOwnerAddrs, propertyHotelAddrs, houseCount, boardAscii) {
  achievement(
    title = achTitle,
    description = "On the " + boardName + " using the \"Official MONOPOLY\" rule set, own and build hotels on all " + boardColourGroup + " properties (" + propertyNames + ")",
    points = 5,
    trigger = (
      IsInGame() &&
      CurrentRuleSet() == 0x00 &&
      ascii_string_equals(0x0060e56d, boardAscii) &&
      trigger_when(propertyOwnerAddrs == 0x00 &&
      propertyHotelAddrs == houseCount) &&
      prev(propertyHotelAddrs) < houseCount
    )
  )
}

BrownPropertyOwners = dword_be(PropertyPointer + 0x1c4) + dword_be(PropertyPointer + 0x1cc)
BrownPropertyHotels = dword_be(PropertyPointer + 0x264) + dword_be(PropertyPointer + 0x26c)
LightBluePropertyOwners = dword_be(PropertyPointer + 0x1d8) + dword_be(PropertyPointer + 0x1e0) + dword_be(PropertyPointer + 0x1e4)
LightBluePropertyHotels = dword_be(PropertyPointer + 0x278) + dword_be(PropertyPointer + 0x280) + dword_be(PropertyPointer + 0x284)
PinkPropertyOwners = dword_be(PropertyPointer + 0x1ec) + dword_be(PropertyPointer + 0x1f4) + dword_be(PropertyPointer + 0x1f8)
PinkPropertyHotels = dword_be(PropertyPointer + 0x28c) + dword_be(PropertyPointer + 0x294) + dword_be(PropertyPointer + 0x298)
OrangePropertyOwners = dword_be(PropertyPointer + 0x200) + dword_be(PropertyPointer + 0x208) + dword_be(PropertyPointer + 0x20c)
OrangePropertyHotels = dword_be(PropertyPointer + 0x2a0) + dword_be(PropertyPointer + 0x2a8) + dword_be(PropertyPointer + 0x2ac)
RedPropertyOwners = dword_be(PropertyPointer + 0x214) + dword_be(PropertyPointer + 0x21c) + dword_be(PropertyPointer + 0x220)
RedPropertyHotels = dword_be(PropertyPointer + 0x2b4) + dword_be(PropertyPointer + 0x2bc) + dword_be(PropertyPointer + 0x2c0)
YellowPropertyOwners = dword_be(PropertyPointer + 0x228) + dword_be(PropertyPointer + 0x22c) + dword_be(PropertyPointer + 0x234)
YellowPropertyHotels = dword_be(PropertyPointer + 0x2c8) + dword_be(PropertyPointer + 0x2cc) + dword_be(PropertyPointer + 0x2d4)
GreenPropertyOwners = dword_be(PropertyPointer + 0x23c) + dword_be(PropertyPointer + 0x240) + dword_be(PropertyPointer + 0x248)
GreenPropertyHotels = dword_be(PropertyPointer + 0x2dc) + dword_be(PropertyPointer + 0x2e0) + dword_be(PropertyPointer + 0x2e8)
DarkBluePropertyOwners = dword_be(PropertyPointer + 0x254) + dword_be(PropertyPointer + 0x25c)
DarkBluePropertyHotels = dword_be(PropertyPointer + 0x2f4) + dword_be(PropertyPointer + 0x2fc)

TrainsAndUtilityOwners = 
dword_be(PropertyPointer + 0x1d4) + dword_be(PropertyPointer + 0x1f0) + 
dword_be(PropertyPointer + 0x1fc) + dword_be(PropertyPointer + 0x21c) + 
dword_be(PropertyPointer + 0x230) + dword_be(PropertyPointer + 0x24c)

PropertyHousePurchases("Luxury on a Budget", "Classic Board", "brown", "Old Kent Road & Whitechapel Road", BrownPropertyOwners, BrownPropertyHotels, 10, MonopolyBoards[2])
PropertyHousePurchases("Sketchy Business", "Cardboard Board", "light blue", "Paint Pot Well, Crayon Corner & Stencil Square", LightBluePropertyOwners, LightBluePropertyHotels, 15, MonopolyBoards[3])
PropertyHousePurchases("Cheese, Gromit! Cheese!", "Cheese Board", "pink", "Cheddar, Wensleydale & Caerphilly", PinkPropertyOwners, PinkPropertyHotels, 15, MonopolyBoards[4])
PropertyHousePurchases("Bake It Till You Make It", "Sweet Board", "orange", "Chocolate Fudge Cake, Blueberry Muffin & Batternberg Cake", OrangePropertyOwners, OrangePropertyHotels, 15, MonopolyBoards[8])
PropertyHousePurchases("Whale of a Fortune", "Ice Board", "red", "Penguin Point, Seal Island & Whale Cove", RedPropertyOwners, RedPropertyHotels, 15, MonopolyBoards[5])
PropertyHousePurchases("Piccadilly Park", "Plaza", "yellow", "Leicester Square, Coventry Street & Piccadilly", YellowPropertyOwners, YellowPropertyHotels, 15, MonopolyBoards[7])
PropertyHousePurchases("Master of the High Street", "Landmark City", "green", "Regent Street, Oxford Street & Bond Street", GreenPropertyOwners, GreenPropertyHotels, 15, MonopolyBoards[1])
PropertyHousePurchases("Dangerous but Adventurous Investments", "Jungle Board", "dark blue", "Explorer's Path & Venom Creek", DarkBluePropertyOwners, DarkBluePropertyHotels, 10, MonopolyBoards[6])

achievement(
  title = "Master of Infrastructure",
  description = "Playing on the \"Official MONOPOLY\" rule set, own all four train stations and both utilities in a single game",
  points = 5,
  trigger = (
    IsInGame() &&
    CurrentRuleSet() == 0x00 &&
    trigger_when(TrainsAndUtilityOwners == 0x00) &&
    prev(TrainsAndUtilityOwners) != 0x00
  )
)

// -------------------- RP --------------------
RuleSets = {
  0x00: "Official MONOPOLY",
  0x01: "Speed Die",
  0x02: "Short Game",
  0x03: "Bull Market",
  0x04: "Jackpot",
  0x05: "Fast Deal"
}

ClassicBoardPosition = {
    0x00: "Go",
    0x01: "Old Kent Road",
    0x02: "Community Chest",
    0x03: "Whitechapel Road",
    0x04: "Income Tax",
    0x05: "Kings Cross Station",
    0x06: "The Angel, Islington",
    0x07: "Chance",
    0x08: "Euston Road",
    0x09: "Pentonville Road",
    0x0a: "Jail",
    0x0b: "Pall Mall",
    0x0c: "Electric Company",
    0x0d: "Whitehall",
    0x0e: "Northumberland Avenue",
    0x0f: "Marylebone Station",
    0x10: "Bow Street",
    0x11: "Community Chest",
    0x12: "Marlborough Street",
    0x13: "Vine Street",
    0x14: "Free Parking",
    0x15: "Strand",
    0x16: "Chance",
    0x17: "Fleet Street",
    0x18: "Trafalgar Square",
    0x19: "Fenchurch Street Station",
    0x1a: "Leicester Square",
    0x1b: "Coventry Street",
    0x1c: "Water Works",
    0x1d: "Piccadilly",
    0x1e: "Go to Jail",
    0x1f: "Regent Street",
    0x20: "Oxford Street",
    0x21: "Community Chest",
    0x22: "Bond Street",
    0x23: "Liverpool Street Station",
    0x24: "Chance",
    0x25: "Park Lane",
    0x26: "Super Tax",
    0x27: "Mayfair"
}

CardboardBoardPosition = {
    0x00: "Go",
    0x01: "Corrugation Street",
    0x02: "Community Chest",
    0x03: "Carboard Cottage",
    0x04: "Income Tax",
    0x05: "Paper Plane",
    0x06: "Paint Pot Well",
    0x07: "Chance",
    0x08: "Crayon Corner",
    0x09: "Stencil Square",
    0x0a: "Jail",
    0x0b: "Woolen Yard",
    0x0c: "Scissors",
    0x0d: "Cotton Wool Clouds",
    0x0e: "Knitted Knoll",
    0x0f: "Recyling Truck",
    0x10: "Staple Street",
    0x11: "Community Chest",
    0x12: "Sticky Tape Street",
    0x13: "Glitter Glue Glade",
    0x14: "Free Parking",
    0x15: "Tartan Highlands",
    0x16: "Chance",
    0x17: "Felt Flowers Field",
    0x18: "Patchwork Hill",
    0x19: "Papyrus Ship",
    0x1a: "Paper Mache Mountain",
    0x1b: "Crepe Paper Road",
    0x1c: "Glue",
    0x1d: "Paper Trail",
    0x1e: "Go to Jail",
    0x1f: "Button Farm",
    0x20: "Beads Barn",
    0x21: "Community Chest",
    0x22: "Stitch Crossing",
    0x23: "Button Bicycle",
    0x24: "Chance",
    0x25: "Paperchain Pond",
    0x26: "Super Tax",
    0x27: "Origami Orchard"
}

CheeseBoardPosition = {
    0x00: "Go",
    0x01: "Cottage Cheese",
    0x02: "Community Chest",
    0x03: "Mascarpone",
    0x04: "Income Tax",
    0x05: "Water Biscuit Barge",
    0x06: "Danish Blue",
    0x07: "Chance",
    0x08: "Roquefort",
    0x09: "Gorgonzola",
    0x0a: "Jail",
    0x0b: "Cheddar",
    0x0c: "Dairy Farm",
    0x0d: "Wensleydale",
    0x0e: "Caerphilly",
    0x0f: "Ploughman's Cart",
    0x10: "Mozzarella",
    0x11: "Community Chest",
    0x12: "Ricotta",
    0x13: "Parmesan",
    0x14: "Free Parking",
    0x15: "Edam",
    0x16: "Chance",
    0x17: "Red Leicester",
    0x18: "Double Gloucester",
    0x19: "Port Stilton",
    0x1a: "Brie",
    0x1b: "Camembert",
    0x1c: "Cracker Factory",
    0x1d: "Beaufort",
    0x1e: "Go to Jail",
    0x1f: "Emmental",
    0x20: "Gruyere",
    0x21: "Community Chest",
    0x22: "Raclette",
    0x23: "Cheese Wagon",
    0x24: "Chance",
    0x25: "Halloumi",
    0x26: "Super Tax",
    0x27: "Feta"
}

IceBoardPosition = {
    0x00: "Go",
    0x01: "Igloo Inlet",
    0x02: "Community Chest",
    0x03: "Inuit Retreat",
    0x04: "Income Tax",
    0x05: "Husky Sled",
    0x06: "Icicle Cave",
    0x07: "Chance",
    0x08: "White Star Iceberg",
    0x09: "Arctic Ice Bay",
    0x0a: "Jail",
    0x0b: "Yeti Plateau",
    0x0c: "Thermal Power",
    0x0d: "Polar Bear Mountain",
    0x0e: "Avalanche Peak",
    0x0f: "Snow Mobile",
    0x10: "Frostbite Ice Fields",
    0x11: "Community Chest",
    0x12: "Blizzard Plains",
    0x13: "Snowstorm Passage",
    0x14: "Free Parking",
    0x15: "Penguin Point",
    0x16: "Chance",
    0x17: "Seal Island",
    0x18: "Whale Cove",
    0x19: "Polar Skis",
    0x1a: "Amunden's Cliff",
    0x1b: "St. Nicholas' Glacier",
    0x1c: "Resarch Facility",
    0x1d: "Captain Scott's Shelf",
    0x1e: "Go to Jail",
    0x1f: "Reindeer's Beach",
    0x20: "Snow Fox Crevasse",
    0x21: "Community Chest",
    0x22: "Rockhopper Rock",
    0x23: "Ice Breaker",
    0x24: "Chance",
    0x25: "Icecap Cove",
    0x26: "Super Tax",
    0x27: "Aurora Plains"
}

JungleBoardPosition = {
    0x00: "Go",
    0x01: "Tribal Clearing",
    0x02: "Community Chest",
    0x03: "Temple Ruins",
    0x04: "Income Tax",
    0x05: "Swinging Vines",
    0x06: "Cascade Descent",
    0x07: "Chance",
    0x08: "Rocky Rapids",
    0x09: "Rainfall Basin",
    0x0a: "Jail",
    0x0b: "Treetop Plateau",
    0x0c: "Campfire",
    0x0d: "Canopy Heights",
    0x0e: "Mud Slide Mountain",
    0x0f: "River Kayak",
    0x10: "Inca Trail",
    0x11: "Community Chest",
    0x12: "Aztec Valley",
    0x13: "Mayan Delta",
    0x14: "Free Parking",
    0x15: "Snakebite Swamp",
    0x16: "Chance",
    0x17: "Crocodile Crossing",
    0x18: "Parrot's Perch",
    0x19: "Paddle Boat",
    0x1a: "Monkey Vines",
    0x1b: "Venus Flytrap Terrace",
    0x1c: "Waterfall",
    0x1d: "Leafy Grove",
    0x1e: "Go to Jail",
    0x1f: "Jaguar's Plateau",
    0x20: "Tiger Tropics",
    0x21: "Community Chest",
    0x22: "Leopard's Lagoon",
    0x23: "Sea Plane",
    0x24: "Chance",
    0x25: "Explorer's Path",
    0x26: "Super Tax",
    0x27: "Venom Creek"
}

SweetBoardPosition = {
    0x00: "Go",
    0x01: "Black Forest Gateaux",
    0x02: "Community Chest",
    0x03: "Trifle",
    0x04: "Income Tax",
    0x05: "Chew Chew Train",
    0x06: "Root Beer Barrels",
    0x07: "Chance",
    0x08: "Gobstopper",
    0x09: "Mints",
    0x0a: "Jail",
    0x0b: "Choc-Chip Cookie",
    0x0c: "Sugar Refinery",
    0x0d: "Shortcake",
    0x0e: "Chocolate Biscuits",
    0x0f: "Banana Split Boat",
    0x10: "Chocolate Fudge Cake",
    0x11: "Community Chest",
    0x12: "Blueberry Muffin",
    0x13: "Batternberg Cake",
    0x14: "Free Parking",
    0x15: "Cola Bottles",
    0x16: "Chance",
    0x17: "Jelly Sweets",
    0x18: "Licorice Assortments",
    0x19: "Jelly Jet",
    0x1a: "Honeycomb Cheesecake",
    0x1b: "Profiteroles",
    0x1c: "Cocoa Plant",
    0x1d: "Creme Brulee",
    0x1e: "Go to Jail",
    0x1f: "Viennese Truffle",
    0x20: "Hazelnut Caramel",
    0x21: "Community Chest",
    0x22: "Chocolate Marzipan",
    0x23: "Lolly Lorry",
    0x24: "Chance",
    0x25: "Candyfloss",
    0x26: "Super Tax",
    0x27: "Toffee Apple"
}
