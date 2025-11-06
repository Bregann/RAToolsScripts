// DreamWorks Super Star Kartz
// #ID = 34609

// -------------------- Game Data --------------------

function IsInGame() => dword_be(0x0057f964) != 0x00

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

CupInfo = {
  0x11: ["Wind Cup", "50cc", 3, 0x11],
  0x12: ["Wind Cup", "100cc", 4, 0x12], 
  0x13: ["Wind Cup", "150cc", 5, 0x13],
  0x14: ["Wind Cup", "Mirror", 6, 0x14],
 
  0x21: ["Cloud Cup", "50cc", 3, 0x21],
  0x22: ["Cloud Cup", "100cc", 4, 0x22],
  0x23: ["Cloud Cup", "150cc", 5, 0x23],
  0x24: ["Cloud Cup", "Mirror", 6, 0x24],

  0x31: ["Sun Cup", "50cc", 3, 0x31],
  0x32: ["Sun Cup", "100cc", 4, 0x32],
  0x33: ["Sun Cup", "150cc", 5, 0x33],
  0x34: ["Sun Cup", "Mirror", 6, 0x34],

  0x41: ["Moon Cup", "50cc", 3, 0x41],
  0x42: ["Moon Cup", "100cc", 4, 0x42],
  0x43: ["Moon Cup", "150cc", 5, 0x43],
  0x44: ["Moon Cup", "Mirror", 6, 0x44]
}

// -------------------- Cup Wins --------------------

function WinCircuitCup(cupName, ccType, points, cupIdentifier){
  achievement(
    title = cupName + ccType + " Champion",
    description = "Earn the Gold Cup on the " + cupName + " circuit in the " + ccType + " class",
    points = points,
    type = "Progression",
    trigger = (
      IsInGame() &&
      any_of(CupDataDict, i => dword_be(CupDataDict[i]) == 0x03 && dword_be(i) == cupIdentifier && prev(dword_be(CupDataDict[i])) != 0x03)
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
    description = "Collect both hidden DreamWorks Logos on " + mapName,
    points = 2,
    trigger = (
      IsInGame() &&
      any_of(DreamworksIcons, i => dword_be(i) == val1)
    )
  )
}

CollectCollectibles("test", "test", 0x01, 0x02)