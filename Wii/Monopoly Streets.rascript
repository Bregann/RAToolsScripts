// Monopoly Streets
// #ID = 35391

// -------------------- Data --------------------

PropertyPointer = dword_be(0x0057aad0)
GameDataPointer = dword_be(0x005287d4) & 0x1fffffff

Player1ProfileAward = dword_be(GameDataPointer + 0x09d8)
Player2ProfileAward = dword_be(GameDataPointer + 0x157c)
Player3ProfileAward = dword_be(GameDataPointer + 0x2120)
Player4ProfileAward = dword_be(GameDataPointer + 0x2cc4)

function IsInGame() => PropertyPointer != 0x00
function CurrentRuleSet() => dword_be(0x1285033c)

AiPlayer2Difficulty = dword_be(0x12850570)
AiPlayer3Difficulty = dword_be(0x12850574)
AiPlayer4Difficulty = dword_be(0x12850578)

function IsAgainstAIs(minAiType) => 
  dword_be(0x12850570) >= minAiType && dword_be(0x12850570) != 0xffffffff && 
  dword_be(0x12850574) >= minAiType && dword_be(0x12850574) != 0xffffffff &&
  dword_be(0x12850578) >= minAiType && dword_be(0x12850578) != 0xffffffff

function PlayerWonGame() => 
  IsInGame() && 
  Player1ProfileAward > Player2ProfileAward && 
  Player1ProfileAward > Player3ProfileAward && 
  Player1ProfileAward > Player4ProfileAward && 
  prev(Player1ProfileAward) == 0x00

// -------------------- Game Wins --------------------

function GameWonAchievement(achTitle, ruleSet, ruleSetSelected){
  achievement(
    title = achTitle,
    description = "Win a game against any CPU difficulty on the \"" + ruleSet + "\" rule set",
    points = 5,
    type = "Progression",
    trigger = (
      PlayerWonGame() &&
      IsAgainstAIs(0x01) &&
      CurrentRuleSet() == ruleSetSelected
    )
  )
}

GameWonAchievement("A Classic Win", "Official MONOPOLY", 0x00)
GameWonAchievement("Gotta Roll Fast", "Speed Die", 0x01)
GameWonAchievement("Blink and You're Bankrupt", "Short Game", 0x02)
GameWonAchievement("Bidding out the Competition", "Bull Market", 0x03)
GameWonAchievement("The House Always Wins", "Jackpot", 0x04)
GameWonAchievement("Going Once, Going Twice...", "Fast Deal", 0x05)

achievement(
  title = "Master of All Trades",
  description = "Win an \"Official MONOPOLY\" rule set game against three AIs - one on Easy, one on Medium, and one on Hard difficulty",
  points = 10,
  trigger = (
    PlayerWonGame() &&
    ( // every possible combo as it's easier than using hits
      (AiPlayer2Difficulty == 0x01 &&
      AiPlayer3Difficulty == 0x02 &&
      AiPlayer4Difficulty == 0x03)
      ||
      (AiPlayer2Difficulty == 0x01 &&
      AiPlayer3Difficulty == 0x03 &&
      AiPlayer4Difficulty == 0x02)
      ||
      (AiPlayer2Difficulty == 0x02 &&
      AiPlayer3Difficulty == 0x01 &&
      AiPlayer4Difficulty == 0x03)
      ||
      (AiPlayer2Difficulty == 0x02 &&
      AiPlayer3Difficulty == 0x03 &&
      AiPlayer4Difficulty == 0x01)
      ||
      (AiPlayer2Difficulty == 0x03 &&
      AiPlayer3Difficulty == 0x01 &&
      AiPlayer4Difficulty == 0x02)
      ||
      (AiPlayer2Difficulty == 0x03 &&
      AiPlayer3Difficulty == 0x02 &&
      AiPlayer4Difficulty == 0x01)
    )
  )
)

// -------------------- RP --------------------
RuleSets = {
  0x00: "Official MONOPOLY",
  0x01: "Speed Die",
  0x02: "Short Game",
  0x03: "Bull Market",
  0x04: "Jackpot",
  0x05: "Fast Deal"
}