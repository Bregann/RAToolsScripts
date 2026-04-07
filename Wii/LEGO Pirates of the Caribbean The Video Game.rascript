// LEGO Pirates of the Caribbean: The Video Game
// #ID = 11090

// ---------------------------------------- MEMORY ----------------------------------------

RA_MASK = 0x1FFFFFFF

function ChainPointer(base, offsets, accessor=dword_be)
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

BasePointer = dword_be(0x108458)
function SaveData(offset, accessor) => ChainPointer(BasePointer, [0x5394, offset], accessor)

// ---------------------------------------- LEVEL DATA ----------------------------------------

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
function LoadProtection() => LastLoadedLevelID != 0xffffffff && CurrentLevelID == 0x00 && CurrentLevelID != 0xffffffff
function GoldBrickProtection() => LastLoadedLevelID != 0xffffffff && CurrentLevelID != 0xffffffff

function IsChapter1() => CurrentLevelID >= 0x01 && CurrentLevelID <= 0x05
function IsChapter2() => CurrentLevelID >= 0x07 && CurrentLevelID <= 0x0b
function IsChapter3() => CurrentLevelID >= 0x0d && CurrentLevelID <= 0x11
function IsChapter4() => CurrentLevelID >= 0x13 && CurrentLevelID <= 0x17

// ---------------------------------------- TALLY FUNCTIONS ----------------------------------------

function Tally(offsets) {
  total = 0
  for off in offsets {
    total = total + SaveData(off, byte)
  }
  return total
}

function TallyPrev(offsets) {
  total = 0
  for off in offsets {
    total = total + prev(SaveData(off, byte))
  }
  return total
}

function TallyBitcount(offsets) {
  total = 0
  for off in offsets {
    total = total + SaveData(off, bitcount)
  }
  return total
}

function TallyPrevBitcount(offsets) {
  total = 0
  for off in offsets {
    total = total + prev(SaveData(off, bitcount))
  }
  return total
}

// ---------------------------------------- LEVEL PROGRESS ----------------------------------------

function LevelComplete(achTitle, levelName, type, levelId, progressOffset) {
  achievement(
    title = achTitle,
    description = "Complete \"" + levelName + "\" in Story mode",
    type = type,
    points = 4,
    trigger = (
      CurrentLevelID == levelId &&
      SaveData(progressOffset, bit2) == 0x01 &&
      prev(SaveData(progressOffset, bit2)) == 0x00
    )
  )
}

// Curse of the Black Pearl
LevelComplete("Sailing Away", LevelID[0x01], "Progression", 0x01, 0x1e)
LevelComplete("Assembling a Crew", LevelID[0x02], "Progression", 0x02, 0x32)
LevelComplete("It's the Pearl!", LevelID[0x03], "Progression", 0x03, 0x46)
LevelComplete("Smuggler's Den", LevelID[0x04], "Progression", 0x04, 0x5a)
LevelComplete("Island of Death", LevelID[0x05], "Progression", 0x05, 0x6e)

// Dead Man's Chest
LevelComplete("Escaping the Cannibals", LevelID[0x07], "Progression", 0x07, 0x96)
LevelComplete("A Visit to Tia Dalma", LevelID[0x08], "Progression", 0x08, 0xaa)
LevelComplete("The Dutchman's Secret", LevelID[0x09], "Progression", 0x09, 0xbe)
LevelComplete("Hunt for the Heart", LevelID[0x0a], "Progression", 0x0a, 0xd2)
LevelComplete("Kraken Attack", LevelID[0x0b], "Progression", 0x0b, 0xe6)

// At World's End
LevelComplete("Singapore", LevelID[0x0d], "Progression", 0x0d, 0x10e)
LevelComplete("Davy Jones' Locker", LevelID[0x0e], "Progression", 0x0e, 0x122)
LevelComplete("Norrington's Choice", LevelID[0x0f], "Progression", 0x0f, 0x136)
LevelComplete("A Pirate Reunion", LevelID[0x10], "Progression", 0x10, 0x14a)
LevelComplete("The Calypso Sea Battle", LevelID[0x11], "Progression", 0x11, 0x15e)

// On Stranger Tides
LevelComplete("London Town", LevelID[0x13], "Progression", 0x13, 0x186)
LevelComplete("Queen Anne's Revenge", LevelID[0x14], "Progression", 0x14, 0x19a)
LevelComplete("Mermaid Beach", LevelID[0x15], "Progression", 0x15, 0x1ae)
LevelComplete("A Spanish Visit", LevelID[0x16], "Progression", 0x16, 0x1c2)
LevelComplete("Finding the Fountain", LevelID[0x17], "Progression", 0x17, 0x1d6)

// ---------------------------------------- TRUE PIRATE ----------------------------------------

CurseOfBlackPearlTruePirate = [0x18, 0x2c, 0x40, 0x54, 0x68]
DeadMansChestTruePirate = [0x91, 0xa5, 0xb9, 0xcd, 0xe1]
AtWorldsEndTruePirate = [0x108, 0x11c, 0x130, 0x144, 0x158]
OnStrangerTidesTruePirate = [0x180, 0x194, 0x1a8, 0x1bc, 0x1d0]

