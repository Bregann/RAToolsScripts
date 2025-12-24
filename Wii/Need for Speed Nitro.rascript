// Need for Speed: Nitro
// #ID = 34593

OFFSET = 0xD50

ScorePointer = dword_be(0x007726f4) & 0x1fffffff

function CurrentProfile() => dword_be(0x01578d80)
function IsInGame() => dword_be(0x007726f4) != 0x00000000
function ReliableRaceTimer() => float_be(0x1337cca0)

function SelectedCup() => byte(0x0157c1d8)
function SelectedArea() => byte(0x0157c1d9)
function SelectedEvent() => byte(0x0157c1da)
function CurrentScore() => dword_be(ScorePointer + 0x38)

// Dictionaries
function CalculateOffsetAndReturnAddress(baseAddr){
  dict = {}

  for i in range(0, 5) {
    dict[5 - i] = baseAddr + (i * OFFSET)
  }

  return dict
}


StarsEarned = CalculateOffsetAndReturnAddress(0x1338ec6c)
BronzeGP = CalculateOffsetAndReturnAddress(0x1338ec80)
SilverGP = CalculateOffsetAndReturnAddress(0x1338f0b7)
GoldGP = CalculateOffsetAndReturnAddress(0x1338f2f0)

RioBronzeP6 = [
  0x1338ec80, 0x1338ec81, 0x1338ec82, 0x1338ec8c,
  0x1338ec8d, 0x1338ec8e, 0x1338ec98, 0x1338eca4,
  0x1338ecb0, 0x1338ecb1, 0x1338ecb2, 0x1338ecbc,
  0x1338ecc8, 0x1338ecc9, 0x1338ecca, 0x1338ecd4
]

RioSilverP6 = [
  0x1338eeac, 0x1338eead, 0x1338eeae, 0x1338eeb8,
  0x1338eeb9, 0x1338eeba, 0x1338eec4, 0x1338eed0,
  0x1338eedc, 0x1338eedd, 0x1338eede, 0x1338eee8,
  0x1338eef4, 0x1338eef5, 0x1338eef6, 0x1338ef00
]

RioGoldP6 = [
  0x1338f0d8, 0x1338f0d9, 0x1338f0da, 0x1338f0e4,
  0x1338f0e5, 0x1338f0e6, 0x1338f0f0, 0x1338f0fc,
  0x1338f108, 0x1338f109, 0x1338f10a, 0x1338f114,
  0x1338f120, 0x1338f121, 0x1338f122, 0x1338f12c
]

CairoBronzeP6 = [
  0x1338ecec, 0x1338eced, 0x1338ecee, 0x1338ecf8,
  0x1338ecf9, 0x1338ecfa, 0x1338ed04, 0x1338ed10,
  0x1338ed1c, 0x1338ed1d, 0x1338ed1e, 0x1338ed28,
  0x1338ed34, 0x1338ed35, 0x1338ed36, 0x1338ed40
]

CairoSilverP6 = [
  0x1338ef18, 0x1338ef19, 0x1338ef1a, 0x1338ef24,
  0x1338ef25, 0x1338ef26, 0x1338ef30, 0x1338ef3c,
  0x1338ef48, 0x1338ef49, 0x1338ef4a, 0x1338ef54,
  0x1338ef60, 0x1338ef61, 0x1338ef62, 0x1338ef6c
]

CairoGoldP6 = [
  0x1338f144, 0x1338f145, 0x1338f146, 0x1338f150,
  0x1338f151, 0x1338f152, 0x1338f15c, 0x1338f168,
  0x1338f174, 0x1338f175, 0x1338f176, 0x1338f180,
  0x1338f18c, 0x1338f18d, 0x1338f18e, 0x1338f198
]

MadridBronzeP6 = [
  0x1338ed58, 0x1338ed59, 0x1338ed5a, 0x1338ed64,
  0x1338ed65, 0x1338ed66, 0x1338ed70, 0x1338ed7c,
  0x1338ed88, 0x1338ed89, 0x1338ed8a, 0x1338ed94,
  0x1338eda0, 0x1338eda1, 0x1338eda2, 0x1338edac
]

