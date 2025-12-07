// LEGO Indiana Jones 2: The Adventure Continues
// #ID = 11087

function CurrentLevel() => dword_be(0x10db4814)
function LoadProtection() => CurrentLevel() != 0xfffffff && CurrentLevel() != 0x00000000 && CurrentLevel() != 0x00000033

// ---------------------------------------- LEVEL PROGRESS ----------------------------------------

PlayableLevels = {
    0x37: ["Raven Rescue", "Raiders of the Lost Ark", "Story", 0x10dc2933],
    0x39: ["Market Mayhem", "Raiders of the Lost Ark", "Story", 0x10dc2bcb],
    0x3b: ["Map Room Mayhem", "Raiders of the Lost Ark", "Story", 0x10dc2e63],
    0x3e: ["After the Ark", "Raiders of the Lost Ark", "Story", 0x10dc3247],
    0x40: ["Belloq Battle", "Raiders of the Lost Ark", "Story", 0x10dc34df],
    0x38: ["Toasty Tavern", "Raiders of the Lost Ark", "TreasureMode", 0x10dc2a7f],
    0x3a: ["Cairo Conundrum", "Raiders of the Lost Ark", "TreasureMode", 0x10dc2d17],
    0x3d: ["Cryptic Crypt", "Raiders of the Lost Ark", "TreasureMode", 0x10dc30fb],
    0x3f: ["Desert Dash", "Raiders of the Lost Ark", "TreasureMode", 0x10dc3393],
    0x41: ["Buildozer", "Raiders of the Lost Ark", "TreasureMode", 0x10dc362b],
    0x86: ["Mountain Shack", "Raiders of the Lost Ark", "BonusLevel", 0x10dc8fa7],
    0x87: ["Airstrip Hangar", "Raiders of the Lost Ark", "BonusLevel", 0x10dc90f3],
    0x88: ["Hovitos Temple", "Raiders of the Lost Ark", "BonusLevel", 0x10dc923f],
    0x89: ["Bantu Wind", "Raiders of the Lost Ark", "BonusLevel", 0x10dc938b],
    0x8a: ["Submarine Base", "Raiders of the Lost Ark", "BonusLevel", 0x10dc94d7],
    0x44: ["Lao Chase", "Temple of Doom", "Story", 0x10dc3a0f],
    0x47: ["Monkey Mischief", "Temple of Doom", "Story", 0x10dc3df3],
    0x49: ["Malice at the Palace", "Temple of Doom", "Story", 0x10dc408b],
    0x4b: ["Temple Tantrum", "Temple of Doom", "Story", 0x10dc4323],
    0x4d: ["Mola Rampage", "Temple of Doom", "Story", 0x10dc45bb],
    0x45: ["Shang-High", "Temple of Doom", "TreasureMode", 0x10dc3b5b],
    0x48: ["Wrong Gong Rung", "Temple of Doom", "TreasureMode", 0x10dc3f3f],
    0x4a: ["Disarming Duel", "Temple of Doom", "TreasureMode", 0x10dc41d7],
    0x4c: ["Lava Lake", "Temple of Doom", "TreasureMode", 0x10dc446f],
    0x4e: ["Cliff Clamber", "Temple of Doom", "TreasureMode", 0x10dc4707],
    0x8d: ["Club ObiWan", "Temple of Doom", "BonusLevel", 0x10dc98bb],
    0x8e: ["Beachside Cave", "Temple of Doom", "BonusLevel", 0x10dc9a07],
    0x8f: ["Slave Driver Cave", "Temple of Doom", "BonusLevel", 0x10dc9b53],
    0x90: ["Mountain Cave", "Temple of Doom", "BonusLevel", 0x10dc9c9f],
    0x91: ["Princess Rescue", "Temple of Doom", "BonusLevel", 0x10dc9deb],
    0x51: ["Coronado Caper", "The Last Crusade", "Story", 0x10dc4aeb],
    0x53: ["Brunwald Blaze", "The Last Crusade", "Story", 0x10dc4d83],
    0x55: ["Berlin Brawl", "The Last Crusade", "Story", 0x10dc501b],
    0x57: ["Cannon Canyon", "The Last Crusade", "Story", 0x10dc52b3],
    0x59: ["Trial & Terror", "The Last Crusade", "Story", 0x10dc554b],
    0x52: ["Crab Cake Confusion", "The Last Crusade", "TreasureMode", 0x10dc4c37],
    0x54: ["Castle Quench", "The Last Crusade", "TreasureMode", 0x10dc4ecf],
    0x56: ["Perilous Parking", "The Last Crusade", "TreasureMode", 0x10dc5167],
    0x58: ["Canyon Quest", "The Last Crusade", "TreasureMode", 0x10dc53ff],
    0x5a: ["Chalice Challenge", "The Last Crusade", "TreasureMode", 0x10dc5697],
    0x93: ["Venice Library", "The Last Crusade", "BonusLevel", 0x10dca083],
    0x94: ["Beach Pit", "The Last Crusade", "BonusLevel", 0x10dca1cf],
    0x95: ["Berlin Airport", "The Last Crusade", "BonusLevel", 0x10dca31b],
    0x96: ["Castle Cave", "The Last Crusade", "BonusLevel", 0x10dca467],
    0x97: ["Venice Tunnel", "The Last Crusade", "BonusLevel", 0x10dca5b3],
    0x5e: ["Hangar Havoc", "Crystal Skull Part 1", "Story", 0x10dc5bc7],
    0x61: ["Doom Town", "Crystal Skull Part 1", "Story", 0x10dc5fab],
    0x64: ["Cafe Chaos", "Crystal Skull Part 1", "Story", 0x10dc638f],
    0x66: ["Motorbike Mayhem", "Crystal Skull Part 1", "Story", 0x10dc6627],
    0x69: ["Crane Train", "Crystal Skull Part 1", "Story", 0x10dc6a0b],
    0x5f: ["Forklift Fun", "Crystal Skull Part 1", "TreasureMode", 0x10dc5d13],
    0x63: ["Dummy Run", "Crystal Skull Part 1", "TreasureMode", 0x10dc6243],
    0x65: ["Diner Distraction", "Crystal Skull Part 1", "TreasureMode", 0x10dc64db],
    0x67: ["Bike Hike", "Crystal Skull Part 1", "TreasureMode", 0x10dc6773],
    0x6b: ["Target Training", "Crystal Skull Part 1", "TreasureMode", 0x10dc6ca3],
    0x99: ["Marshall College", "Crystal Skull Part 1", "BonusLevel", 0x10dca84b],
    0x9a: ["Petrol Station", "Crystal Skull Part 1", "BonusLevel", 0x10dca997],
    0x9b: ["Doom Town House 2", "Crystal Skull Part 1", "BonusLevel", 0x10dcaae3],
    0x9c: ["Interrogation Room", "Crystal Skull Part 1", "BonusLevel", 0x10dcac2f],
    0x9d: ["Hangar 52", "Crystal Skull Part 1", "BonusLevel", 0x10dcad7b],
    0x6e: ["Peru Cell Perusal", "Crystal Skull Part 2", "Story", 0x10dc7087],
    0x70: ["Tomb Doom", "Crystal Skull Part 2", "Story", 0x10dc731f],
    0x72: ["Mac Attack", "Crystal Skull Part 2", "Story", 0x10dc75b7],
    0x77: ["Rainforest Rumble", "Crystal Skull Part 2", "Story", 0x10dc7c33],
    0x74: ["Dovchenko Duel", "Crystal Skull Part 2", "Story", 0x10dc784f],
    0x6f: ["Musical Mania", "Crystal Skull Part 2", "TreasureMode", 0x10dc71d3],
    0x71: ["Tomb Time", "Crystal Skull Part 2", "TreasureMode", 0x10dc746b],
    0x73: ["Mirror Mayhem", "Crystal Skull Part 2", "TreasureMode", 0x10dc7703],
    0x78: ["Forest Forage", "Crystal Skull Part 2", "TreasureMode", 0x10dc7d7f],
    0x75: ["Jungle Jump", "Crystal Skull Part 2", "TreasureMode", 0x10dc799b],
    0x9f: ["Peru Airport", "Crystal Skull Part 2", "BonusLevel", 0x10dcb013],
    0xa0: ["Peruvian Market", "Crystal Skull Part 2", "BonusLevel", 0x10dcb15f],
    0xa1: ["Graveyard Tomb", "Crystal Skull Part 2", "BonusLevel", 0x10dcb2ab],
    0xa2: ["Temple Tussle", "Crystal Skull Part 2", "BonusLevel", 0x10dcb3f7],
    0xa3: ["Gorge in the Jungle", "Crystal Skull Part 2", "BonusLevel", 0x10dcb543],
    0x7a: ["Repair Scare", "Crystal Skull Part 3", "Story", 0x10dc8017],
    0x7c: ["River Ruckus", "Crystal Skull Part 3", "Story", 0x10dc82af],
    0x7e: ["Temple Tangle", "Crystal Skull Part 3", "Story", 0x10dc8547],
    0x80: ["Ugha Struggle", "Crystal Skull Part 3", "Story", 0x10dc87df],
    0x82: ["Akator Ambush", "Crystal Skull Part 3", "Story", 0x10dc8a77],
    0x7b: ["Campfire Countdown", "Crystal Skull Part 3", "TreasureMode", 0x10dc8163],
    0x7d: ["Riverside Rush", "Crystal Skull Part 3", "TreasureMode", 0x10dc83fb],
    0x7f: ["Trick or Treasure", "Crystal Skull Part 3", "TreasureMode", 0x10dc8693],
    0x81: ["Tie Up High Up", "Crystal Skull Part 3", "TreasureMode", 0x10dc892b],
    0x84: ["Pit of Peril", "Crystal Skull Part 3", "TreasureMode", 0x10dc8d0f],
    0xa5: ["Jungle Japes", "Crystal Skull Part 3", "BonusLevel", 0x10dcb7db],
    0xa6: ["Lake Crypt", "Crystal Skull Part 3", "BonusLevel", 0x10dcb927],
    0xa7: ["Digger's Delight", "Crystal Skull Part 3", "BonusLevel", 0x10dcba73],
    0xa8: ["Treasure Room", "Crystal Skull Part 3", "BonusLevel", 0x10dcbbbf],
    0xa9: ["Cave Capers", "Crystal Skull Part 3", "BonusLevel", 0x10dcbd0b],
    0xab: ["Raiders of the Lost Ark Super Bonus", "Super Bonus Levels", "SuperBonus", 0x10dcbfa3],
    0xac: ["Temple of Doom Super Bonus", "Super Bonus Levels", "SuperBonus", 0x10dcc0ef],
    0xad: ["The Last Crusade Super Bonus", "Super Bonus Levels", "SuperBonus", 0x10dcc23b],
    0xae: ["Kingdom of the Crystal Skull - Part 1 Super Bonus", "Super Bonus Levels", "SuperBonus", 0x10dcc387],
    0xaf: ["Kingdom of the Crystal Skull - Part 2 Super Bonus", "Super Bonus Levels", "SuperBonus", 0x10dcc4d3],
    0xb0: ["Kingdom of the Crystal Skull - Part 3 Super Bonus", "Super Bonus Levels", "SuperBonus", 0x10dcc61f]
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

for i in PlayableLevels{
  CompleteLevel(PlayableLevels[i][0], PlayableLevels[i][2], PlayableLevels[i][3])
}