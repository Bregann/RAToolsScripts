// Scooby-Doo! Mystery Mayhem
// #ID = 6771

CurrentEpisode = byte(0x01b3a0)
function IsInGame() => 
(byte(0x0086b9) != 0x00 && byte(0x0086b9) != 0x6b && byte(0x0086b9) != 0x69 && byte(0x0086b9) != 0x60 && byte(0x0086b9) != 0x61 &&
byte(0x0086b9) != 0x0a && byte(0x0086b9) != 0x62 && byte(0x0086b9) != 0x68 && byte(0x0086b9) != 0x6a) ||
(byte(0x0086f9) != 0x00 && byte(0x0086f9) != 0x6b && byte(0x0086f9) != 0x69 && byte(0x0086f9) != 0x60 && byte(0x0086f9) != 0x61 &&
byte(0x0086f9) != 0x0a && byte(0x0086f9) != 0x62 && byte(0x0086f9) != 0x68 && byte(0x0086f9) != 0x6a) 

function IsInGameNoLoading() => 
(byte(0x0086b9) != 0x00 && byte(0x0086b9) != 0x6b && byte(0x0086b9) != 0x69 && byte(0x0086b9) != 0x60 && byte(0x0086b9) != 0x61 &&
byte(0x0086b9) != 0x0a && byte(0x0086b9) != 0x62 && byte(0x0086b9) != 0x6a) ||
(byte(0x0086f9) != 0x00 && byte(0x0086f9) != 0x6b && byte(0x0086f9) != 0x69 && byte(0x0086f9) != 0x60 && byte(0x0086f9) != 0x61 &&
byte(0x0086f9) != 0x0a && byte(0x0086f9) != 0x62 && byte(0x0086f9) != 0x6a) 

function IsInMenus() => 
(byte(0x0086b9) == 0x00 || byte(0x0086b9) == 0x6b || byte(0x0086b9) == 0x69 || byte(0x0086b9) == 0x60 || byte(0x0086b9) == 0x61 ||
byte(0x0086b9) == 0x0a || byte(0x0086b9) == 0x62 || byte(0x0086b9) == 0x68 || byte(0x0086b9) == 0x6a) ||
(byte(0x0086f9) == 0x00 || byte(0x0086f9) == 0x6b || byte(0x0086f9) == 0x69 || byte(0x0086f9) == 0x60 || byte(0x0086f9) == 0x61 ||
byte(0x0086f9) == 0x0a || byte(0x0086f9) == 0x62 || byte(0x0086f9) == 0x68 || byte(0x0086f9) == 0x6a) 

function IsInMenusNoLoading() => 
(byte(0x0086b9) == 0x00 || byte(0x0086b9) == 0x6b || byte(0x0086b9) == 0x69 || byte(0x0086b9) == 0x60 || byte(0x0086b9) == 0x61 ||
byte(0x0086b9) == 0x0a || byte(0x0086b9) == 0x62 || byte(0x0086b9) == 0x6a) ||
(byte(0x0086f9) == 0x00 || byte(0x0086f9) == 0x6b || byte(0x0086f9) == 0x69 || byte(0x0086f9) == 0x60 || byte(0x0086f9) == 0x61 ||
byte(0x0086f9) == 0x0a || byte(0x0086f9) == 0x62 || byte(0x0086f9) == 0x6a) 

function CurrentArea(screenId) => byte(0x0086b9) == screenId || byte(0x0086f9) == screenId
function PrevCurrentArea(screenId) => prev(byte(0x0086f9)) == screenId

function SandwichComplete(achTitle, episodeNum, episodeHex, sandwichAddr) {
  achievement(
    title = achTitle,
    description = "Create both sandwiches in episode " + episodeNum,
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
    description = "Find the " + "\"" + clueName + "\"" + " clue in episode " + episodeNum,
    points = 3,
    type = "Progression",
    trigger = (
      IsInGame() &&
      CurrentEpisode == episodeHex &&
      clueAddr == 1 &&
      prev(clueAddr) == 0
    )
  )
}

// because there are different ways you can get the clues it seems like...
function Level1ClueFound(achTitle, clueName, clueAddr, clueHex, episodeNum, episodeHex) {
  achievement(
    title = achTitle,
    description = "Find the " + "\"" + clueName + "\"" + " clue in episode " + episodeNum,
    points = 3,
    type = "Progression",
    trigger = (
      IsInGame() &&
      CurrentEpisode == episodeHex &&
      clueAddr == prev(clueAddr) + clueHex
    )
  )
}