function TruePirateComplete(achTitle, episodeName, tpOffsets, ChapterProtection) {
  achievement(
    title = achTitle,
    description = "Reach True Pirate status on every level in the " + episodeName + " episode",
    points = 10,
    trigger = (
      ChapterProtection &&
      measured(Tally(tpOffsets) == 0x05) &&
      TallyPrev(tpOffsets) == 0x04
    )
  )
}

TruePirateComplete("Pirate of Fortune and Glory", "\"Curse of the Black Pearl\"", CurseOfBlackPearlTruePirate, IsChapter1())
TruePirateComplete("I've Got a Jar of Studs", "\"Dead Man's Chest\"", DeadMansChestTruePirate, IsChapter2())
TruePirateComplete("Nine Pieces of Studs", "\"At World's End\"", AtWorldsEndTruePirate, IsChapter3())
TruePirateComplete("Studs of Youth", "\"On Stranger Tides\"", OnStrangerTidesTruePirate, IsChapter4())

// ---------------------------------------- MINI KITS ----------------------------------------

CurseOfBlackPearlMinikits = [0x1b, 0x2f, 0x43, 0x57, 0x6b]
DeadMansChestMinikits = [0x93, 0xa7, 0xbb, 0xcf, 0xe3]
AtWorldsEndMinikits = [0x10b, 0x11f, 0x133, 0x147, 0x15b]
OnStrangerTidesMinikits = [0x183, 0x197, 0x1ab, 0x1bf, 0x1d3]

function MinikitsComplete(achTitle, episodeName, mkOffsets, ChapterProtection) {
  achievement(
    title = achTitle,
    description = "Collect all 50 minikits in the \"" + episodeName + "\" episode",
    points = 10,
    trigger = (
      ChapterProtection &&
      measured(Tally(mkOffsets) == 0x32) &&
      TallyPrev(mkOffsets) < 0x32
    )
  )
}

MinikitsComplete("Cursed Minikits", "Curse of the Black Pearl", CurseOfBlackPearlMinikits, IsChapter1())
MinikitsComplete("Minikit Kraken", "Dead Man's Chest", DeadMansChestMinikits, IsChapter2())
MinikitsComplete("Nine Pieces of Eight? Try Ten Pieces of Plastic", "At World's End", AtWorldsEndMinikits, IsChapter3())
MinikitsComplete("Stranger Minikits", "On Stranger Tides", OnStrangerTidesMinikits, IsChapter4())

// ---------------------------------------- COMPASS PIECES ----------------------------------------

CurseOfBlackPearlCompassPieces = [0x22, 0x36, 0x4a, 0x5e, 0x72]
DeadMansChestCompassPieces = [0x9a, 0xae, 0xc2, 0xd6, 0xea]
AtWorldsEndCompassPieces = [0x112, 0x126, 0x13a, 0x14e, 0x162]
OnStrangerTidesCompassPieces = [0x18a, 0x19e, 0x1b2, 0x1c6, 0x1da]

RedHatOffsets = [0x689, 0x68a, 0x68b]

GoldBricks = SaveData(0x6b2, byte)

function CompassComplete(achTitle, episodeName, compassOffsets, ChapterProtection) {
  achievement(
    title = achTitle,
    description = "Find all 40 Compass Items in the \"" + episodeName + "\" episode",
    points = 10,
    trigger = (
      ChapterProtection &&
      TallyBitcount(compassOffsets) == 40 &&
      TallyPrevBitcount(compassOffsets) < 40
    )
  )
}

CompassComplete("It Points to What You Want Most", "Curse of the Black Pearl", CurseOfBlackPearlCompassPieces, IsChapter1())
CompassComplete("The Compass Never Lies", "Dead Man's Chest", DeadMansChestCompassPieces, IsChapter2())
CompassComplete("Path of the Pirate", "At World's End", AtWorldsEndCompassPieces, IsChapter3())
CompassComplete("Seeker of Legend", "On Stranger Tides", OnStrangerTidesCompassPieces, IsChapter4())

// ---------------------------------------- PURCHASES ----------------------------------------

CharacterOffsets = [
  0x3476, 0x3478, 0x3479, 0x3482, 0x3483, 0x3484, 0x3485, 0x3486, 0x3487, 0x3488, 0x3489,
  0x348e, 0x348f, 0x3490, 0x3491, 0x3492, 0x3493, 0x3494, 0x3495, 0x3496, 0x3498,
  0x3499, 0x349a, 0x349b, 0x349c, 0x349d, 0x349e, 0x349f, 0x34a0, 0x34a1,
  0x34a6, 0x34a7, 0x34a9, 0x34aa, 0x34ab, 0x34ac, 0x34ad,
  0x34b2, 0x34b3, 0x34b4, 0x34b8, 0x34bf,
  0x34c3, 0x34c4, 0x34c5, 0x34c6, 0x34c7, 0x34c8, 0x34c9, 0x34ca, 0x34cb, 0x34cc, 0x34cd, 0x34ce,
  0x34d0, 0x34d1, 0x34d2, 0x34d3, 0x34d4, 0x34d5, 0x34d7, 0x34d8, 0x34d9,
  0x34e1, 0x34e3, 0x34ee, 0x34ef, 0x34f0, 0x34f5, 0x34f7,
  0x3503, 0x3504, 0x3505, 0x350b,
  0x3518,
  0x353e,
  0x33FE, 0x348A, 0x34A5, 0x34b5
]