MadridSilverP6 = [
  0x1338ef84, 0x1338ef85, 0x1338ef86, 0x1338ef91,
  0x1338ef92, 0x13393223, 0x1338ef9c, 0x1338efa8,
  0x1338efb4, 0x1338efb5, 0x1338efb6, 0x1338efc0,
  0x1338efcc, 0x1338efcd, 0x1338efce, 0x1338efd8
]

MadridGoldP6 = [
  0x1338f1b0, 0x1338f1b1, 0x1338f1b2, 0x1338f1bc,
  0x1338f1bd, 0x1338f1be, 0x1338f1c8, 0x1338f1d4,
  0x1338f1e0, 0x1338f1e1, 0x1338f1e2, 0x1338f1ec,
  0x1338f1f8, 0x1338f1f9, 0x1338f1fa, 0x1338f204
]

SingaporeBronzeP6 = [
  0x1338edc4, 0x1338edc5, 0x1338edc6, 0x1338edd0,
  0x1338edd1, 0x1338edd2, 0x1338eddc, 0x1338ede8,
  0x1338edf4, 0x1338edf5, 0x1338edf6, 0x1338ee00,
  0x1338ee0c, 0x1338ee0d, 0x1338ee0e, 0x1338ee18
]

SingaporeSilverP6 = [
  0x1338eff0, 0x1338eff1, 0x1338eff2, 0x1338effc,
  0x1338effd, 0x1338effe, 0x1338f008, 0x1338f014,
  0x1338f020, 0x1338f021, 0x1338f022, 0x1338f02c,
  0x1338f038, 0x1338f039, 0x1338f03a, 0x1338f044
]

SingaporeGoldP6 = [
  0x1338f21c, 0x1338f21d, 0x1338f21e, 0x1338f228,
  0x1338f229, 0x1338f22a, 0x1338f234, 0x1338f240,
  0x1338f24c, 0x1338f24d, 0x1338f24e, 0x1338f258,
  0x1338f264, 0x1338f265, 0x1338f266, 0x1338f270
]

DubaiBronzeP6 = [
  0x1338ee30, 0x1338ee31, 0x1338ee32, 0x1338ee3c,
  0x1338ee3d, 0x1338ee3e, 0x1338ee48, 0x1338ee54,
  0x1338ee60, 0x1338ee61, 0x1338ee62, 0x1338ee6c,
  0x1338ee78, 0x1338ee79, 0x1338ee7a, 0x1338ee84
]

DubaiSilverP6 = [
  0x1338f05c, 0x1338f05d, 0x1338f05e, 0x1338f068,
  0x1338f069, 0x1338f06a, 0x1338f074, 0x1338f080,
  0x1338f08c, 0x1338f08d, 0x1338f08e, 0x1338f098,
  0x1338f0a4, 0x1338f0a5, 0x1338f0a6, 0x1338f0b0
]

DubaiGoldP6 = [
  0x1338f288, 0x1338f289, 0x1338f28a, 0x1338f294,
  0x1338f295, 0x1338f296, 0x1338f2a0, 0x1338f2ac,
  0x1338f2b8, 0x1338f2b9, 0x1338f2ba, 0x1338f2c4,
  0x1338f2d0, 0x1338f2d1, 0x1338f2d2, 0x1338f2dc
]

function StarsUnlocked(achTitle, placeName, cupName, starsAmount){
  achievement(
    title = achTitle,
    description = "Earn a total of " + starsAmount + " or more stars to unlock " + placeName + " in the " + cupName + " Cup",
    points = 5,
    trigger = (
      any_of(StarsEarned, addr => 
        CurrentProfile() == addr &&
        dword_be(StarsEarned[addr]) >= starsAmount &&
        prev(dword_be(StarsEarned[addr])) >= starsAmount - 5 &&
        prev(dword_be(StarsEarned[addr])) < starsAmount
      )
    )
  )
}

function GPWon(achTitle, type, cupName, gpDict){
  achievement(
    title = achTitle,
    description = "Win the Grand Prix in the " + cupName + " Cup",
    points = 5,
    type = type,
    trigger = (
      any_of(gpDict, addr => 
        CurrentProfile() == addr &&
        dword_be(gpDict[addr]) == 1 &&
        prev(dword_be(gpDict[addr])) != 1
      )
    )
  )
}

