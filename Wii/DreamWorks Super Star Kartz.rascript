// DreamWorks Super Star Kartz
// #ID = 34609

// -------------------- Game Data --------------------

function IsInGame() => dword_be(0x0057f964) != 0x00
function CurrentLevel() => 0x00585d8d
function CurrentMode() => dword_be(0x0058438c)

RaceDataPointer = dword_be(0x0057f964) & 0x1fffffff
function CurrentLap() => dword_be(RaceDataPointer + 0x2C)  + 1
function CurrentLapPrev() => prev(dword_be(RaceDataPointer + 0x2C))  + 1
function RaceTimer() => float_be(RaceDataPointer + 0x54)

CupDataDict = {
  0x10793cbc: 0x10793cc0,
  0x10793cc8: 0x10793ccc,
  0x10793cd4: 0x10793cd8,
  0x10793ce0: 0x10793ce4,
  0x10793cec: 0x10793cf0,
  0x10793cf8: 0x10793cfc,
  0x10793d04: 0x10793d08,
  0x10793d10: 0x10793d14,
  0x10793d1c: 0x10793d20,
  0x10793d28: 0x10793d2c,
  0x10793d34: 0x10793d38,
  0x10793d40: 0x10793d44,
  0x10793d4c: 0x10793d50,
  0x10793d58: 0x10793d5c,
  0x10793d64: 0x10793d68,
  0x10793d70: 0x10793d74
}

DreamworksIcons = [
  0x10793b8c,
  0x10793b90,
  0x10793b94,
  0x10793b98,
  0x10793b9c,
  0x10793ba0,
  0x10793ba4,
  0x10793ba8,
  0x10793bac,
  0x10793bb0,
  0x10793bb4,
  0x10793bb8,
  0x10793bbc,
  0x10793bc0,
  0x10793bc4,
  0x10793bc8,
  0x10793bcc,
  0x10793bd0,
  0x10793bd4,
  0x10793bd8,
  0x10793bdc,
  0x10793be0,
  0x10793be4,
  0x10793be8
]

ChallengesCompleted = [
  0x10793c2c,
  0x10793c30,
  0x10793c34,
  0x10793c38,
  0x10793c3c,
  0x10793c40,
  0x10793c44,
  0x10793c48,
  0x10793c4c,
  0x10793c50,
  0x10793c54,
  0x10793c58,
  0x10793c5c,
  0x10793c60,
  0x10793c64,
  0x10793c68,
  0x10793c6c,
  0x10793c70,
  0x10793c74,
  0x10793c78,
  0x10793c7c,
  0x10793c80,
  0x10793c84,
  0x10793c88,
  0x10793c8c,
  0x10793c90,
  0x10793c94,
  0x10793c98,
  0x10793c9c,
  0x10793ca0,
  0x10793ca4,
  0x10793ca8,
  0x10793cac,
  0x10793cb0,
  0x10793cb4,
  0x10793cb8
]

CupInfo = {
  0x11: ["Wind Cup", "50cc", 3, 0x11],
  0x12: ["Wind Cup", "100cc", 4, 0x12], 
  0x13: ["Wind Cup", "150cc", 5, 0x13],
  0x14: ["Wind Cup", "Mirror", 5, 0x14],
 
  0x21: ["Cloud Cup", "50cc", 3, 0x21],
  0x22: ["Cloud Cup", "100cc", 4, 0x22],
  0x23: ["Cloud Cup", "150cc", 5, 0x23],
  0x24: ["Cloud Cup", "Mirror", 5, 0x24],

  0x31: ["Sun Cup", "50cc", 3, 0x31],
  0x32: ["Sun Cup", "100cc", 4, 0x32],
  0x33: ["Sun Cup", "150cc", 5, 0x33],
  0x34: ["Sun Cup", "Mirror", 5, 0x34],

  0x41: ["Moon Cup", "50cc", 3, 0x41],
  0x42: ["Moon Cup", "100cc", 4, 0x42],
  0x43: ["Moon Cup", "150cc", 5, 0x43],
  0x44: ["Moon Cup", "Mirror", 5, 0x44]
}

LevelAscii = {
  "Shrek_Swamp.wad": "Shrek's Swamp",
  "Madagascar.wad": "Madagascar",
  "DragonsNest.wad": "Dragon Island",
  "FarFarAway.wad": "Far Far Away",
  "Zoo.wad": "New York City Zoo",
  "Gallaxhar.wad": "Gallaxhar's Spaceship",
  "Africa.wad": "Africa",
  "IsleOfBerk.wad": "Isle Of Berk",
  "DragonsKeep.wad": "Dragon's Keep"
}

// -------------------- Cup Wins --------------------

function WinCircuitCup(cupName, ccType, points, cupIdentifier){
  achievement(
    title = cupName + " " +  ccType + " Champion",
    description = "Earn the Gold Cup on the " + cupName + " circuit in the " + ccType + " class",
    points = points,
    type = "Progression",
    trigger = (
      IsInGame() &&
      any_of(CupDataDict, i => 
        dword_be(CupDataDict[i]) == 0x03 && 
        dword_be(i) == cupIdentifier && 
        prev(dword_be(CupDataDict[i])) != 0x03
      )
    )
  )
}

