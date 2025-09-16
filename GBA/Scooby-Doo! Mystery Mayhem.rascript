// Scooby-Doo! Mystery Mayhem
// #ID = 6771

CurrentEpisode = byte(0x01b3a0)
function IsInGame() => 
(byte(0x0086b9) != 0x00 && byte(0x0086b9) != 0x6b && byte(0x0086b9) != 0x69 && byte(0x0086b9) != 0x60 && byte(0x0086b9) != 0x61 &&
byte(0x0086b9) != 0x0a && byte(0x0086b9) != 0x62 && byte(0x0086b9) != 0x68 && byte(0x0086b9) != 0x6a) ||
(byte(0x0086f9) != 0x00 && byte(0x0086f9) != 0x6b && byte(0x0086f9) != 0x69 && byte(0x0086f9) != 0x60 && byte(0x0086f9) != 0x61 &&
byte(0x0086f9) != 0x0a && byte(0x0086f9) != 0x62 && byte(0x0086f9) != 0x68 && byte(0x0086f9) != 0x6a) 

function IsInMenus() => 
(byte(0x0086b9) == 0x00 || byte(0x0086b9) == 0x6b || byte(0x0086b9) == 0x69 || byte(0x0086b9) == 0x60 || byte(0x0086b9) == 0x61 ||
byte(0x0086b9) == 0x0a || byte(0x0086b9) == 0x62 || byte(0x0086b9) == 0x68 || byte(0x0086b9) == 0x6a) ||
(byte(0x0086f9) == 0x00 || byte(0x0086f9) == 0x6b || byte(0x0086f9) == 0x69 || byte(0x0086f9) == 0x60 || byte(0x0086f9) == 0x61 ||
byte(0x0086f9) == 0x0a || byte(0x0086f9) == 0x62 || byte(0x0086f9) == 0x68 || byte(0x0086f9) == 0x6a) 


function CurrentArea(screenId) => byte(0x0086b9) == screenId || byte(0x0086f9) == screenId

function SandwichComplete(achTitle, episodeNum, episodeHex, sandwichAddr) {
  achievement(
    title = achTitle,
    description = "Create both sandwiches in episode" + episodeNum,
    points = 5,
    trigger = (
      IsInGame() &&
      prev(sandwichAddr) == 9 &&
      measured(sandwichAddr == 10, CurrentEpisode == episodeHex)
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

function TomePagesFound(achTitle, episodeNum, episodeHex, pageAddr){
  achievement(
    title = achTitle,
    description = "Find all of the tome pages on episode " + episodeNum,
    points = 4,
    trigger = (
      IsInGame() &&
      measured(pageAddr == 3, CurrentEpisode == episodeHex) &&
      prev(pageAddr) == 2
    )
  )
}

function LevelComplete(achTitle, type, episodeNum, episodeHex, levelAddr, prevLevelHex, levelHex) {
  achievement(
    title = achTitle,
    description = "Complete episode " + episodeNum,
    points = 5,
    type = type,
    trigger = (
      IsInGame() &&
      CurrentEpisode == episodeHex &&
      levelAddr == levelHex &&
      prev(levelAddr) == prevLevelHex
    )
  )
}

function CartSpeedrun(achTitle, achDesc, startingLevelId, endLevelId, cartLevelIds, frames){
  achievement(
    title = achTitle,
    description = achDesc,
    points = 10,
    type = "Missable",
    trigger = (
      once(CurrentArea(startingLevelId)) &&
      never(tally(600, any_of(cartLevelIds, id => id == byte(0x0086b9) || id == byte(0x0086f9))) || IsInMenus()) &&
      never((prev(byte(0x0086b9)) > byte(0x0086b9)) || (prev(byte(0x0086f9)) > byte(0x0086f9))) &&
      trigger_when(CurrentArea(endLevelId))
    )
  )
}

function CartLeaderboard(lbTitle, levelNum, startingLevelId, lastCartAreaId, endingLevelId, cartLevelIds){
  leaderboard(
    title = lbTitle,
    description = "Complete the cart mini game on episode " + levelNum + " in the fastest time possible",
    start = (
      IsInGame() &&
      CurrentArea(startingLevelId)
    ),
    cancel = (
    IsInMenus()
    ),
    submit = (
      (prev(byte(0x0086b9) == lastCartAreaId) || prev(byte(0x0086f9) == lastCartAreaId)) &&
      CurrentArea(endingLevelId)
    ),
    value = (
      any_of(cartLevelIds, id => id == byte(0x0086b9) || id == byte(0x0086f9))
    ),
    format = "FRAMES",
    lower_is_better = true
  )
}

// ---------- Level 1 ------------
// idea: book cart speedrun
ClueFound("Receipt", "Receipt", bit0(0x01af64), 1, 0x00)
ClueFound("Telegram", "Telegram", bit1(0x01af64), 1, 0x00)
ClueFound("Crumpled Note", "Crumpled Note", bit2(0x01af64), 1, 0x00)

Level1CartAreaHex = [0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c]
CartSpeedrun("cat", "cccc", 0x17, 0x1d, Level1CartAreaHex, 600)
CartLeaderboard("Episode 1 - Cart Minigame", 1, 0x17, 0x1c, 0x1d, Level1CartAreaHex)

SandwichLevel1 = 
bit0(0x01af85) + bit3(0x01af84) + bit5(0x01af84) + bit6(0x01af84) + bit7(0x01af84) +
bit3(0x01af83) + bit4(0x01af83) + bit6(0x01af83) + bit2(0x01af84) + bit4(0x01af84)

SandwichComplete("The Mansion Sandwiches", 1, 0x00, SandwichLevel1)

LevelComplete("The Mansion Mystery Solved!", "Progression", 1, 0x00, byte(0x01af87), 0xef, 0xff)

// ---------- Level 2 ------------
// no mega phone usage through the first scooby alone area?
// movie cart speedrun

ClueFound("Receipt", "Receipt", bit3(0x01af64), 2, 0x01)
ClueFound("Business Card", "Business Card", bit4(0x01af64), 2, 0x01)
ClueFound("Brochure", "Brochure", bit5(0x01af64), 2, 0x01)

SandwichLevel2 = 
bit7(0x01af83) + bit2(0x01af84) + bit6(0x01af84) + bit7(0x01af84) + bit0(0x01af85) +
bit3(0x01af83) + bit1(0x01af84) + bit3(0x01af84) + bit4(0x01af84) + bit5(0x01af84)
SandwichComplete("Movie Snacks", 2, 0x01, SandwichLevel2)

TombPagesLevel2 = bit4(0x01af95) + bit5(0x01af95) + bit6(0x01af95)
TomePagesFound("A Spooky Movie Script", 2, 0x01, TombPagesLevel2)

LevelComplete("A Bright Knight", "Progression", 2, 0x01, byte(0x01af89), 0x3f, 0x7f)
