// Robot Wars: Extreme Destruction
// #ID = 5285

// ==================== Memory ====================
function CurrentMode() => byte(0x026d20)
function Difficulty() => byte(0x026cd4)
function CurrentArena() => byte(0x026b6c)
function GauntletChallenge() => byte(0x027258)
function TournamentRound() => byte(0x027855)
function WinFlag() => byte(0x00cc6c)
function InFight() => byte(0x00ccdc) == 1
function GameState() => byte(0x0274aa)  // 0 loading / results, 1 in game, 2 menus
function DamageMeter() => dword(0x020568)
function MenuState() => byte(0x0276d0)
// Pausing sets GameState to the menu value, so count the pause screens as in game too
function Paused() => MenuState() == 41 || MenuState() == 42 || MenuState() == 10  // pause menu, pause options, quit / restart confirm
function InGame() => GameState() == 1 || Paused()
function ClockMinutes() => byte(0x00ccc4)
function ClockSeconds() => byte(0x00cc78)
function PlayerHealth() => dword(0x00d668)
function PlayerMaxHealth() => dword(0x00d670)

// ---- Robots (all roster indexes: 0-16 roster, 17-21 custom slots 1-5) ----
// Robot select screen cursor. Set on the Tournament, Bash 'n' Dash, Mayhem and Gauntlet
// select screens and still holds the robot you picked during the fight.
// Not used by Quickstart (reads a stale value there).
function SelectedRobot() => byte(0x027c3c)

// Quickstart skips the select screen and rolls both robots at random
function QuickstartRobot() => byte(0x027bd4)
function QuickstartOpponent() => byte(0x027900)

// Tournament: your entered robot, and the opponent for each round (Heats, QF, SF, Final)
function TournamentRobot() => byte(0x027858)
function TournamentOpponent() => byte(0x027859 + TournamentRound())

// 81 prizes, one bit each, starting at 0x02771c. 75-80 are the Gold parts, which only
// come from multiplayer (Spoils of War), so they're left out of this single-player set
function PrizeBit(id) => bit(id % 8, 0x02771c + id / 8)
function PrizeCount(ids) => sum_of(ids, id => PrizeBit(id))

// Blocks cheats, the developer menu unlocks and multiplayer
function NoCheats() => (
    unless(byte(0x027650) != 0) &&   // invincibility
    unless(byte(0x0271a8) > 1) &&    // multiplayer
    unless(dword(0x0276f0) != 0) &&  // session-only prize unlocks (cheats)
    unless(dword(0x0276f4) != 0) &&
    unless(word(0x0276f8) != 0) &&
    unless(byte(0x0276fa) != 0)
)

SinglePlayerPrizes = [
  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
  20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
  40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59,
  60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74
]

function WonFight() => prev(WinFlag()) == 0 && WinFlag() == 1

// ==================== Progression ====================
// Only content open on a fresh save: Tournament, Bash 'n' Dash and Mayhem in the Studio,
// and all six Gauntlet challenges, all on Bronze. Silver and Gold open by beating the tier
// below, and the other five arenas are prizes, so neither is progression.
// Progression and the win condition only count a win on Bronze itself.

Challenges = [
  "Slalom", 
  "Skittles", 
  "Long Jump", 
  "Sumo Basho", 
  "Dump", 
  "Drop Zone"
]

Arenas = [
  "the Studio",
  "the Melting Pot",
  "the Acid Bath",
  "the Deep Freeze",
  "the Desert Storm",
  "the Red Planet Rumble"
]

function ArenaWin(modeId, arenaId, minDifficulty, maxDifficulty) => NoCheats() && CurrentMode() == modeId &&
    Difficulty() >= minDifficulty && Difficulty() <= maxDifficulty && CurrentArena() == arenaId && WonFight()
function GauntletWin(challengeId, minDifficulty, maxDifficulty) => NoCheats() && CurrentMode() == 3 &&
    Difficulty() >= minDifficulty && Difficulty() <= maxDifficulty && GauntletChallenge() == challengeId && WonFight()
