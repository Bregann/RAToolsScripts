// LEGO Indiana Jones: The Original Adventures
// #ID = 11086

CurrentLevelID = dword_be(0x6bfe78)
LevelIDs = {
  0xffffffff: "Main Menu",
  0x00: "Barnett College",
  0x01: "The Lost Temple",
  0x02: "Into the Mountains",
  0x03: "City of Danger",
  0x04: "Well of Souls",
  0x05: "Pursuing the Ark",
  0x06: "Opening the Ark",
  0x08: "Shanghai Showdown",
  0x09: "Pankot Secrets",
  0x0a: "The Temple of Kali",
  0x0b: "Free the Slaves",
  0x0c: "Escape the Mines",
  0x0d: "Battle on the Bridge",
  0x0f: "The Hunt for Sir Richard",
  0x10: "Castle Rescue",
  0x11: "Motorcycle Escape",
  0x12: "Trouble in the Sky",
  0x13: "Desert Ambush",
  0x14: "Temple of the Grail",
  0x16: "Young Indy",
  0x17: "Ancient City",
  0x18: "Warehouse"
}

// -------------------- Level completions --------------------

function LevelComplete(achTitle, levelName, type, levelId, levelAddr) {
  achievement(
    title = achTitle,
    description = "Complete " + "\"" + levelName + "\"" + " in Story mode",
    type = type,
    points = 4,
    trigger = (
      CurrentLevelID == levelId &&
      byte(levelAddr) == 0x01 &&
      prev(byte(levelAddr) == 0x00)
    )
  )
}

function BonusLevelComplete(achTitle, levelName, levelId, levelAddr) {
  achievement(
    title = achTitle,
    description = "Complete the bonus level " + "\"" + levelName + "\"",
    points = 10,
    trigger = (
      CurrentLevelID == levelId &&
      byte(levelAddr) == 0x01 &&
      prev(byte(levelAddr) == 0x00)
    )
  )
}

LevelComplete("Don't Touch Anything!", "The Lost Temple", "Progression", 0x01, 0x5b0917)
LevelComplete("Cold Reception", "Into the Mountains", "Progression", 0x02, 0x5b0927)
LevelComplete("Monkey Business", "City of Danger", "Progression", 0x03, 0x5b0937)
LevelComplete("Why'd It Have to Be Snakes?", "The Well of Souls", "Progression", 0x04, 0x5b0947)
LevelComplete("Ark Chasing", "Pursuing the Ark", "Progression", 0x05, 0x5b0957)
LevelComplete("Shut Your Eyes, Marion", "Opening the Ark", "Progression", 0x06, 0x5b0967)

LevelComplete("Club Obi-Wan VIP", "Shanghai Showdown", "Progression", 0x08, 0x5b0987)
LevelComplete("Secrets Under Pankot", "Pankot Secrets", "Progression", 0x09, 0x5b0997)
LevelComplete("Hot Hot Hot", "The Temple of Kali", "Progression", 0x0a, 0x5b09a7)
LevelComplete("Breaking the Chains", "Free the Slaves", "Progression", 0x0b, 0x5b09b7)
LevelComplete("Mining Away", "Escape the Mines", "Progression", 0x0c, 0x5b09c7)
LevelComplete("Hanging by a Thread", "Battle on the Bridge", "Progression", 0x0d, 0x5b09d7)

LevelComplete("X Marks the Spot", "The Hunt for Sir Richard", "Progression", 0x0f, 0x5b09f7)
LevelComplete("Don't Call Me Junior!", "Castle Rescue", "Progression", 0x10, 0x5b0a07)
LevelComplete("This Belongs on a Racetrack!", "Motorcycle Escape", "Progression", 0x11, 0x5b0a17)
LevelComplete("Fly, Yes. Land, No.", "Trouble in the Sky", "Progression", 0x12, 0x5b0a27)
LevelComplete("Rollin' Through the Desert", "Desert Ambush", "Progression", 0x13, 0x5b0a37)
LevelComplete("Only the Penitent Man Shall Pass", "Temple of the Grail", "Win_Condition", 0x14, 0x5b0a47)

BonusLevelComplete("Every Legend Has a Beginning", "Young Indy", 0x16, 0x005b0a67)
BonusLevelComplete("City of Gold... and Plastic", "Ancient City", 0x17, 0x005b0a77)
BonusLevelComplete("Handle with Care", "Warehouse", 0x18, 0x005b0a87)

// -------------------- Level Collectibles --------------------
LostArkTA = 
byte(0x5b0915) + byte(0x5b0925) + byte(0x5b0935) + 
byte(0x5b0945) + byte(0x5b0955) + byte(0x5b0965)

TempleOfDoomTA = 
byte(0x5b0985) + byte(0x5b0995) + byte(0x5b09a5) + 
byte(0x5b09b5) + byte(0x5b09c5) + byte(0x5b09d5)

LastCrusadeTA = 
byte(0x5b09f5) + byte(0x5b0a05) + byte(0x5b0a15) + 
byte(0x5b0a25) + byte(0x5b0a35) + byte(0x5b0a45)

