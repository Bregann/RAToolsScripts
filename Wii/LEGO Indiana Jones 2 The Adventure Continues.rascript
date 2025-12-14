// LEGO Indiana Jones 2: The Adventure Continues
// #ID = 11087

function CurrentLevel() => dword_be(0x10db4814)
function LoadProtection() => CurrentLevel() != 0xfffffff && CurrentLevel() != 0x00000000 && CurrentLevel() != 0x00000033

// ---------------------------------------- LEVEL PROGRESS ----------------------------------------

PlayableLevels = {
    0x37: ["Raven Rescue", "Raiders of the Lost Ark", "Story", 0x10dc2933, 0x10dc2934],
    0x39: ["Market Mayhem", "Raiders of the Lost Ark", "Story", 0x10dc2bcb, 0x10dc2bcc],
    0x3b: ["Map Room Mystery", "Raiders of the Lost Ark", "Story", 0x10dc2e63, 0x10dc2e64],
    0x3e: ["After the Ark", "Raiders of the Lost Ark", "Story", 0x10dc3247, 0x10dc3248],
    0x40: ["Belloq Battle", "Raiders of the Lost Ark", "Story", 0x10dc34df, 0x10dc34e0],
    0x38: ["Toasty Tavern", "Raiders of the Lost Ark", "TreasureMode", 0x10dc2a7f, 0x10dc2a80],
    0x3a: ["Cairo Conundrum", "Raiders of the Lost Ark", "TreasureMode", 0x10dc2d17, 0x10dc2d18],
    0x3d: ["Cryptic Crypt", "Raiders of the Lost Ark", "TreasureMode", 0x10dc30fb, 0x10dc30fc],
    0x3f: ["Desert Dash", "Raiders of the Lost Ark", "TreasureMode", 0x10dc3393, 0x10dc3394],
    0x41: ["Buildozer", "Raiders of the Lost Ark", "TreasureMode", 0x10dc362b, 0x10dc362c],
    0x86: ["Mountain Shack", "Raiders of the Lost Ark", "BonusLevel", 0x10dc8fa7, 0x10dc8fa8],
    0x87: ["Airstrip Hangar", "Raiders of the Lost Ark", "BonusLevel", 0x10dc90f3, 0x10dc90f4],
    0x88: ["Hovitos Temple", "Raiders of the Lost Ark", "BonusLevel", 0x10dc923f, 0x10dc9240],
    0x89: ["Bantu Wind", "Raiders of the Lost Ark", "BonusLevel", 0x10dc938b, 0x10dc938c],
    0x8a: ["Submarine Base", "Raiders of the Lost Ark", "BonusLevel", 0x10dc94d7, 0x10dc94d8],
    0x44: ["Lao Chase", "Temple of Doom", "Story", 0x10dc3a0f, 0x10dc3a10],
    0x47: ["Monkey Mischief", "Temple of Doom", "Story", 0x10dc3df3, 0x10dc3df4],
    0x49: ["Malice at the Palace", "Temple of Doom", "Story", 0x10dc408b, 0x10dc408c],
    0x4b: ["Temple Tantrum", "Temple of Doom", "Story", 0x10dc4323, 0x10dc4324],
    0x4d: ["Mola Rampage", "Temple of Doom", "Story", 0x10dc45bb, 0x10dc45bc],
    0x45: ["Shang-High", "Temple of Doom", "TreasureMode", 0x10dc3b5b, 0x10dc3b5c],
    0x48: ["Wrong Gong Rung", "Temple of Doom", "TreasureMode", 0x10dc3f3f, 0x10dc3f40],
    0x4a: ["Disarming Duel", "Temple of Doom", "TreasureMode", 0x10dc41d7, 0x10dc41d8],
    0x4c: ["Lava Lake", "Temple of Doom", "TreasureMode", 0x10dc446f, 0x10dc4470],
    0x4e: ["Cliff Clamber", "Temple of Doom", "TreasureMode", 0x10dc4707, 0x10dc4708],
    0x8d: ["Club ObiWan", "Temple of Doom", "BonusLevel", 0x10dc98bb, 0x10dc98bc],
    0x8e: ["Beachside Cave", "Temple of Doom", "BonusLevel", 0x10dc9a07, 0x10dc9a08],
    0x8f: ["Slave Driver Cave", "Temple of Doom", "BonusLevel", 0x10dc9b53, 0x10dc9b54],
    0x90: ["Mountain Cave", "Temple of Doom", "BonusLevel", 0x10dc9c9f, 0x10dc9ca0],
    0x91: ["Princess Rescue", "Temple of Doom", "BonusLevel", 0x10dc9deb, 0x10dc9dec],
    0x51: ["The Coronado Caper", "The Last Crusade", "Story", 0x10dc4aeb, 0x10dc4aec],
    0x53: ["Brunwald Blaze", "The Last Crusade", "Story", 0x10dc4d83, 0x10dc4d84],
    0x55: ["Berlin Brawl", "The Last Crusade", "Story", 0x10dc501b, 0x10dc501c],
    0x57: ["Cannon Canyon", "The Last Crusade", "Story", 0x10dc52b3, 0x10dc52b4],
    0x59: ["Trial & Terror", "The Last Crusade", "Story", 0x10dc554b, 0x10dc554c],
    0x52: ["Crab Cake Confusion", "The Last Crusade", "TreasureMode", 0x10dc4c37, 0x10dc4c38],
    0x54: ["Castle Quench", "The Last Crusade", "TreasureMode", 0x10dc4ecf, 0x10dc4ed0],
    0x56: ["Perilous Parking", "The Last Crusade", "TreasureMode", 0x10dc5167, 0x10dc5168],
    0x58: ["Canyon Quest", "The Last Crusade", "TreasureMode", 0x10dc53ff, 0x10dc5400],
    0x5a: ["Chalice Challenge", "The Last Crusade", "TreasureMode", 0x10dc5697, 0x10dc5698],
    0x93: ["Venice Library", "The Last Crusade", "BonusLevel", 0x10dca083, 0x10dca084],
    0x94: ["Beach Pit", "The Last Crusade", "BonusLevel", 0x10dca1cf, 0x10dca1d0],
    0x95: ["Berlin Airport", "The Last Crusade", "BonusLevel", 0x10dca31b, 0x10dca31c],
    0x96: ["Castle Cave", "The Last Crusade", "BonusLevel", 0x10dca467, 0x10dca468],
    0x97: ["Venice Tunnel", "The Last Crusade", "BonusLevel", 0x10dca5b3, 0x10dca5b4],
    0x5e: ["Hangar Havoc", "Crystal Skull Part 1", "Story", 0x10dc5bc7, 0x10dc5bc8],
    0x61: ["Doom Town", "Crystal Skull Part 1", "Story", 0x10dc5fab, 0x10dc5fac],
    0x64: ["Café Chaos", "Crystal Skull Part 1", "Story", 0x10dc638f, 0x10dc6390],
    0x66: ["Motorbike Mayhem", "Crystal Skull Part 1", "Story", 0x10dc6627, 0x10dc6628],
    0x69: ["Crane Train", "Crystal Skull Part 1", "Story", 0x10dc6a0b, 0x10dc6a0c],
    0x5f: ["Forklift Fun", "Crystal Skull Part 1", "TreasureMode", 0x10dc5d13, 0x10dc5d14],
    0x63: ["Dummy Run", "Crystal Skull Part 1", "TreasureMode", 0x10dc6243, 0x10dc6244],
    0x65: ["Diner Distraction", "Crystal Skull Part 1", "TreasureMode", 0x10dc64db, 0x10dc64dc],
    0x67: ["Bike Hike", "Crystal Skull Part 1", "TreasureMode", 0x10dc6773, 0x10dc6774],
    0x6b: ["Target Training", "Crystal Skull Part 1", "TreasureMode", 0x10dc6ca3, 0x10dc6ca4],
    0x99: ["Marshall College", "Crystal Skull Part 1", "BonusLevel", 0x10dca84b, 0x10dca84c],
    0x9a: ["Petrol Station", "Crystal Skull Part 1", "BonusLevel", 0x10dca997, 0x10dca998],
    0x9b: ["Doom Town House 2", "Crystal Skull Part 1", "BonusLevel", 0x10dcaae3, 0x10dcaae4],
    0x9c: ["Interrogation Room", "Crystal Skull Part 1", "BonusLevel", 0x10dcac2f, 0x10dcac30],
    0x9d: ["Hangar 52", "Crystal Skull Part 1", "BonusLevel", 0x10dcad7b, 0x10dcad7c],
    0x6e: ["Peru Cell Perusal", "Crystal Skull Part 2", "Story", 0x10dc7087, 0x10dc7088],
    0x70: ["Tomb Doom", "Crystal Skull Part 2", "Story", 0x10dc731f, 0x10dc7320],
    0x72: ["Mac Attack", "Crystal Skull Part 2", "Story", 0x10dc75b7, 0x10dc75b8],
    0x77: ["Rainforest Rumble", "Crystal Skull Part 2", "Story", 0x10dc7c33, 0x10dc7c34],
    0x74: ["Dovchenko Duel", "Crystal Skull Part 2", "Story", 0x10dc784f, 0x10dc7850],
    0x6f: ["Musical Mania", "Crystal Skull Part 2", "TreasureMode", 0x10dc71d3, 0x10dc71d4],
    0x71: ["Tomb Time", "Crystal Skull Part 2", "TreasureMode", 0x10dc746b, 0x10dc746c],
    0x73: ["Mirror Mayhem", "Crystal Skull Part 2", "TreasureMode", 0x10dc7703, 0x10dc7704],
    0x78: ["Forest Forage", "Crystal Skull Part 2", "TreasureMode", 0x10dc7d7f, 0x10dc7d80],
    0x75: ["Jungle Jump", "Crystal Skull Part 2", "TreasureMode", 0x10dc799b, 0x10dc799c],
    0x9f: ["Peru Airport", "Crystal Skull Part 2", "BonusLevel", 0x10dcb013, 0x10dcb014],
    0xa0: ["Peruvian Market", "Crystal Skull Part 2", "BonusLevel", 0x10dcb15f, 0x10dcb160],
    0xa1: ["Graveyard Tomb", "Crystal Skull Part 2", "BonusLevel", 0x10dcb2ab, 0x10dcb2ac],
    0xa2: ["Temple Tussle", "Crystal Skull Part 2", "BonusLevel", 0x10dcb3f7, 0x10dcb3f8],
    0xa3: ["Gorge in the Jungle", "Crystal Skull Part 2", "BonusLevel", 0x10dcb543, 0x10dcb544],
    0x7a: ["Repair Scare", "Crystal Skull Part 3", "Story", 0x10dc8017, 0x10dc8018],
    0x7c: ["River Ruckus", "Crystal Skull Part 3", "Story", 0x10dc82af, 0x10dc82b0],
    0x7e: ["Temple Tangle", "Crystal Skull Part 3", "Story", 0x10dc8547, 0x10dc8548],
    0x80: ["Ugha Struggle", "Crystal Skull Part 3", "Story", 0x10dc87df, 0x10dc87e0],
    0x82: ["Akator Ambush", "Crystal Skull Part 3", "Story", 0x10dc8a77, 0x10dc8a78],
    0x7b: ["Campfire Countdown", "Crystal Skull Part 3", "TreasureMode", 0x10dc8163, 0x10dc8164],
    0x7d: ["Riverside Rush", "Crystal Skull Part 3", "TreasureMode", 0x10dc83fb, 0x10dc83fc],
    0x7f: ["Trick or Treasure", "Crystal Skull Part 3", "TreasureMode", 0x10dc8693, 0x10dc8694],
    0x81: ["Tie Up High Up", "Crystal Skull Part 3", "TreasureMode", 0x10dc892b, 0x10dc892c],
    0x84: ["Pit of Peril", "Crystal Skull Part 3", "TreasureMode", 0x10dc8d0f, 0x10dc8d10],
    0xa5: ["Jungle Japes", "Crystal Skull Part 3", "BonusLevel", 0x10dcb7db, 0x10dcb7dc],
    0xa6: ["Lake Crypt", "Crystal Skull Part 3", "BonusLevel", 0x10dcb927, 0x10dcb928],
    0xa7: ["Digger's Delight", "Crystal Skull Part 3", "BonusLevel", 0x10dcba73, 0x10dcba74],
    0xa8: ["Treasure Room", "Crystal Skull Part 3", "BonusLevel", 0x10dcbbbf, 0x10dcbbc0],
    0xa9: ["Cave Capers", "Crystal Skull Part 3", "BonusLevel", 0x10dcbd0b, 0x10dcbd0c],
    0xab: ["Raiders of the Lost Ark Super Bonus", "Super Bonus Levels", "SuperBonus", 0x10dcbfa3, 0x10dcbfa4],
    0xac: ["Temple of Doom Super Bonus", "Super Bonus Levels", "SuperBonus", 0x10dcc0ef, 0x10dcc0f0],
    0xad: ["The Last Crusade Super Bonus", "Super Bonus Levels", "SuperBonus", 0x10dcc23b, 0x10dcc23c],
    0xae: ["Kingdom of the Crystal Skull - Part 1 Super Bonus", "Super Bonus Levels", "SuperBonus", 0x10dcc387, 0x10dcc388],
    0xaf: ["Kingdom of the Crystal Skull - Part 2 Super Bonus", "Super Bonus Levels", "SuperBonus", 0x10dcc4d3, 0x10dcc4d4],
    0xb0: ["Kingdom of the Crystal Skull - Part 3 Super Bonus", "Super Bonus Levels", "SuperBonus", 0x10dcc61f, 0x10dcc620]
}

