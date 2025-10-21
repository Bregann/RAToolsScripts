// LEGO Pirates of the Caribbean: The Video Game
// #ID = 11090

OFFSET = 0x580

LevelID = {
  0x00: "Port",  // 1
  0x01: "Port Royal",
  0x02: "Tortuga",
  0x03: "The Black Pearl Attacks",
  0x04: "Smuggler's Den",
  0x05: "Isla De Muerta",
  0x07: "Pelegosto",  // 2
  0x08: "A Touch of Destiny",
  0x09: "The Dutchman's Secret",
  0x0a: "Isla Cruces",
  0x0b: "The Kraken",
  0x0d: "Singapore",  // 3
  0x0e: "Davy Jones' Locker",
  0x0f: "Norrington's Choice",
  0x10: "The Brethren Court",
  0x11: "The Maelstrom",
  0x13: "London Town",  // 4
  0x14: "Queen Anne's Revenge",
  0x15: "White Cap Bay",
  0x16: "A Spanish Legacy",
  0x17: "The Fountain of Youth",
  0x19: "The Ride" // bonus level
}

CurrentLevelID = dword_be(0x008102d0)
LastLoadedLevelID = dword_be(0x008102d4)
function LoadProtection() => LastLoadedLevelID != 0xffffffff && LastLoadedLevelID != CurrentLevelID

function Tally(data, offset = 0) {
  total = 0
  for item in data{
      total = total + byte(item + offset)
  }
  
  return total
}

function TallyPrev(data, offset = 0) {
  total = 0
  for item in data{
      total = total + prev(byte(item + offset))
  }
  
  return total
}

function TallyBitcount(data, offset = 0) {
  total = 0
  for item in data {
      total = total + bitcount(item + offset)
  }
  
  return total
}

function TallyPrevBitcount(data, offset = 0) {
  total = 0
  for item in data {
      total = total + prev(bitcount(item + offset))
  }
  
  return total
}

// ---------------------------------------- LEVEL PROGRESS ----------------------------------------
function LevelComplete(achTitle, levelName, type, levelId, levelAddr) {
  achievement(
    title = achTitle,
    description = "Complete " + "\"" + levelName + "\"" + " in Story mode",
    type = type,
    points = 4,
    trigger = (
      CurrentLevelID == levelId &&
      ((bit2(levelAddr) == 0x01 && prev(bit2(levelAddr)) == 0x00) ||
      (bit2(levelAddr + OFFSET) == 0x01 && prev(bit2(levelAddr + OFFSET)) == 0x00))
    )
  )
}

LevelComplete("Sailing Away", LevelID[0x01], "Progression", 0x01, 0x01080b96)
LevelComplete("Assembling a Crew", LevelID[0x02], "Progression", 0x02, 0x01080baa)
LevelComplete("It's the Pearl!", LevelID[0x03], "Progression", 0x03, 0x01080bbe)
LevelComplete("Smuggler's Den", LevelID[0x04], "Progression", 0x04, 0x01080bd2)
LevelComplete("Island of Death", LevelID[0x05], "Progression", 0x05, 0x01080be6)

LevelComplete("Escaping the Cannibals", LevelID[0x07], "Progression", 0x07, 0x01080c0e)
LevelComplete("A Visit to Tia Dalma", LevelID[0x08], "Progression", 0x08, 0x01080c22)
LevelComplete("The Dutchman's Secret", LevelID[0x09], "Progression", 0x09, 0x01080c36)
LevelComplete("Hunt for the Heart", LevelID[0x0a], "Progression", 0x0a, 0x01080c4a)
LevelComplete("Kraken Attack", LevelID[0x0b], "Progression", 0x0b, 0x01080c5e)

LevelComplete("Singapore", LevelID[0x0d], "Progression", 0x0d, 0x01080c86)
LevelComplete("Davy Jones' Locker", LevelID[0x0e], "Progression", 0x0e, 0x01080c9a)
LevelComplete("Norrington's Choice", LevelID[0x0f], "Progression", 0x0f, 0x01080cae)
LevelComplete("A Pirate Reunion", LevelID[0x10], "Progression", 0x10, 0x01080cc2)
LevelComplete("The Calypso Sea Battle", LevelID[0x11], "Progression", 0x11, 0x01080cd6)

LevelComplete("London Town", LevelID[0x13], "Progression", 0x13, 0x01080cfe)
LevelComplete("Queen Anne's Revenge", LevelID[0x14], "Progression", 0x14, 0x01080d12)
LevelComplete("Mermaid Beach", LevelID[0x15], "Progression", 0x15, 0x01080d26)
LevelComplete("A Spanish Visit", LevelID[0x16], "Progression", 0x16, 0x01080d3a)
LevelComplete("Finding the Fountain", LevelID[0x17], "Progression", 0x17, 0x01080d4e)

// ---------------------------------------- TRUE PIRATE ----------------------------------------
CurseOfBlackPearlTruePirate = [
  0x01080b90,
  0x01080ba4,
  0x01080bb8,
  0x01080bcc,
  0x01080be0
]