LostArkMK = 
byte(0x5b0919) + byte(0x5b0929) + byte(0x5b0939) + 
byte(0x5b0949) + byte(0x5b0959) + byte(0x5b0969)

TempleOfDoomMK = 
byte(0x5b0989) + byte(0x5b0999) + byte(0x5b09a9) + 
byte(0x5b09b9) + byte(0x5b09c9) + byte(0x5b09d9)

LastCrusadeMK = 
byte(0x5b09f9) + byte(0x5b0a09) + byte(0x5b0a19) + 
byte(0x5b0a29) + byte(0x5b0a39) + byte(0x5b0a49)

Parcels = 
bit7(0x5b091b) + bit7(0x5b092b) + bit7(0x5b093b) +
bit7(0x5b094b) + bit7(0x5b095b) + bit7(0x5b096b) +
bit7(0x5b098b) + bit7(0x5b099b) + bit7(0x5b09ab) +
bit7(0x5b09bb) + bit7(0x5b09cb) + bit7(0x5b09db) +
bit7(0x5b09fb) + bit7(0x5b0a0b) + bit7(0x5b0a1b) +
bit7(0x5b0a2b) + bit7(0x5b0a3b) + bit7(0x5b0a4b)


function LevelCollectibles(achTitle, achDesc, points, data, amount) {
  achievement(
    title = achTitle,
    description = achDesc,
    points = points,
    trigger = (
      CurrentLevelID != 0x00 &&
      CurrentLevelID != 0xffffffff && 
      data == amount &&
      prev(data) < amount
    )
  )
}

LevelCollectibles("Stud Filled Ark", "Reach True Adventurer status on every level in the \"Raiders of the Lost Ark\" episode", 10, LostArkTA, 6)
LevelCollectibles("Fortune and Glory, Kid", "Reach True Adventurer status on every level in the \"Temple of Doom\" episode", 10, TempleOfDoomTA, 6)
LevelCollectibles("Spend Wisely", "Reach True Adventurer status on every level in the \"The Last Crusade\" episode", 10, LastCrusadeTA, 6)

LevelCollectibles("The Ark-aeologist", "Collect all 60 treasures in the \"Raiders of the Lost Ark\" episode", 10, LostArkMK, 60)
LevelCollectibles("Temple of Treasure", "Collect all 60 treasures in the \"Temple of Doom\" episode", 10, TempleOfDoomMK, 60)
LevelCollectibles("It Belongs in a Museum!", "Collect all 60 treasures in the \"The Last Crusade\" episode", 10, LastCrusadeMK, 60)

LevelCollectibles("Express Delivery, Dr. Jones", "Collect every parcel across all levels", 25, Parcels, 18)

// -------------------- Shop Purchases --------------------
function ShopPurchases(achTitle, achDesc, points, data, amount){
  achievement(
    title = achTitle,
    description = achDesc,
    points = points,
    trigger = (
      CurrentLevelID == 0x00 &&
      data == amount &&
      prev(data) < amount
    )
  )
}

CharacterPurchases = 
bitcount(0x5b0dd8) + bitcount(0x5b0dd9) + bitcount(0x5b0dda) + 
bitcount(0x5b0ddb) + bitcount(0x5b0ddc) + bitcount(0x5b0ddd) + 
bitcount(0x5b0dde) + bitcount(0x5b0ddf)

RedParcelsPurchases = 
bitcount(0x5b0dff) + bitcount(0x5b0dfe) + bitcount(0x5b0dfd) +
bitcount(0x5b0dfc)

ShopPurchases("An Adventure Awaits!", "Purchase every character in the game", 25, CharacterPurchases, 60)
ShopPurchases("Bargain of the Lost Ark", "Purchase every parcel in the game", 10, RedParcelsPurchases, 25)

// -------------------- Misc --------------------
achievement(
  title = "The Archaeologist Awakens",
  description = "Find all 5 hidden Star Wars characters",
  points = 25,
  trigger = (
    CurrentLevelID != 0xffffffff &&
    bitcount(0x005b1055) == 5 &&
    prev(bitcount(0x005b1055) == 4)
  )
)

// -------------------- RP --------------------
function IsInMainMenu() => CurrentLevelID == 0xffffffff

rich_presence_conditional_display(IsInMainMenu(), "Preparing for an adventure...")
rich_presence_display("Adventuring in {0} [Studs: {1}] [True Adventurer: {2}/18] [Treasures: {3}/180] [Parcels: {4}/18]",
  rich_presence_lookup("Level", CurrentLevelID, LevelIDs),
  rich_presence_value("Studs", dword_be(0x5b0e10)),
  rich_presence_value("TrueAdventurer", LostArkTA + TempleOfDoomTA + LastCrusadeTA),
  rich_presence_value("Treasures", LostArkMK + TempleOfDoomMK + LastCrusadeMK),
  rich_presence_value("Parcels", Parcels)
)