for i in CupInfo{
  WinCircuitCup(CupInfo[i][0], CupInfo[i][1], CupInfo[i][2], CupInfo[i][3])
}

// -------------------- Collectibles --------------------
function CollectCollectibles(achName, mapName, val1, val2){
  achievement(
    title = achName,
    description = "Collect both hidden DreamWorks Icons on " + mapName,
    points = 3,
    trigger = (
      IsInGame() &&
      (
        any_of(DreamworksIcons, i => dword_be(i) == val1 && prev(dword_be(i) == 0x00))
        || 
        any_of(DreamworksIcons, i => dword_be(i) == val2 && prev(dword_be(i) == 0x00))
      )
      &&
      any_of(DreamworksIcons, i => dword_be(i) == val1)
      &&
      any_of(DreamworksIcons, i => dword_be(i) == val2)
    )
  )
}

CollectCollectibles("Ogre Achiever", "Shrek's Swamp", 0xf736760f, 0xf7367610)
CollectCollectibles("Island Icon Hunter", "Madagascar", 0xbe21d79d, 0xbe21d79e)
CollectCollectibles("How to Hoard Your Dragon", "Dragon Island", 0x52ee718d, 0x52ee718e)
CollectCollectibles("The Fairest Collector of Them All", "Far Far Away", 0xbe466937, 0xbe466938)
CollectCollectibles("Concrete Jungle Collectathon", "New York City Zoo", 0x0fe87dc0, 0x0fe87dc1)
CollectCollectibles("Extra-Terrestrial Icon Hunter", "Gallaxhar's Spaceship", 0x3b58a95a, 0x3b58a95b)
CollectCollectibles("Icon King of the Savannah", "Africa", 0x66b5c926, 0x66b5c927)
CollectCollectibles("Icons of Berk", "Island Of Berk", 0xa589d9d1, 0xa589d9d2)
CollectCollectibles("Under the Dragon’s Watch", "Dragon's Keep", 0x7ec5f071, 0x7ec5f072)
CollectCollectibles("Midnight Icon Hunt in the Swamp", "Shrek's Swamp Night", 0x45e5978d, 0x45e5978e)
CollectCollectibles("Berk's Hidden Icons", "Island Of Berk Night", 0xb58f4687, 0xb58f4688)
CollectCollectibles("Safari After Dark", "Africa Night", 0xb92436b0, 0xb92436af)

// -------------------- Challenges --------------------
function ChallengesCompleted(achName, challengeName, vals){
  achievement(
    title = achName,
    description = "Complete all the races in the " + challengeName + " challenge category",
    points = 10,
    trigger = (
      IsInGame() &&
      (
        any_of(ChallengesCompleted, i => dword_be(i) == vals[0] && prev(dword_be(i) == 0x00))
        ||
        any_of(ChallengesCompleted, i => dword_be(i) == vals[1] && prev(dword_be(i) == 0x00))
        ||
        any_of(ChallengesCompleted, i => dword_be(i) == vals[2] && prev(dword_be(i) == 0x00))
        ||
        any_of(ChallengesCompleted, i => dword_be(i) == vals[3] && prev(dword_be(i) == 0x00))
        ||
        any_of(ChallengesCompleted, i => dword_be(i) == vals[4] && prev(dword_be(i) == 0x00))
        ||
        any_of(ChallengesCompleted, i => dword_be(i) == vals[5] && prev(dword_be(i) == 0x00))
      )
      &&
      any_of(ChallengesCompleted, i => dword_be(i) == vals[0])
      &&
      any_of(ChallengesCompleted, i => dword_be(i) == vals[1])
      &&
      any_of(ChallengesCompleted, i => dword_be(i) == vals[2])
      &&
      any_of(ChallengesCompleted, i => dword_be(i) == vals[3])
      &&
      any_of(ChallengesCompleted, i => dword_be(i) == vals[4])
      &&
      any_of(ChallengesCompleted, i => dword_be(i) == vals[5])
    )
  )
}

ChallengesCompleted("Star Racer", "Star Collectible Races", [0x3b58a960, 0x0fe87dc6, 0x52ee7193, 0xb92436b5, 0x45e59793, 0xa589d9d7])
ChallengesCompleted("No Items Needed!", "Pure Races", [0xf7367613, 0xb58f468b, 0x0fe87dc4, 0x7ec5f075, 0xb92436b3, 0x3b58a95e])
ChallengesCompleted("The New Start of the Show", "Superstar Races", [0xb92436b4, 0x52ee7192, 0xbe46693c, 0xb58f468c, 0x45e59792, 0x0fe87dc5])
ChallengesCompleted("Rocket Man", "Turbo Races", [0x66b5c92e, 0xbe21d7a5, 0x7ec5f079, 0x45e59795, 0xb58f468f, 0xbe46693f])
ChallengesCompleted("Excellent Aim", "Precision Races", [0xbe21d7a0, 0xf7367612, 0x3b58a95d, 0xa589d9d4, 0x7ec5f074, 0x66b5c929])
ChallengesCompleted("Planned to Win", "Strategic Races", [0xa589d9d8, 0xbe46693e, 0x66b5c92d, 0xbe21d7a4, 0x3b58a961, 0x52ee7194])