DeadMansChestTruePirate = [
  0x1080c09,
  0x1080c1d,
  0x1080c31,
  0x1080c45,
  0x1080c59
]

AtWorldsEndTruePirate = [
  0x1080c80,
  0x1080c94,
  0x1080ca8,
  0x1080cbc,
  0x1080cd0
]

OnStrangerTidesTruePirate = [
  0x1080cf8,
  0x1080d0c,
  0x1080d20,
  0x1080d34,
  0x1080d48
]

function TruePirateComplete(achTitle, episodeName, tpData){
  achievement(
    title = achTitle,
    description = "Reach True Pirate status on every level in the " + episodeName + " episode",
    points = 10,
    trigger = (
        (
          LoadProtection() &&
          Tally(tpData) == 0x05 &&
          TallyPrev(tpData) == 0x04) ||
        (
          LoadProtection() &&
          Tally(tpData, OFFSET) == 0x05 &&
          TallyPrev(tpData, OFFSET) == 0x04
        )
    )
  )
}

TruePirateComplete("Pirate of Fortune and Glory", "\"Curse of the Black Pearl\"", CurseOfBlackPearlTruePirate)
TruePirateComplete("I've Got a Jar of Studs", "\"Dead Man's Chest\"", DeadMansChestTruePirate)
TruePirateComplete("Nine Pieces of Studs", "\"At World's End\"", AtWorldsEndTruePirate)
TruePirateComplete("Studs of Youth", "\"On Stranger Tides\"", OnStrangerTidesTruePirate)

// ---------------------------------------- MINI KITS ----------------------------------------
CurseOfBlackPearlMinikits = [
  0x1080b93,
  0x1080ba7,
  0x1080bbb,
  0x1080bcf,
  0x1080be3
]

DeadMansChestMinikits = [
  0x1080c0b,
  0x1080c1f,
  0x1080c33,
  0x1080c47,
  0x1080c5b
]

AtWorldsEndMinikits = [
  0x1080c83,
  0x1080c97,
  0x1080cab,
  0x1080cbf,
  0x1080cd3
]

OnStrangerTidesMinikits = [
  0x1080cfb,
  0x1080d0f,
  0x1080d23,
  0x1080d37,
  0x1080d4b
]

function MinikitsComplete(achTitle, episodeName, mkData) {
  achievement(
    title = achTitle,
    description = "Collect all 50 minikits in the " + "\"" + episodeName + "\"" + " episode",
    points = 10,
    trigger = (
      (
        LoadProtection() &&
        Tally(mkData) == 0x32 &&
        TallyPrev(mkData) < 0x32
      ) ||
      (
        LoadProtection() &&
        Tally(mkData, OFFSET) == 0x32 &&
        TallyPrev(mkData, OFFSET) < 0x32
      )
    )
  )
}

MinikitsComplete("Cursed Minikits", "Curse of the Black Pearl", CurseOfBlackPearlMinikits)
MinikitsComplete("Minikit Kraken", "Dead Man's Chest", DeadMansChestMinikits)
MinikitsComplete("Nine Pieces of Eight? Try Ten Pieces of Plastic", "At World's End", AtWorldsEndMinikits)
MinikitsComplete("Stranger Minikits", "On Stranger Tides", OnStrangerTidesMinikits)

// ---------------------------------------- COMPASS PIECES ----------------------------------------
CurseOfBlackPearlCompassPieces = [
  0x1080b9a,
  0x1080bae,
  0x1080bc2,
  0x1080bd6,
  0x1080bea
]

DeadMansChestCompassPieces = [
  0x1080c12,
  0x1080c26,
  0x1080c3a,
  0x1080c4e,
  0x1080c62
]

AtWorldsEndCompassPieces = [
  0x1080c8a,
  0x1080c9e,
  0x1080cb2,
  0x1080cc6,
  0x1080cda
]

OnStrangerTidesCompassPieces = [
  0x1080d02,
  0x1080d16,
  0x1080d2a,
  0x1080d3e,
  0x1080d52
]

RedHats = [
  0x1081201,
  0x1081202,
  0x1081203
]

GoldBricks = byte(0x108122a)
GoldBricksOS = byte(0x108122a + OFFSET)

function CompassComplete(achTitle, episodeName, compassData) {
  achievement(
    title = achTitle,
    description = "Find all 40 Compass Items in the " + "\"" + episodeName + "\"" + " episode",
    points = 10,
    trigger = (
      (
        LoadProtection() &&
        TallyBitcount(compassData) == 40 &&
        TallyPrevBitcount(compassData) < 40
      ) 
      ||
      (
        LoadProtection() &&
        TallyBitcount(compassData, OFFSET) == 40 &&
        TallyPrevBitcount(compassData, OFFSET) < 40
      )
    )
  )
}

CompassComplete("It Points to What You Want Most", "Curse of the Black Pearl", CurseOfBlackPearlCompassPieces)
CompassComplete("The Compass Never Lies", "Dead Man's Chest", DeadMansChestCompassPieces)
CompassComplete("Path of the Pirate", "At World's End", AtWorldsEndCompassPieces)
CompassComplete("Seeker of Legend", "On Stranger Tide", OnStrangerTidesCompassPieces)