function TomePagesFound(achTitle, episodeNum, episodeHex, pageAddr){
  achievement(
    title = achTitle,
    description = "Find all of the tome pages on episode " + episodeNum,
    points = 5,
    trigger = (
      IsInGame() &&
      measured(pageAddr == 3, CurrentEpisode == episodeHex) &&
      prev(pageAddr) == 2
    )
  )
}

function LevelComplete(achTitle, points, type, episodeNum, episodeHex, levelAddr, levelAmount) {
  achievement(
    title = achTitle,
    description = "Complete episode " + episodeNum,
    points = points,
    type = type,
    trigger = (
      IsInGame() &&
      CurrentEpisode == episodeHex &&
      levelAddr == prev(levelAddr) + levelAmount
    )
  )
}


function CartSpeedrun(achTitle, achDesc, beforeCartId, startingLevelId, endLevelId, cartLevelIds, frames){
  achievement(
    title = achTitle,
    description = achDesc,
    points = 10,
    type = "Missable",
    trigger = (
      (once((byte(0x0086b9) == startingLevelId || byte(0x0086f9) == startingLevelId) && prior(byte(0x0086b9)) == beforeCartId) || (once(byte(0x0086b9) == startingLevelId && byte(0x0086f9) == startingLevelId && prior(byte(0x0086f9)) == 0x68))) &&
      never(tally(frames, any_of(cartLevelIds, id => id == byte(0x0086b9) || id == byte(0x0086f9))) || IsInMenusNoLoading()) &&
      trigger_when(CurrentArea(endLevelId))
    )
  )
}