function CompleteLevel(levelName, levelType, levelAddr){
  if(levelType == "Story"){
    achievement(
      title = levelName,
      description = "Complete " + "\"" + levelName + "\"" + " in Story Mode",
      points = 3,
      type = "Progression",
      trigger = (
        LoadProtection() &&
        bit7(levelAddr) == 1 &&
        prev(bit7(levelAddr)) == 0
      )
    )
  }

  if(levelType == "TreasureMode"){
    achievement(
      title = levelName,
      description = "Complete " + "\"" + levelName + "\"" + " in Treasure Mode",
      points = 3,
      trigger = (
        LoadProtection() &&
        bit7(levelAddr) == 1 &&
        prev(bit7(levelAddr)) == 0
      )
    )
  }

  if(levelType == "BonusLevel"){
    achievement(
      title = levelName,
      description = "Complete the Bonus Level " + "\"" + levelName + "\"",
      points = 3,
      trigger = (
        LoadProtection() &&
        bit7(levelAddr) == 1 &&
        prev(bit7(levelAddr)) == 0
      )
    )
  }

  if(levelType == "SuperBonus"){
    achievement(
      title = levelName,
      description = "Complete the Super Bonus Level " + "\"" + levelName + "\"",
      points = 5,
      trigger = (
        LoadProtection() &&
        bit7(levelAddr) == 1 &&
        prev(bit7(levelAddr)) == 0
      )
    )
  }
}

