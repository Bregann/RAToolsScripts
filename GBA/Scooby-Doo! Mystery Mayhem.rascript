// Scooby-Doo! Mystery Mayhem
// #ID = 6771

CurrentEpisode = byte(0x01b3a0)
function IsInGame() => 
(byte(0x0086b9) != 0x00 && byte(0x0086b9) != 0x6b && byte(0x0086b9) != 0x69 && byte(0x0086b9) != 0x60 && byte(0x0086b9) != 0x61 &&
byte(0x0086b9) != 0x0a && byte(0x0086b9) != 0x62 && byte(0x0086b9) != 0x68 && byte(0x0086b9) != 0x6a) ||
(byte(0x0086f9) != 0x00 && byte(0x0086f9) != 0x6b && byte(0x0086f9) != 0x69 && byte(0x0086f9) != 0x60 && byte(0x0086f9) != 0x61 &&
byte(0x0086f9) != 0x0a && byte(0x0086f9) != 0x62 && byte(0x0086f9) != 0x68 && byte(0x0086f9) != 0x6a) 

function CurrentArea(screenId) => byte(0x0086b9) == screenId || byte(0x0086f9) == screenId

function SandwichComplete(achTitle, episodeNum, episodeHex, sandwichAddr) {
  achievement(
    title = achTitle,
    description = "Create both sandwiches in episode" + episodeNum,
    points = 5,
    trigger = (
      IsInGame() &&
      CurrentEpisode == episodeHex &&
      prev(sandwichAddr) == 9 &&
      sandwichAddr == 10
    )
  )
}

function ClueFound(achTitle, clueName, clueAddr, episodeNum, episodeHex) {
  achievement(
    title = achTitle,
    description = "Find the" + "\"" + clueName + "\"" + " clue in episode " + episodeNum,
    points = 2,
    type = "Progression",
    trigger = (
      IsInGame() &&
      CurrentEpisode == episodeHex &&
      clueAddr == 1 &&
      prev(clueAddr) == 0
    )
  )
}

function LevelComplete(achTitle, type, episodeNum, episodeHex, levelAddr, prevLevelHex) {
  achievement(
    title = achTitle,
    description = "Complete episode " + episodeNum,
    points = 5,
    type = type,
    trigger = (
      IsInGame() &&
      CurrentEpisode == episodeHex &&
      levelAddr == 0xff &&
      prev(levelAddr) == prevLevelHex
    )
  )
}

// ---------- Level 1 ------------

ClueFound("Receipt", "Receipt", bit0(0x01af64), 1, 0x00)
ClueFound("Telegram", "Telegram", bit1(0x01af64), 1, 0x00)
ClueFound("Crumpled Note", "Crumpled Note", bit2(0x01af64), 1, 0x00)

SandwichLevel1 = 
bit0(0x01af85) + bit3(0x01af84) + bit5(0x01af84) + bit6(0x01af84) + bit7(0x01af84) +
bit3(0x01af83) + bit4(0x01af83) + bit6(0x01af83) + bit2(0x01af84) + bit4(0x01af84)
SandwichComplete("The Mansion Sandwiches", 1, 0x00, SandwichLevel1)

LevelComplete("The Mansion Mystery Solved!", "Progression", 1, 0x00, byte(0x01af87), 0xef)