function TournamentWin(minDifficulty, maxDifficulty) => NoCheats() && CurrentMode() == 0 &&
    Difficulty() >= minDifficulty && Difficulty() <= maxDifficulty && TournamentRound() == 3 && WonFight()

// Gauntlet challenge on Bronze (progression)
function GauntletBronze(achTitle, challengeId) {
  achievement(
    title = achTitle,
    description = "Complete " + Challenges[challengeId] + " in Gauntlet mode on Bronze difficulty",
    points = 5,
    type = "progression",
    trigger = GauntletWin(challengeId, 0, 0)
  )
}

// Gauntlet challenge on Gold
function GauntletGold(achTitle, challengeId) {
  achievement(
    title = achTitle,
    description = "Complete " + Challenges[challengeId] + " in Gauntlet mode on Gold difficulty",
    points = 10,
    trigger = GauntletWin(challengeId, 2, 2)
  )
}

// Bash 'n' Dash (mode 1) or Mayhem (mode 2) arena on Gold
function ArenaGold(achTitle, modeName, modeId, arenaId) {
  achievement(
    title = achTitle,
    description = "Win " + modeName + " mode on Gold difficulty in " + Arenas[arenaId] + " arena",
    points = 10,
    trigger = ArenaWin(modeId, arenaId, 2, 2)
  )
}

achievement(
    title = "Bronze Champion",
    description = "Win Tournament mode on Bronze difficulty",
    points = 10,
    type = "progression",
    trigger = TournamentWin(0, 0)
)

achievement(
  title = "Studio Survivor",
  description = "Win Bash 'n' Dash mode on Bronze difficulty in the Studio arena",
  points = 5,
  type = "progression",
  trigger = ArenaWin(1, 0, 0, 0)
)

achievement(
  title = "Mayhem in the Studio",
  description = "Win Mayhem mode on Bronze difficulty in the Studio arena",
  points = 5,
  type = "progression",
  trigger = ArenaWin(2, 0, 0, 0)
)

GauntletBronze("Weaving Through", 0)       // Slalom
GauntletBronze("Strike!", 1)               // Skittles
GauntletBronze("Leap of Faith", 2)         // Long Jump
GauntletBronze("Pushing the Competition", 3)        // Sumo Basho
GauntletBronze("Taking Out the Trash", 4)  // Dump
GauntletBronze("Barrel Basher", 5)           // Drop Zone

// ==================== Difficulty ====================
achievement(
  title = "Silver Champion",
  description = "Win Tournament mode on Silver difficulty",
  points = 10,
  trigger = TournamentWin(1, 1)
)

achievement(
  title = "Grand Champion",
  description = "Win Tournament mode on Gold difficulty",
  points = 25,
  trigger = TournamentWin(2, 2)
)

// Bash 'n' Dash on Gold, every arena
ArenaGold("Studio Survivor Champion", "Bash 'n' Dash", 1, 0)
ArenaGold("Master of the Lava", "Bash 'n' Dash", 1, 1)
ArenaGold("Toxic Champion", "Bash 'n' Dash", 1, 2)
ArenaGold("Cold Survivor", "Bash 'n' Dash", 1, 3)
ArenaGold("Weathered the Storm", "Bash 'n' Dash", 1, 4)
ArenaGold("Red Planet Robot Destroyer", "Bash 'n' Dash", 1, 5)

// Mayhem on Gold, every arena
ArenaGold("Master of Mayhem", "Mayhem", 2, 0)
ArenaGold("Hotting up in Here", "Mayhem", 2, 1)
ArenaGold("Acidic Winner", "Mayhem", 2, 2)
ArenaGold("Deep Freeze Domination", "Mayhem", 2, 3)
ArenaGold("Too Hot to Handle", "Mayhem", 2, 4)
ArenaGold("Martian Mayhem", "Mayhem", 2, 5)