function LevelLeaderboard(levelName, timerAddr){
  leaderboard(
    title = levelName,
    description = "Complete " + "\"" + levelName + "\"" + " in the fastest time",
    start = (
      LoadProtection() &&
      (
        (float_be(timerAddr) != 0.0 &&
        prev(float_be(timerAddr)) == 0.0)
        ||
        (float_be(timerAddr) < prev(float_be(timerAddr)))
      )
    ),
    cancel = (
      always_false()
    ),
    submit = (
        (float_be(timerAddr) != 0.0 &&
        prev(float_be(timerAddr)) == 0.0)
        ||
        (float_be(timerAddr) < prev(float_be(timerAddr)))
    ),
    value = (
      float_be(timerAddr)
    ),
    format = "SECS",
    lower_is_better = true
  )
}

for i in PlayableLevels{
  LevelLeaderboard(PlayableLevels[i][0], PlayableLevels[i][4])
}

for i in PlayableLevels{
  CompleteLevel(PlayableLevels[i][0], PlayableLevels[i][2], PlayableLevels[i][3])
}

RaidersTrueAdventurer = 
byte(0x10dc2931) + byte(0x10dc2bc9) + byte(0x10dc2e61) + byte(0x10dc3245) + byte(0x10dc34dd) + 
byte(0x10dc2a7d) + byte(0x10dc2d15) + byte(0x10dc30f9) + byte(0x10dc3391) + byte(0x10dc3629) + 
byte(0x10dc8fa5) + byte(0x10dc90f1) + byte(0x10dc923d) + byte(0x10dc9389) + byte(0x10dc94d5)