function CartLeaderboard(lbTitle, levelNum, startingLevelId, lastCartAreaId, endingLevelId, cartLevelIds){
  leaderboard(
    title = lbTitle,
    description = "Complete the cart minigame on episode " + levelNum + " in the fastest time possible",
    start = (
      IsInGameNoLoading() &&
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
Level1ClueFound("Spooky Sales Slip", "Receipt", byte(0x01af80), 0x3f, 1, 0x00)
Level1ClueFound("You've Got Frightmail", "Telegram", byte(0x01af80), 0x40, 1, 0x00)
Level1ClueFound("A Note-orious Clue", "Crumpled Note", byte(0x01af80), 0x80, 1, 0x00)

Level1CartAreaHex = [0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c]
CartSpeedrun("Book Cart Dash", "Complete the book cart minigame in under 34 seconds (reload your save to try again)", 0x16, 0x17, 0x1d, Level1CartAreaHex, 2040)
CartLeaderboard("Episode 1 - Cart Minigame", 1, 0x17, 0x1c, 0x1d, Level1CartAreaHex)

SandwichLevel1 = 
bit0(0x01af85) + bit3(0x01af84) + bit5(0x01af84) + bit6(0x01af84) + bit7(0x01af84) +
bit3(0x01af83) + bit4(0x01af83) + bit6(0x01af83) + bit2(0x01af84) + bit4(0x01af84)
SandwichComplete("The Mansion Sandwiches", 1, 0x00, SandwichLevel1)

LevelComplete("The Mansion Mystery Solved!", 5, "Progression", 1, 0x00, byte(0x01af87), 0x10)

// ---------- Level 2 ------------
ClueFound("Box Office Bust", "Receipt", bit3(0x01af64), 2, 0x01)
ClueFound("Director's Credentials", "Business Card", bit4(0x01af64), 2, 0x01)
ClueFound("Plot Twist Pamphlet", "Brochure", bit5(0x01af64), 2, 0x01)

Level2CartAreaHex = [0x28, 0x29, 0x2a, 0x2b, 0x2c]
CartSpeedrun("Straight out of an Action Movie!", "Complete the movie cart minigame in under 30 seconds (reload your save to try again)", 0x27, 0x28, 0x2d, Level2CartAreaHex, 1800)
CartLeaderboard("Episode 2 - Cart Minigame", 2, 0x28, 0x2c, 0x2d, Level2CartAreaHex)

SandwichLevel2 = 
bit7(0x01af83) + bit2(0x01af84) + bit6(0x01af84) + bit7(0x01af84) + bit0(0x01af85) +
bit3(0x01af83) + bit1(0x01af84) + bit3(0x01af84) + bit4(0x01af84) + bit5(0x01af84)
SandwichComplete("Movie Snacks", 2, 0x01, SandwichLevel2)

TombPagesLevel2 = bit4(0x01af95) + bit5(0x01af95) + bit6(0x01af95)
TomePagesFound("A Spooky Movie Script", 2, 0x01, TombPagesLevel2)

LevelComplete("A Bright Knight", 5, "Progression", 2, 0x01, byte(0x01af89), 0x40)

// ---------- Level 3 ------------
ClueFound("Saloon Scribbles", "Note", bit6(0x01af64), 3, 0x02)
ClueFound("A Ticket to the Wild West", "One-Way Train Ticket", bit7(0x01af64), 3, 0x02)
ClueFound("Look at This Photograph", "Photograph", bit0(0x01af65), 3, 0x02)

Level3CartAreaHex = [0x3f, 0x40, 0x41, 0x42]
CartSpeedrun("Mining Away", "Complete the mine cart minigame in under 52 seconds (reload your save to try again)", 0x3e, 0x3f, 0x43, Level3CartAreaHex, 3120)
CartLeaderboard("Episode 3 - Cart Minigame", 3, 0x3f, 0x42, 0x43, Level3CartAreaHex)

SandwichLevel3 = 
bit6(0x01af83) + bit0(0x01af84) + bit1(0x01af84) + bit5(0x01af84) + bit0(0x01af85) + 
bit4(0x01af83) + bit7(0x01af83) + bit2(0x01af84) + bit6(0x01af84) + bit7(0x01af84)
SandwichComplete("A Weird Wild Sandwich", 3, 0x02, SandwichLevel3)

TombPagesLevel3 = bit7(0x01af95) + bit0(0x01af96) + bit1(0x01af96)
TomePagesFound("Wild West Pages", 3, 0x02, TombPagesLevel3)

LevelComplete("Dust Devil Destroyer", 5, "Progression", 3, 0x02, byte(0x01af8c), 0x80)

// ---------- Level 4 ------------
ClueFound("Swampy Secrets", "Letter", bit1(0x01af65), 4, 0x03)
ClueFound("The Bayou Grimoire", "Book", bit2(0x01af65), 4, 0x03)
ClueFound("Documents of Doom", "Greenwood Development Documents", bit3(0x01af65), 4, 0x03)

Level4CartAreaHex = [0x4e, 0x4f, 0x50]
CartSpeedrun("Speedboat", "Complete the boat minigame in under 52 seconds (reload your save to try again)", 0x4d, 0x4e, 0x51, Level4CartAreaHex, 3120)
CartLeaderboard("Episode 4 - Boat Minigame", 3, 0x4e, 0x50, 0x51, Level4CartAreaHex)

SandwichLevel4 =
bit6(0x01af83) + bit7(0x01af83) + bit2(0x01af84) + bit3(0x01af84) + bit5(0x01af84) +
bit4(0x01af83) + bit0(0x01af84) + bit4(0x01af84) + bit6(0x01af84) + bit7(0x01af84)

SandwichComplete("Zombie Sandwich", 4, 0x03, SandwichLevel4)

TombPagesLevel4 = bit2(0x01af96) + bit3(0x01af96) + bit4(0x01af96)
TomePagesFound("Dead Pages", 4, 0x03, TombPagesLevel4)

LevelComplete("Zombie Banisher", 5, "Progression", 4, 0x03, byte(0x01af93), 0x20)

// ---------- Level 5 ------------
// cart speedrun
ClueFound("Labyrinth of the Lab", "Geographical Map", bit4(0x1af65), 5, 0x04)
ClueFound("Secrets in Storage", "Encrypted Computer Disk", bit5(0x1af65), 5, 0x04)
ClueFound("Lab Rats List", "List of Names", bit6(0x1af65), 5, 0x04)

Level5CartAreaHex = [0x5c, 0x5d, 0x5e]
CartSpeedrun("Lab Cart Dash", "Complete the cart minigame in under 30 seconds (reload your save to try again)", 0x5a, 0x5c, 0x59, Level5CartAreaHex, 1800)
CartLeaderboard("Episode 5 - Cart Minigame", 4, 0x5c, 0x5e, 0x59, Level5CartAreaHex)

SandwichLevel5 = 
bit1(0x01af84) + bit4(0x01af84) + bit5(0x01af84) + bit6(0x01af84) + bit7(0x01af84) +
bit6(0x01af83) + bit7(0x01af83) + bit2(0x01af84) + bit0(0x01af85) + bit0(0x01af84)

SandwichComplete("Lab Snacks", 5, 0x04, SandwichLevel5)

TombPagesLevel5 = bit5(0x01af96) + bit6(0x01af96) + bit7(0x01af96)
TomePagesFound("Lab Notes", 5, 0x04, TombPagesLevel5)

LevelComplete("Haunting Deleted", 10, "Win_Condition", 5, 0x04, byte(0x01af94), 0x40)

// RP
rich_presence_conditional_display(IsInMenus(), "In The Title Screen")
rich_presence_display("Shaggy and Scooby are solving a mystery in episode {0}! {1} lives",
    rich_presence_value("Episode", CurrentEpisode + 1),
    rich_presence_value("Lives", byte(0x01af40))
)