function Purchases(achTitle, achDesc, points, charOffsets, amount) {
  achievement(
    title = achTitle,
    description = achDesc,
    points = points,
    trigger = (
      (
        LastLoadedLevelID != 0xffffffff
        ||
        (
          LastLoadedLevelID != 0x01 &&
          CurrentLevelID != 0x01
        )
      )
      &&
      measured(Tally(charOffsets) >= amount) &&
      TallyPrev(charOffsets) >= amount - 5 &&
      TallyPrev(charOffsets) < amount
    )
  )
}

Purchases("Plundering Party", "Unlock 50% of the characters in the game", 10, CharacterOffsets, 40)
Purchases("Part of the Ship, Part of the Crew", "Unlock 100% of the characters in the game", 10, CharacterOffsets, 80)

achievement(
  title = "Captain Jack... Now With Rhythm!",
  description = "Use the code \"VDJSPW\" to unlock a musical Jack Sparrow when in the Port",
  points = 2,
  trigger = (
    CurrentLevelID == 0x00 &&
    prev(SaveData(0x353e, byte)) == 0x00 &&
    SaveData(0x353e, byte) == 0x01
  )
)

// Misc bits
achievement(
  title = "Tools of a True Pirate",
  description = "Unlock and purchase all 20 Red Hats",
  points = 25,
  trigger = (
    LoadProtection() &&
    TallyBitcount(RedHatOffsets) == 20 &&
    TallyPrevBitcount(RedHatOffsets) == 19
  )
)

achievement(
  title = "A Gold Plundering Pirate",
  description = "Collect all 85 Gold Bricks",
  points = 25,
  trigger = (
    GoldBrickProtection() &&
    GoldBricks == 85 &&
    prev(GoldBricks) >= 80 &&
    prev(GoldBricks) <= 84
  )
)

achievement(
  title = "Hold My Grog, I Got This",
  description = "Complete the bonus level \"The Ride\"",
  points = 5,
  trigger = (
    CurrentLevelID == 0x19 &&
    SaveData(0x1fe, bit3) == 0x01 &&
    prev(SaveData(0x1fe, bit3)) == 0x00
  )
)

// ---------------------------------------- RICH PRESENCE ----------------------------------------

AllTruePirateOffsets = [
  0x18, 0x2c, 0x40, 0x54, 0x68,
  0x91, 0xa5, 0xb9, 0xcd, 0xe1,
  0x108, 0x11c, 0x130, 0x144, 0x158,
  0x180, 0x194, 0x1a8, 0x1bc, 0x1d0
]

AllMinikitOffsets = [
  0x1b, 0x2f, 0x43, 0x57, 0x6b,
  0x93, 0xa7, 0xbb, 0xcf, 0xe3,
  0x10b, 0x11f, 0x133, 0x147, 0x15b,
  0x183, 0x197, 0x1ab, 0x1bf, 0x1d3
]

TotalTruePirate = Tally(AllTruePirateOffsets)
TotalMinikits = Tally(AllMinikitOffsets)
TotalCharacters = Tally(CharacterOffsets)

function IsInMainMenu() => (dword_be(0x008102d0) == 0x01 && prior(dword_be(0x008102d0) == 0xffffffff)) || dword_be(0x008102d0) == 0xffffffff
function IsInPort() => CurrentLevelID == 0x00

rich_presence_conditional_display(IsInMainMenu(), "Captain Jack Sparrow and the crew are preparing to plunder ☠️")

rich_presence_conditional_display(IsInPort(), "Exploring the port 🏴‍☠️☠️ [🧱 {0}/85] [🏴‍☠️☠️ {1}/20] [🧩 {2}/200] [👤 {3}/80]",
    rich_presence_value("GoldBricks", GoldBricks),
    rich_presence_value("TruePirate", TotalTruePirate),
    rich_presence_value("Minikits", TotalMinikits),
    rich_presence_value("Characters", TotalCharacters)
)

rich_presence_display("Plundering studs in {0} 🏴‍☠️☠️ [🧱 {1}/85] [🏴‍☠️☠️ {2}/20] [🧩 {3}/200] [👤 {4}/80]",
    rich_presence_lookup("Level", CurrentLevelID, LevelID),
    rich_presence_value("GoldBricks", GoldBricks),
    rich_presence_value("TruePirate", TotalTruePirate),
    rich_presence_value("Minikits", TotalMinikits),
    rich_presence_value("Characters", TotalCharacters)
)