TempleOfDoomTrueAdventurer = 
byte(0x10dc3a0d) + byte(0x10dc3df1) + byte(0x10dc4089) + byte(0x10dc4321) + byte(0x10dc45b9) + 
byte(0x10dc3b59) + byte(0x10dc3f3d) + byte(0x10dc41d5) + byte(0x10dc446d) + byte(0x10dc4705) + 
byte(0x10dc98b9) + byte(0x10dc9a05) + byte(0x10dc9b51) + byte(0x10dc9c9d) + byte(0x10dc9de9)

LastCrusadeTrueAdventurer = 
byte(0x10dc4ae9) + byte(0x10dc4d81) + byte(0x10dc5019) + byte(0x10dc52b1) + byte(0x10dc5549) + 
byte(0x10dc4c35) + byte(0x10dc4ecd) + byte(0x10dc5165) + byte(0x10dc53fd) + byte(0x10dc5695) + 
byte(0x10dca081) + byte(0x10dca1cd) + byte(0x10dca319) + byte(0x10dca465) + byte(0x10dca5b1)

CrystalSkullP1TrueAdventurer = 
byte(0x10dc5bc5) + byte(0x10dc5fa9) + byte(0x10dc638d) + byte(0x10dc6625) + byte(0x10dc6a09) + 
byte(0x10dc5d11) + byte(0x10dc6241) + byte(0x10dc64d9) + byte(0x10dc6771) + byte(0x10dc6ca1) + 
byte(0x10dca849) + byte(0x10dca995) + byte(0x10dcaae1) + byte(0x10dcac2d) + byte(0x10dcad79)

CrystalSkullP2TrueAdventurer = 
byte(0x10dc7085) + byte(0x10dc731d) + byte(0x10dc75b5) + byte(0x10dc784d) + byte(0x10dc7c31) + 
byte(0x10dc71d1) + byte(0x10dc7469) + byte(0x10dc7701) + byte(0x10dc7999) + byte(0x10dc7d7d) + 
byte(0x10dcb011) + byte(0x10dcb15d) + byte(0x10dcb2a9) + byte(0x10dcb3f5) + byte(0x10dcb541)

CrystalSkullP3TrueAdventurer = 
byte(0x10dc8015) + byte(0x10dc82ad) + byte(0x10dc8545) + byte(0x10dc87dd) + byte(0x10dc8a75) + 
byte(0x10dc8161) + byte(0x10dc83f9) + byte(0x10dc8691) + byte(0x10dc8929) + byte(0x10dc8d0d) + 
byte(0x10dcb7d9) + byte(0x10dcb925) + byte(0x10dcba71) + byte(0x10dcbbbd) + byte(0x10dcbd09)

function TrueAdventurer(achTitle, episodeName, addresses){
  achievement(
    title = achTitle,
    description = "Reach True Adventurer status on every level in " + "\"" + episodeName + "\"",
    points = 10,
    trigger = (
      LoadProtection() &&
      addresses == 15 &&
      prev(addresses) == 14
  )
  )
}

TrueAdventurer("Digging in the Right Place", "Raiders of the Lost Ark", RaidersTrueAdventurer)
TrueAdventurer("Diamonds, Lao Che!", "Temple of Doom", TempleOfDoomTrueAdventurer)
TrueAdventurer("You Collected... Wisely", "The Last Crusade", LastCrusadeTrueAdventurer)
TrueAdventurer("Not as Easy as It Used to Be", "Kingdom of the Crystal Skull - Part 1", CrystalSkullP1TrueAdventurer)
TrueAdventurer("We Call It Archaeology", "Kingdom of the Crystal Skull - Part 2", CrystalSkullP2TrueAdventurer)
TrueAdventurer("Knowledge Was Their Treasure", "Kingdom of the Crystal Skull - Part 3", CrystalSkullP3TrueAdventurer)

RaidersBricks =
dword_be(0x10dde764) + dword_be(0x10dde768) + dword_be(0x10dde76c)

TempleOfDoomBricks =
dword_be(0x10dde780) + dword_be(0x10dde784) + dword_be(0x10dde788)

LastCrusadeBricks =
dword_be(0x10dde79c) + dword_be(0x10dde7a0) + dword_be(0x10dde7a4)

CrystalSkullP1Bricks =
dword_be(0x10dde7b8) + dword_be(0x10dde7bc) + dword_be(0x10dde7c0)

CrystalSkullP2Bricks =
dword_be(0x10dde7d4) + dword_be(0x10dde7d8) + dword_be(0x10dde7dc)

CrystalSkullP3Bricks =
dword_be(0x10dde7f0) + dword_be(0x10dde7f4) + dword_be(0x10dde7f8)

// ---------------------------------------- UNLOCKS ----------------------------------------

function BricksCollected(achTitle, episodeName, addresses){
  achievement(
    title = achTitle,
    description = "Collect all red, green and blue bricks in " + "\"" + episodeName + "\"",
    points = 10,
    trigger = (
      LoadProtection() &&
      addresses == 30 &&
      prev(addresses) == 29
  )
  )
}

BricksCollected("Raider of the Coloured Bricks", "Raiders of the Lost Ark", RaidersBricks)
BricksCollected("Temple of Bricks", "Temple of Doom", TempleOfDoomBricks)
BricksCollected("Crusade for Bricks", "The Last Crusade", LastCrusadeBricks)
BricksCollected("Property of Hangar 51", "Kingdom of the Crystal Skull - Part 1", CrystalSkullP1Bricks)
BricksCollected("Kingdom of the Crystal Bricks", "Kingdom of the Crystal Skull - Part 2", CrystalSkullP2Bricks)
BricksCollected("A Gift from Another World", "Kingdom of the Crystal Skull - Part 3", CrystalSkullP3Bricks)