StarsUnlocked("Unlocking Egypt", "Cairo", "Bronze", 20)
StarsUnlocked("Over to Spain", "Madrid", "Bronze", 40)
StarsUnlocked("Trip to Singapore", "Singapore", "Bronze", 60)
StarsUnlocked("Driving in Dubai", "Dubai", "Bronze", 80)
GPWon("The Bronze Age Winner", "Progression", "Bronze", BronzeGP)

StarsUnlocked("Racing in Rio", "Rio De Janeiro", "Silver", 100)
StarsUnlocked("Race Like An Egyptian", "Cairo", "Silver", 120)
StarsUnlocked("Racing with the Bulls", "Madrid", "Silver", 140)
StarsUnlocked("Marina Bay Drifter", "Singapore", "Silver", 160)
StarsUnlocked("Dubai Racer", "Dubai", "Silver", 180)
GPWon("Silver Speedster", "Progression", "Silver", SilverGP)

StarsUnlocked("Ripping up Rio", "Rio De Janeiro", "Gold", 200)
StarsUnlocked("Cairo Carnage", "Cairo", "Gold", 220)
StarsUnlocked("Madrid Mischief", "Madrid", "Gold", 140)
StarsUnlocked("Singapore Speedster", "Singapore", "Gold", 160)
StarsUnlocked("Dubai Drifter", "Dubai", "Gold", 180)
GPWon("Golden Racer", "Progression", "Gold", GoldGP)

function AllStarsEarned(achTitle, locName, cupName, raceDict){
  achievement(
    title = achTitle,
    description = "Earn the maximum amount of stars on every event in " + locName + " in the " + cupName + " Cup",
    points = 10,
    // confusing maths stuff lol
    trigger = (
      any_of(range(0, 5), p_id =>
        CurrentProfile() == p_id && 
        sum_of(raceDict, addr => 
          byte(addr - ((p_id - 5) * OFFSET))
        ) == 16 &&
        sum_of(raceDict, addr => 
          prev(byte(addr - ((p_id -5) * OFFSET)))
        ) > 16
      )
    )
  )
}

AllStarsEarned("Rio Ruler - Bronze", "Rio De Janeiro", "Bronze", RioBronzeP6)
AllStarsEarned("Cairo Champion - Bronze", "Cairo", "Bronze", CairoBronzeP6)
AllStarsEarned("Madrid Master - Bronze", "Madrid", "Bronze", MadridBronzeP6)
AllStarsEarned("Singapore Superstar - Bronze", "Singapore", "Bronze", SingaporeBronzeP6)
AllStarsEarned("Dubai Dominator - Bronze", "Dubai", "Bronze", DubaiBronzeP6)

AllStarsEarned("Rio Ruler - Silver", "Rio De Janeiro", "Silver", RioSilverP6)
AllStarsEarned("Cairo Champion - Silver", "Cairo", "Silver", CairoSilverP6)
AllStarsEarned("Madrid Master - Silver", "Madrid", "Silver", MadridSilverP6)
AllStarsEarned("Singapore Superstar - Silver", "Singapore", "Silver", SingaporeSilverP6)
AllStarsEarned("Dubai Dominator - Silver", "Dubai", "Silver", DubaiSilverP6)

AllStarsEarned("Rio Ruler - Gold", "Rio De Janeiro", "Gold", RioGoldP6)
AllStarsEarned("Cairo Champion - Gold", "Cairo", "Gold", CairoGoldP6)
AllStarsEarned("Madrid Master - Gold", "Madrid", "Gold", MadridGoldP6)
AllStarsEarned("Singapore Superstar - Gold", "Singapore", "Gold", SingaporeGoldP6)
AllStarsEarned("Dubai Dominator - Gold", "Dubai", "Gold", DubaiGoldP6)