// ---------------------------------------- PURCHASES ----------------------------------------

Characters = [
  0x1083fee, 0x1083ff0, 0x1083ff1, 0x1083ffa, 0x1083ffb, 0x1083ffc, 0x1083ffd,
  0x1083ffe, 0x1083fff, 0x1084000, 0x1084001, 0x1084006, 0x1084007, 0x1084008,
  0x1084009, 0x108400a, 0x108400b, 0x108400c, 0x108400d, 0x108400e, 0x1084010,
  0x1084011, 0x1084012, 0x1084013, 0x1084014, 0x1084015, 0x1084016, 0x1084017,
  0x1084018, 0x1084019, 0x108401e, 0x108401f, 0x1084021, 0x1084022, 0x1084023,
  0x1084024, 0x1084025, 0x108402a, 0x108402b, 0x108402c, 0x1084030, 0x1084037,
  0x108403b, 0x108403c, 0x108403d, 0x108403e, 0x108403f, 0x1084040, 0x1084041,
  0x1084042, 0x1084043, 0x1084044, 0x1084045, 0x1084046, 0x1084048, 0x1084049,
  0x108404a, 0x108404b, 0x108404c, 0x108404d, 0x108404f, 0x1084050, 0x1084051,
  0x1084059, 0x108405b, 0x1084066, 0x1084067, 0x1084068, 0x108406d, 0x108406f,
  0x108407b, 0x108407c, 0x108407d, 0x1084083, 0x1084090, 0x10840b6
]

function Purchases(achTitle, achDesc, points, data, amount) {
  achievement(
    title = achTitle,
    description = achDesc,
    points = points,
    trigger = (
      (
        LoadProtection() &&
        Tally(data) >= amount &&
        TallyPrev(data) < amount
      ) 
      ||
      (
        LoadProtection() &&
        Tally(data, OFFSET) >= amount &&
        TallyPrev(data, OFFSET) < amount
      )
    )
  )
}

Purchases("Plundering Party", "Unlock 50% of the characters in the game", 10, Characters, 38)
Purchases("Part of the Ship, Part of the Crew", "Unlock 100% of the characters in the game", 10, Characters, 76)

achievement(
  title = "Captain Jack… Now With Rhythm!",
  description = "Use the code \"VDJSPW\" to unlock a musical Jack Sparrow",
  points = 2,
  trigger = (
    (
      LoadProtection() &&
      prev(byte(0x010840b6)) == 0x00 &&
      byte(0x010840b6) == 0x01
    ) ||
    (
      LoadProtection() &&
      prev(byte(0x010840b6 + OFFSET)) == 0x00 &&
      byte(0x010840b6 + OFFSET) == 0x01
    )
  )
)

// Misc bits
achievement(
  title = "Tools of a True Pirate",
  description = "Unlock and purchase all 20 Red Hats",
  points = 25,
  trigger = (
    (
      LoadProtection() &&
      TallyBitcount(RedHats) == 20 &&
      TallyPrevBitcount(RedHats) == 19
    ) ||
    (
      LoadProtection() &&
      TallyBitcount(RedHats, OFFSET) == 20 &&
      TallyPrevBitcount(RedHats, OFFSET) == 19
    )
  )
)

achievement(
  title = "A Gold Plundering Pirate",
  description = "Collect all 85 Gold Bricks",
  points = 25,
  trigger = (
    (
      LoadProtection() &&
      GoldBricks == 85 &&
      prev(GoldBricks) < 85
    ) ||
    (
      LoadProtection() &&
      GoldBricksOS == 85 &&
      prev(GoldBricksOS) < 85
    ) 
  )
)

achievement(
  title = "Hold My Grog, I Got This",
  description = "Complete the bonus level \"The Ride\"",
  points = 5,
  trigger = (
    (
      CurrentLevelID == 0x19 &&
      bit3(0x01080d76) == 0x01 &&
      prev(bit3(0x01080d76) == 0x00)
    ) ||
    (
      CurrentLevelID == 0x19 &&
      bit3(0x01080d76 + OFFSET) == 0x01 &&
      prev(bit3(0x01080d76 + OFFSET) == 0x00)
    )
  )
)

// ------------------------ RP ------------------------
function IsInMainMenu() => (dword_be(0x008102d0) == 0x01 && prior(dword_be(0x008102d0) == 0xffffffff)) || dword_be(0x008102d0) == 0xffffffff
function IsInPort() => CurrentLevelID == 0x00
rich_presence_conditional_display(IsInMainMenu(), "Captain Jack Sparrow and the crew are preparing to plunder ☠️")
rich_presence_conditional_display(IsInPort(), "Captain Jack Sparrow and the crew are exploring the port 🏴‍☠️☠️")
rich_presence_display("Plundering studs in {0} 🏴‍☠️ [gold bricks: {1}]",
    rich_presence_lookup("Level", CurrentLevelID, LevelID),
    rich_presence_value("GoldBricks", GoldBricks + GoldBricksOS)
)