RaidersCharactersVehicles = 
bit0(0x10de3a6f) + bit0(0x10de3a71) + bit0(0x10de3a72) + bit0(0x10de3a7f) + bit0(0x10de3a80) + 
bit0(0x10de3a8d) + bit0(0x10de3a9c) + bit0(0x10de3aa5) + bit0(0x10de3aac) + bit0(0x10de3aad) + 
bit0(0x10de3aaf) + bit0(0x10de3ab1) + bit0(0x10de3aba) + bit0(0x10de3ace) + bit0(0x10de3ad2) + 
bit0(0x10de3ad5) + bit0(0x10de3ad6) + bit0(0x10de3aea) + bit0(0x10de3b64) + bit0(0x10de3b8a) + 
bit0(0x10de3ba9) + bit0(0x10de3bac) + bit0(0x10de3bbe) + bit0(0x10de3bc3) + bit0(0x10de3bc4)

TempleOfDoomCharactersVehicles = 
bit1(0x10de3a73) + bit1(0x10de3a77) + bit1(0x10de3a7a) + bit1(0x10de3a7d) + bit1(0x10de3a8c) + 
bit1(0x10de3a8e) + bit1(0x10de3ac1) + bit1(0x10de3ad0) + bit1(0x10de3ade) + bit1(0x10de3aec) + 
bit1(0x10de3b04) + bit1(0x10de3b10) + bit1(0x10de3b12) + bit1(0x10de3b3c) + bit1(0x10de3b6b) + 
bit1(0x10de3b86) + bit1(0x10de3b88) + bit1(0x10de3b89) + bit1(0x10de3bc8) + bit1(0x10de3bcd) + 
bit1(0x10de3bd1) + bit1(0x10de3bea)

LastCrusadeCharactersVehicles = 
bit2(0x10de3a6f) + bit2(0x10de3a90) + bit2(0x10de3a96) + bit2(0x10de3a98) + bit2(0x10de3a9b) + 
bit2(0x10de3a9e) + bit2(0x10de3aa0) + bit2(0x10de3aa9) + bit2(0x10de3ab6) + bit2(0x10de3ad5) + 
bit2(0x10de3ad9) + bit2(0x10de3adc) + bit2(0x10de3b0d) + bit2(0x10de3b18) + bit2(0x10de3b26) + 
bit2(0x10de3b39) + bit2(0x10de3b58) + bit2(0x10de3b64) + bit2(0x10de3b80) + bit2(0x10de3b81) + 
bit2(0x10de3b82) + bit2(0x10de3b83) + bit2(0x10de3bc3) + bit2(0x10de3be7) + bit2(0x10de3bef)

CrystalSkullP1CharactersVehicles = 
bit3(0x10de3b19) + bit3(0x10de3b24) + bit3(0x10de3b27) + bit3(0x10de3b2c) + bit3(0x10de3b2e) + 
bit3(0x10de3b30) + bit3(0x10de3b34) + bit3(0x10de3b36) + bit3(0x10de3b41) + bit3(0x10de3b47) + 
bit3(0x10de3b49) + bit3(0x10de3b4a) + bit3(0x10de3b4c) + bit3(0x10de3b4d) + bit3(0x10de3b4f) + 
bit3(0x10de3b54) + bit3(0x10de3b60) + bit3(0x10de3b63) + bit3(0x10de3b64) + bit3(0x10de3ba8) + 
bit3(0x10de3bab) + bit3(0x10de3bb7) + bit3(0x10de3bbc) + bit3(0x10de3bbd) + bit3(0x10de3bc0) + 
bit3(0x10de3bc5)

CrystalSkullP2CharactersVehicles = 
bit4(0x10de3ad5) + bit4(0x10de3b20) + bit4(0x10de3b2a) + bit4(0x10de3b2d) + bit4(0x10de3b33) + 
bit4(0x10de3b3a) + bit4(0x10de3b3b) + bit4(0x10de3b40) + bit4(0x10de3b47) + bit4(0x10de3b54) + 
bit4(0x10de3b59) + bit4(0x10de3b5a) + bit4(0x10de3b5e) + bit4(0x10de3b5f) + bit4(0x10de3b60) + 
bit4(0x10de3b64) + bit4(0x10de3b6a) + bit4(0x10de3bbc) + bit4(0x10de3bbf) + bit4(0x10de3bc6) + 
bit4(0x10de3bc7) + bit4(0x10de3be6)

CrystalSkullP3CharactersVehicles = 
bit5(0x10de3b16) + bit5(0x10de3b2a) + bit5(0x10de3b2b) + bit5(0x10de3b33) + bit5(0x10de3b42) + 
bit5(0x10de3b43) + bit5(0x10de3b44) + bit5(0x10de3b45) + bit5(0x10de3b47) + bit5(0x10de3b54) + 
bit5(0x10de3b5c) + bit5(0x10de3b5e) + bit5(0x10de3b5f) + bit5(0x10de3b60) + bit5(0x10de3b66) + 
bit5(0x10de3b71) + bit5(0x10de3b72) + bit5(0x10de3ba8) + bit5(0x10de3bb1) + bit5(0x10de3bb2) + 
bit5(0x10de3beb)

function CharactersUnlocked(achTitle, episodeName, addresses, amount){
  achievement(
    title = achTitle,
    description = "Unlock every character and vehicle in " + "\"" + episodeName + "\"",
    points = 10,
    trigger = (
      LoadProtection() &&
      addresses == amount &&
      prev(addresses) == amount - 1
  )
  )
}