// -------------------- Time Trials --------------------
function Leaderboard(trackName, trackAscii){
  leaderboard(
    title = trackName,
    description = "Complete the race in Time Trial mode in the quickest possible time",
    start = (
      IsInGame() &&
      CurrentLap() == 1 &&
      CurrentMode() == 0x03 &&
      RaceTimer() == 0 &&
      ascii_string_equals(CurrentLevel(), trackAscii)
    ),
    cancel = (
      !IsInGame()
    ),
    submit = (
      CurrentLap() == 4
    ),
    value = (
      RaceTimer()
    ),
    format = "SECS",
    lower_is_better = true
  )
}

for i in LevelAscii{
  Leaderboard(LevelAscii[i], i)
}

Leaderboard("Shrek's Swamp (Night)", "Shrek_Swamp_Night.wad")
Leaderboard("Isle Of Berk (Night)", "IsleOfBerk_Night.wad")
Leaderboard("Africa (Night)", "Africa_Night.wad")

function TimeTrialSpeedrun(achTitle, mapName, descTime, trackAscii){
  achievement(
    title = achTitle,
    description = "Complete " + mapName + " on Time Trial mode in under " + descTime,
    points = 10,
    trigger = (
      CurrentMode() == 0x03 &&
      RaceTimer() == 0 &&
      ascii_string_equals(CurrentLevel(), trackAscii)
    )
  )
}

// -------------------- RP --------------------
CharacterAscii = {
  "Shrek": "Shrek",
  "Alex": "Alex",
  "BOB": "BOB",
  "Hiccup": "Hiccup",
  "Skipper": "Skipper",
  "Donkey": "Donkey",
  "Toothless": "Toothless",
  "Fiona": "Fiona",
  "Marty": "Marty",
  "TribalAlex": "Tribal Alex",
  "CaptainSkipper": "Captain Skipper",
  "WarriorShrek": "Warrior Shrek"
}

Modes = {
  0x01: "Circuit",
  0x02: "Quick Race",
  0x03: "Time Trial",
  0x07: "Challenge"
}

Placement = {
  0x01: "1st",
  0x02: "2nd",
  0x03: "3rd",
  0x04: "4th",
  0x05: "5th",
  0x06: "6th",
  0x07: "7th",
  0x08: "8th",
  0x09: "9th"
}

function CharacterAddress() => 0x00584268
function CurrentPosition() => dword_be(RaceDataPointer + 0x24)

rich_presence_conditional_display(!IsInGame(), "Browsing the menus")
rich_presence_conditional_display(ascii_string_equals(CharacterAddress(), "Shrek_Swamp_Night.wad"), "{0} is racing in Shrek's Swamp (Night) on {1} mode [{2} place] [lap: {3}]",
  rich_presence_ascii_string_lookup("Character", CharacterAddress(), CharacterAscii),
  rich_presence_lookup("Mode", CurrentMode(), Modes),
  rich_presence_lookup("Placement", CurrentPosition(), Placement),
  rich_presence_value("Lap", CurrentLap())
)
rich_presence_conditional_display(ascii_string_equals(CharacterAddress(), "IsleOfBerk_Night.wad"), "{0} is racing in Isle Of Berk (Night) on {1} mode [{2} place] [lap: {3}]",
  rich_presence_ascii_string_lookup("Character", CharacterAddress(), CharacterAscii),
  rich_presence_lookup("Mode", CurrentMode(), Modes),
  rich_presence_lookup("Placement", CurrentPosition(), Placement),
  rich_presence_value("Lap", CurrentLap())
)
rich_presence_conditional_display(ascii_string_equals(CharacterAddress(), "Africa_Night.wad"), "{0} is racing in Africa (Night) on {1} mode [{2} place] [lap: {3}]",
  rich_presence_ascii_string_lookup("Character", CharacterAddress(), CharacterAscii),
  rich_presence_lookup("Mode", CurrentMode(), Modes),
  rich_presence_lookup("Placement", CurrentPosition(), Placement),
  rich_presence_value("Lap", CurrentLap())
)
rich_presence_display("{0} is racing in {1} on {2} mode [{3} place] [lap: {4}]",
  rich_presence_ascii_string_lookup("Character", CharacterAddress(), CharacterAscii),
  rich_presence_ascii_string_lookup("Map", CurrentLevel(), LevelAscii),
  rich_presence_lookup("Mode", CurrentMode(), Modes),
  rich_presence_lookup("Placement", CurrentPosition(), Placement),
  rich_presence_value("Lap", CurrentLap())
)