CircuitRaces = {
  0: ["Bronze", "Rio De Janeiro", 0x00, 0x00, 0x00],
  1: ["Bronze", "Rio De Janeiro", 0x00, 0x00, 0x06],
  2: ["Bronze", "Cairo", 0x00, 0x01, 0x00],
  3: ["Bronze", "Cairo", 0x00, 0x01, 0x04],
  4: ["Bronze", "Madrid", 0x00, 0x02, 0x00],
  5: ["Bronze", "Madrid", 0x00, 0x02, 0x06],
  6: ["Bronze", "Singapore", 0x00, 0x03, 0x00],
  7: ["Bronze", "Singapore", 0x00, 0x03, 0x04],
  8: ["Bronze", "Dubai", 0x00, 0x04, 0x00],
  9: ["Bronze", "Dubai", 0x00, 0x04, 0x06],

  10: ["Silver", "Rio De Janeiro", 0x01, 0x00, 0x00],
  11: ["Silver", "Rio De Janeiro", 0x01, 0x00, 0x06],
  12: ["Silver", "Cairo", 0x01, 0x01, 0x00],
  13: ["Silver", "Cairo", 0x01, 0x01, 0x04],
  14: ["Silver", "Madrid", 0x01, 0x02, 0x00],
  15: ["Silver", "Madrid", 0x01, 0x02, 0x06],
  16: ["Silver", "Singapore", 0x01, 0x03, 0x00],
  17: ["Silver", "Singapore", 0x01, 0x03, 0x04],
  18: ["Silver", "Dubai", 0x01, 0x04, 0x00],
  19: ["Silver", "Dubai", 0x01, 0x04, 0x06],

  20: ["Gold", "Rio De Janeiro", 0x02, 0x00, 0x00],
  21: ["Gold", "Rio De Janeiro", 0x02, 0x00, 0x06],
  22: ["Gold", "Cairo", 0x02, 0x01, 0x00],
  23: ["Gold", "Cairo", 0x02, 0x01, 0x04],
  24: ["Gold", "Madrid", 0x02, 0x02, 0x00],
  25: ["Gold", "Madrid", 0x02, 0x02, 0x06],
  26: ["Gold", "Singapore", 0x02, 0x03, 0x00],
  27: ["Gold", "Singapore", 0x02, 0x03, 0x04],
  28: ["Gold", "Dubai", 0x02, 0x04, 0x00],
  29: ["Gold", "Dubai", 0x02, 0x04, 0x06]
}

function CircuitRaceLeaderboard(cup, location, cupId, locId, raceId){
  leaderboard(
    title = cup + " - " + location + " - " + "Circuit - Race Timer",
    description = "Win the race in the quickest time",
    start = (
      IsInGame() &&
      ReliableRaceTimer() == 0.0 &&
      SelectedCup() == cupId &&
      SelectedArea() == locId &&
      SelectedEvent() == raceId
    ),
    cancel = (
      !IsInGame()
    ),
    submit = (
      dword_be(0x00c94610) == 0x03 &&
      prev(dword_be(0x00c94610)) == 0x00
    ),
    value = (
      ReliableRaceTimer()
    ),
    format = "SECS",
    lower_is_better = true
  )
}

function SkillScoreLeaderboard(cup, location, cupId, locId, raceId, endDesc){
  leaderboard(
    title = cup + " - " + location + " - " + endDesc,
    description = "Earn the highest skill score",
    start = (
      IsInGame() &&
      ReliableRaceTimer() == 0.0 &&
      SelectedCup() == cupId &&
      SelectedArea() == locId &&
      SelectedEvent() == raceId
    ),
    cancel = (
      !IsInGame()
    ),
    submit = (
      dword_be(0x00c94610) == 0x03 &&
      prev(dword_be(0x00c94610)) == 0x00
    ),
    value = (
      CurrentScore()
    )
  )
}

for race in CircuitRaces{
  CircuitRaceLeaderboard(CircuitRaces[race][0], CircuitRaces[race][1], CircuitRaces[race][2], CircuitRaces[race][3], CircuitRaces[race][4])
}

for race in CircuitRaces{
  SkillScoreLeaderboard(CircuitRaces[race][0], CircuitRaces[race][1], CircuitRaces[race][2], CircuitRaces[race][3], CircuitRaces[race][4], "Circuit - Skill Score")
}