CharactersUnlocked("The Cairo Connection", "Raiders of the Lost Ark", RaidersCharactersVehicles, 25)
CharactersUnlocked("Pankot Palace Guest List", "Temple of Doom", TempleOfDoomCharactersVehicles, 22)
CharactersUnlocked("The Jones Family Reunion", "The Last Crusade", LastCrusadeCharactersVehicles, 25)
CharactersUnlocked("Doom Town Residents", "Kingdom of the Crystal Skull - Part 1", CrystalSkullP1CharactersVehicles, 26)
CharactersUnlocked("Jungle Cutter Crew", "Kingdom of the Crystal Skull - Part 2", CrystalSkullP2CharactersVehicles, 22)
CharactersUnlocked("Interdimensional Travelers", "Kingdom of the Crystal Skull - Part 3", CrystalSkullP3CharactersVehicles, 21)

ExtrasPurchased = 
bit0(0x10ddf02d) + bit1(0x10ddf02d) + bit2(0x10ddf02d) +
bitcount(0x10ddf02e) + 
bit1(0x10ddf02f) + bit2(0x10ddf02f) + bit3(0x10ddf02f) + 
bit4(0x10ddf02f) + bit5(0x10ddf02f) + bit6(0x10ddf02f) + 
bit7(0x10ddf02f)

achievement(
  title = "It Belongs in a Museum!",
  description = "Purchase every extra in the game",
  points = 25,
  trigger = (
    LoadProtection() &&
    ExtrasPurchased == 18 &&
    prev(ExtrasPurchased) == 17
  )
)

// ---------------------------------------- CREATOR ----------------------------------------
CreatorLevels = 
bit7(0x10dcca03) + bit7(0x10dccb4f) + 
bit7(0x10dccc9b) + bit7(0x10dccde7)

achievement(
  title = "Time to Get Creative",
  description = "Complete all 4 tutorial levels in the \"Creator\" mode",
  points = 3,
  trigger = (
    LoadProtection() &&
    CreatorLevels == 4 &&
  prev(CreatorLevels) == 3
  )
)

CreatorPurchases = bit1(0x10dfb664) + bit2(0x10dfb664) + bit4(0x10dfb664) + bit5(0x10dfb664) + 
bit0(0x10dfb665) + bit2(0x10dfb665) + bit4(0x10dfb665) + bit5(0x10dfb665) + bit6(0x10dfb665) + 
bit7(0x10dfb665) + bit0(0x10dfb666) + bit2(0x10dfb666) + bit3(0x10dfb666) + bit4(0x10dfb666) + 
bit5(0x10dfb666) + bit6(0x10dfb666) + bit7(0x10dfb666) + bitcount(0x10dfb667) + bitcount(0x10dfb668) +
bit0(0x10dfb669) + bit1(0x10dfb669) + bit4(0x10dfb669) + bit5(0x10dfb669) + bit6(0x10dfb669) + 
bit7(0x10dfb669) + bit0(0x10dfb66a) + bit2(0x10dfb66a) + bit3(0x10dfb66a) + bit4(0x10dfb66a) + 
bit6(0x10dfb66a) + bit7(0x10dfb66a) + bit6(0x10dfb66c) + bit7(0x10dfb66c) + bit0(0x10dfb66d) + 
bit1(0x10dfb66d) + bit2(0x10dfb66d) + bit3(0x10dfb66d) + bit5(0x10dfb66d) + bit6(0x10dfb66d) + 
bit7(0x10dfb66d) + bitcount(0x10dfb66e) + bit2(0x10dfb66f) + bit3(0x10dfb66f) + bit4(0x10dfb66f) + 
bit5(0x10dfb66f) + bit6(0x10dfb66f) + bit7(0x10dfb66f) + bit4(0x10dfb670) + bit5(0x10dfb670) + 
bit6(0x10dfb670) + bit7(0x10dfb670) + bit0(0x10dfb671) + bit1(0x10dfb671) + bit2(0x10dfb671) + 
bit3(0x10dfb671) + bit4(0x10dfb671) + bit6(0x10dfb671) + bit7(0x10dfb671) + bit0(0x10dfb672) + 
bit2(0x10dfb672) + bit3(0x10dfb672) + bit4(0x10dfb672) + bit5(0x10dfb672) + bit6(0x10dfb672) + 
bit7(0x10dfb672) + bitcount(0x10dfb673) + bitcount(0x10dfb674) + bitcount(0x10dfb675) + 
bitcount(0x10dfb676) + bitcount(0x10dfb677) + bitcount(0x10dfb678) + bitcount(0x10dfb679) + 
bitcount(0x10dfb67a) + bitcount(0x10dfb67b) + bitcount(0x10dfb67c) + bit0(0x10dfb67d) + 
bit1(0x10dfb67d) + bit4(0x10dfb67d) + bit5(0x10dfb67d) + bit6(0x10dfb67d) + bit7(0x10dfb67d) + 
bitcount(0x10dfb67e) + bitcount(0x10dfb67f) + bitcount(0x10dfb680) + bitcount(0x10dfb681) + 
bit0(0x10dfb682) + bit1(0x10dfb682) + bit2(0x10dfb682) + bit3(0x10dfb682) + bit4(0x10dfb682) + 
bit6(0x10dfb682) + bit7(0x10dfb682) + bitcount(0x10dfb683) + bitcount(0x10dfb684) + bit0(0x10dfb685) + 
bit1(0x10dfb685) + bit2(0x10dfb685) + bit3(0x10dfb685) + bit5(0x10dfb685) + bit6(0x10dfb685) + 
bit7(0x10dfb685) + bitcount(0x10dfb686) + bit0(0x10dfb687) + bit1(0x10dfb687) + bit3(0x10dfb687) + 
bit4(0x10dfb687) + bit5(0x10dfb687) + bit6(0x10dfb687) + bit7(0x10dfb687) + bit0(0x10dfb688) + 
bit2(0x10dfb688) + bit3(0x10dfb688)