// Gauntlet on Gold, every challenge
GauntletGold("Slalom Specialist", 0)
GauntletGold("Skittle Smasher", 1)
GauntletGold("Long Jump Legend", 2)
GauntletGold("Sumo Grand Champion", 3)
GauntletGold("Dump Master", 4)
GauntletGold("Drop Zone Daredevil", 5)

// ==================== Rich Presence ====================
ModeLookup = { 
  0: "Tournament",
  1: "Bash 'n' Dash",
  2: "Mayhem",
  3: "Gauntlet",
  5: "Quickstart"
}

LevelLookup = { 
  0: "Bronze",
  1: "Silver",
  2: "Gold"
}
ArenaLookup = {
  0: "Studio",
  1: "Melting Pot",
  2: "Acid Bath",
  3: "Deep Freeze",
  4: "Desert Storm",
  5: "Red Planet Rumble"
}

ChallengeLookup = {
  0: "Slalom",
  1: "Skittles",
  2: "Long Jump",
  3: "Sumo Basho",
  4: "Dump",
  5: "Drop Zone"
}

RoundLookup = { 
  0: "Heats", 
  1: "Quarter Finals", 
  2: "Semi Finals", 
  3: "Final" 
}

// Names checked against the in-game select screen (all 17), custom slots by number only
RobotLookup = {
  0: "Rosie the Riveter II",
  1: "Tricerabot 3.0",
  2: "Dominator 2",
  3: "Pussycat",
  4: "Firestorm III",
  5: "Bigger Brother",
  6: "Hypno-Disc",
  7: "Propeller-Head",
  8: "Thermidor II",
  9: "Wheely Big Cheese",
  10: "Tornado",
  11: "Stinger",
  12: "101",
  13: "Chaos II",
  14: "Razer",
  15: "Destructive Criticism",
  16: "Panzer Mk4",
  17: "Custom Robot 1",
  18: "Custom Robot 2",
  19: "Custom Robot 3",
  20: "Custom Robot 4",
  21: "Custom Robot 5"
}

Mode = rich_presence_lookup("Mode", CurrentMode(), ModeLookup)
Level = rich_presence_lookup("Level", Difficulty(), LevelLookup)
ArenaName = rich_presence_lookup("Arena", CurrentArena(), ArenaLookup)
ChallengeName = rich_presence_lookup("Challenge", GauntletChallenge(), ChallengeLookup)
Round = rich_presence_lookup("Round", TournamentRound(), RoundLookup)
Robot = rich_presence_lookup("Robot", SelectedRobot(), RobotLookup, fallback = "a robot")
Opponent = rich_presence_lookup("Robot", TournamentOpponent(), RobotLookup, fallback = "a robot")
QSRobot = rich_presence_lookup("Robot", QuickstartRobot(), RobotLookup, fallback = "a robot")
QSOpponent = rich_presence_lookup("Robot", QuickstartOpponent(), RobotLookup, fallback = "a robot")
Clock = rich_presence_value("Clock", ClockMinutes() * 60 + ClockSeconds(), "SECS")
Health = rich_presence_value("Num", DamageMeter() * 10)
Prizes = rich_presence_value("Num", PrizeCount(SinglePlayerPrizes))

rich_presence_conditional_display(InGame() && CurrentMode() == 5,
    "Quickstart: {0} vs {1} · {2} left · health {3}%", QSRobot, QSOpponent, Clock, Health)
rich_presence_conditional_display(InGame() && CurrentMode() == 0,
    "Tournament {0} · {1} · {2} vs {3} · {4} left · health {5}%", Level, Round, Robot, Opponent, Clock, Health)
rich_presence_conditional_display(InGame() && CurrentMode() == 3,
    "Gauntlet: {0} ({1}) · {2} · {3} left", ChallengeName, Level, Robot, Clock)
rich_presence_conditional_display(InGame(),
    "Battling in {0} mode {1} in level {2} · {3} · {4} left · health {5}%", Mode, Level, ArenaName, Robot, Clock, Health)

rich_presence_display("In the menus · {0}/75 spoils of war unlocked", Prizes)