achievement(
  title = "Master Builder",
  description = "Purchase every item in the " + "\"Creator\"" +  " mode",
  points = 25,
  trigger = (
    LoadProtection() &&
    CreatorPurchases == 252 &&
    prev(CreatorPurchases) == 251
  )
)

// ---------------------------------------- LEVEL SPEED RUNS ----------------------------------------
function SpeedrunLevel(achTitle, levelName, levelTimerAddr, textTime, secs){
  achievement(
    title = achTitle,
    description = "Complete " + "\"" + levelName + "\"" + " in under " + textTime,
    points = 5,
    trigger = (
      LoadProtection() && 
      float_be(levelTimerAddr) < secs &&
      (
        prev(float_be(levelTimerAddr)) == 0.0
        ||
        float_be(levelTimerAddr) < prev(float_be(levelTimerAddr))
      )
    )
  )
}

SpeedrunLevel("Too Toasty Here!", "Toasty Tavern", 0x10dc2a80, "1 minute and 8 seconds", 68)
SpeedrunLevel("Speedozer", "Buildozer", 0x10dc362c, "1 minute and 18 seconds", 78)
SpeedrunLevel("Wrong Gong Rush", "Wrong Gong Rung", 0x10dc3f40, "1 minute and 6 seconds", 66)
SpeedrunLevel("Dad. What? Dad! What? Head for the Fireplace", "Brunwald Blaze", 0x10dc4d84, "2 minutes and 2 seconds", 122)
SpeedrunLevel("Café Crasher", "Café Chaos", 0x10dc6390, "1 minute and 22 seconds", 82)
SpeedrunLevel("Speed Attack", "Mac Attack", 0x10dc75b8, "3 minutes and 2 seconds", 182)
SpeedrunLevel("Pit Speedrunner", "Pit of Peril", 0x10dc8d10, "1 minute and 20 seconds", 80)
// ---------------------------------------- RP ----------------------------------------

LevelIDs = {
    0x36: "Raiders of the Lost Ark Hub",
    0x37: "Raven Rescue",
    0x39: "Market Mayhem",
    0x3b: "Map Room Mystery",
    0x3e: "After the Ark",
    0x40: "Belloq Battle",
    0x38: "Toasty Tavern",
    0x3a: "Cairo Conundrum",
    0x3d: "Cryptic Crypt",
    0x3f: "Desert Dash",
    0x41: "Buildozer",
    0x86: "Mountain Shack",
    0x87: "Airstrip Hangar",
    0x88: "Hovitos Temple",
    0x89: "Bantu Wind",
    0x8a: "Submarine Base",
    0x43: "Temple of Doom Hub",
    0x44: "Lao Chase",
    0x47: "Monkey Mischief",
    0x49: "Malice at the Palace",
    0x4b: "Temple Tantrum",
    0x4d: "Mola Rampage",
    0x45: "Shang-High",
    0x48: "Wrong Gong Rung",
    0x4a: "Disarming Duel",
    0x4c: "Lava Lake",
    0x4e: "Cliff Clamber",
    0x8d: "Club ObiWan",
    0x8e: "Beachside Cave",
    0x8f: "Slave Driver Cave",
    0x90: "Mountain Cave",
    0x91: "Princess Rescue",
    0x50: "The Last Crusade Hub",
    0x51: "The Coronado Caper",
    0x53: "Brunwald Blaze",
    0x55: "Berlin Brawl",
    0x57: "Cannon Canyon",
    0x59: "Trial & Terror",
    0x52: "Crab Cake Confusion",
    0x54: "Castle Quench",
    0x56: "Perilous Parking",
    0x58: "Canyon Quest",
    0x5a: "Chalice Challenge",
    0x93: "Venice Library",
    0x94: "Beach Pit",
    0x95: "Berlin Airport",
    0x96: "Castle Cave",
    0x97: "Venice Tunnel",
    0x5c: "Kingdom of the Crystal Skull - Part 1 Hub",
    0x5e: "Hangar Havoc",
    0x60: "Hangar Havoc",
    0x61: "Doom Town",
    0x64: "Café Chaos",
    0x66: "Motorbike Mayhem",
    0x69: "Crane Train",
    0x5f: "Forklift Fun",
    0x63: "Dummy Run",
    0x65: "Diner Distraction",
    0x67: "Bike Hike",
    0x6b: "Target Training",
    0x99: "Marshall College",
    0x9a: "Petrol Station",
    0x9b: "Doom Town House 2",
    0x9c: "Interrogation Room",
    0x9d: "Hangar 52",
    0x6d: "Kingdom of the Crystal Skull - Part 2 Hub",
    0x6e: "Peru Cell Perusal",
    0x70: "Tomb Doom",
    0x72: "Mac Attack",
    0x77: "Rainforest Rumble",
    0x74: "Dovchenko Duel",
    0x6f: "Musical Mania",
    0x71: "Tomb Time",
    0x73: "Mirror Mayhem",
    0x78: "Forest Forage",
    0x75: "Jungle Jump",
    0x9f: "Peru Airport",
    0xa0: "Peruvian Market",
    0xa1: "Graveyard Tomb",
    0xa2: "Temple Tussle",
    0xa3: "Gorge in the Jungle",
    0x79: "Kingdom of the Crystal Skull - Part 3 Hub",
    0x7a: "Repair Scare",
    0x7c: "River Ruckus",
    0x7e: "Temple Tangle",
    0x80: "Ugha Struggle",
    0x82: "Akator Ambush",
    0x83: "Akator Ambush",
    0x7b: "Campfire Countdown",
    0x7d: "Riverside Rush",
    0x7f: "Trick or Treasure",
    0x81: "Tie Up High Up",
    0x84: "Pit of Peril",
    0xa5: "Jungle Japes",
    0xa6: "Lake Crypt",
    0xa7: "Digger's Delight",
    0xa8: "Treasure Room",
    0xa9: "Cave Capers",
    0xab: "Raiders of the Lost Ark Super Bonus",
    0xac: "Temple of Doom Super Bonus",
    0xad: "The Last Crusade Super Bonus",
    0xae: "Kingdom of the Crystal Skull - Part 1 Super Bonus",
    0xaf: "Kingdom of the Crystal Skull - Part 2 Super Bonus",
    0xb0: "Kingdom of the Crystal Skull - Part 3 Super Bonus",
    0xb3: "Creator Tutorial 1",
    0xb4: "Creator Tutorial 2",
    0xb5: "Creator Tutorial 3",
    0xb6: "Creator Tutorial 4",
    0xb8: "Custom Creator Level",
    0xb9: "Custom Creator Level",
    0xba: "Custom Creator Level",
    0xbb: "Custom Creator Level",
    0xbc: "Custom Creator Level",
    0xbd: "Custom Creator Level",
    0xbe: "Custom Creator Level",
    0xbf: "Custom Creator Level",
    0xc0: "Custom Creator Level",
    0xc1: "Custom Creator Level",
    0xc2: "Custom Creator Level",
    0xc3: "Custom Creator Level",
    0xc4: "Custom Creator Level",
    0xc5: "Custom Creator Level",
    0xc6: "Custom Creator Level",
    0xc7: "Custom Creator Level",
    0xc8: "Custom Creator Level",
    0xc9: "Custom Creator Level",
    0xca: "Custom Creator Level",
    0xcb: "Custom Creator Level",
    0xcc: "Custom Creator Level",
    0xcd: "Custom Creator Level",
    0xce: "Custom Creator Level",
    0xcf: "Custom Creator Level",
    0xd0: "Custom Creator Level",
    0xd1: "Custom Creator Level",
    0xd2: "Custom Creator Level",
    0xd3: "Custom Creator Level",
    0xd4: "Custom Creator Level",
    0xd5: "Custom Creator Level",
    0xd6: "Custom Creator Level",
    0xd7: "Custom Creator Level",
    0xd8: "Custom Creator Level",
    0xd9: "Custom Creator Level",
    0xda: "Custom Creator Level",
    0xdb: "Custom Creator Level",
    0xdc: "Custom Creator Level",
    0xdd: "Custom Creator Level",
    0xde: "Custom Creator Level",
    0xdf: "Custom Creator Level",
    0xe0: "Custom Creator Level",
    0xe1: "Custom Creator Level",
    0xe2: "Custom Creator Level",
    0xe3: "Custom Creator Level",
    0xe4: "Custom Creator Level",
    0xe5: "Custom Creator Level",
    0xe6: "Custom Creator Level",
    0xe7: "Custom Creator Level",
    0xe8: "Custom Creator Level"
}

function IsInMainMenu() => CurrentLevel() == 0x33
function IsLoading() => CurrentLevel() == 0x00000000 || CurrentLevel() == 0xffffffff

RedBricksTotal = dword_be(0x10dde764) + dword_be(0x10dde780) + dword_be(0x10dde79c) + dword_be(0x10dde7b8) + dword_be(0x10dde7d4) + dword_be(0x10dde7f0)
GreenBricksTotal = dword_be(0x10dde768) + dword_be(0x10dde784) + dword_be(0x10dde7a0) + dword_be(0x10dde7bc) + dword_be(0x10dde7d8) + dword_be(0x10dde7f4)
BlueBricksTotal = dword_be(0x10dde76c) + dword_be(0x10dde788) + dword_be(0x10dde7a4) + dword_be(0x10dde7c0) + dword_be(0x10dde7dc) + dword_be(0x10dde7f8)

rich_presence_conditional_display(IsInMainMenu(), "Preparing for an adventure...")
rich_presence_display("Adventuring in {0} [Characters: {1}/141] [True Adventurer: {2}/90] [Red Bricks: {3}/60 ] [Green Bricks: {4}/60 ] [Blue Bricks: {5}/60 ] [Extras: {6}/18]",
  rich_presence_lookup("Level", CurrentLevel(), LevelIDs),
  rich_presence_value("Characters", RaidersCharactersVehicles + TempleOfDoomCharactersVehicles + LastCrusadeCharactersVehicles + CrystalSkullP1CharactersVehicles + CrystalSkullP2CharactersVehicles + CrystalSkullP3CharactersVehicles),
  rich_presence_value("TrueAdventurer", RaidersTrueAdventurer + TempleOfDoomTrueAdventurer + LastCrusadeTrueAdventurer + CrystalSkullP1TrueAdventurer + CrystalSkullP2TrueAdventurer + CrystalSkullP3TrueAdventurer),
  rich_presence_value("RedBricks", RedBricksTotal),
  rich_presence_value("GreenBricks", GreenBricksTotal),
  rich_presence_value("BlueBricks", BlueBricksTotal),
  rich_presence_value("Extras", ExtrasPurchased)
)