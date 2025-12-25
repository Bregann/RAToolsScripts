// Need for Speed: Nitro
// #ID = 34593

OFFSET = 0xD50

ScorePointer = dword_be(0x007726f4) & 0x1fffffff

function CurrentProfile() => dword_be(0x01578d80)
function IsInGame() => dword_be(0x007726f4) != 0x00000000
function ReliableRaceTimer() => float_be(0x1337cca0)
function CurrentCar() => dword_be(0x00888160)
function RaceCompleted() => dword_be(0x00676920) == 0x01 && prev(dword_be(0x00676920)) == 0x00

function SelectedCup() => byte(0x0157c1d8)
function SelectedArea() => byte(0x0157c1d9)
function SelectedEvent() => byte(0x0157c1da)
function CurrentScore() => dword_be(ScorePointer + 0x38)
function DriftScore() => dword_be(ScorePointer + 0x3c)

// Dictionaries
function CalculateOffsetAndReturnAddress(baseAddr){
  dict = {}

  for i in range(0, 5) {
    dict[5 - i] = baseAddr + (i * OFFSET)
  }

  return dict
}

StarsEarned = CalculateOffsetAndReturnAddress(0x1338ec6c)
BronzeGP = CalculateOffsetAndReturnAddress(0x1338ee98)
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
  0x1338ef92, 0x1338ef93, 0x1338ef9c, 0x1338efa8,
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

AllCars = {
  0xffffffff: "Not in game",
  0x00: "Dodge Charger R/T",
  0x04: "Ford GT",
  0x05: "Nissan GT-R",
  0x06: "Hummer H2",
  0x09: "VW Beetle",
  0x0b: "Chevrolet Camaro SS",
  0x0c: "Ford Shelby GT500",
  0x0d: "Audi TT RS Coupé",
  0x0e: "Audi R8",
  0x0f: "Chevrolet Corvette Sting Ray",
  0x10: "Chevrolet Corvette ZR1",
  0x11: "Nissan 370Z",
  0x12: "VW Type 2",
  0x13: "Nissan Cube",
  0x14: "Lamborghini Reventón",
  0x15: "Porsche 911 GT3 RS",
  0x16: "Subaru Impreza WRX STI",
  0x17: "Shelby G.T. 500",
  0x18: "Lamborghini Gallardo",
  0x19: "Dodge Challenger",
  0x1b: "Pagani Zonda R",
  0x1c: "Ford Escort RS Cosworth",
  0x1d: "Mitsubishi Lancer Evolution",
  0x1e: "Nissan Skyline GT-R",
  0x1f: "Porsche Cayman S",
  0x20: "Tesla Roaster",
  0x21: "Porsche Cayenne Turbo S",
  0x24: "Renault 4L",
  0x25: "Toyota Corolla GT-S",
  0x26: "Ford Explorer Sport Trac Adrenalin"
}

ClassACars = {
    0x04: "Ford GT",
    0x0c: "Ford Shelby GT500",
    0x0d: "Audi TT RS Coupé",
    0x0e: "Audi R8",
    0x10: "Chevrolet Corvette ZR1",
    0x14: "Lamborghini Reventón",
    0x15: "Porsche 911 GT3 RS",
    0x18: "Lamborghini Gallardo",
    0x19: "Dodge Challenger",
    0x1b: "Pagani Zonda R",
    0x1e: "Nissan Skyline GT-R"
}

ClassBCars = {
  0x00: "Dodge Charger R/T",
  0x05: "Nissan GT-R",
  0x0f: "Chevrolet Corvette Sting Ray",
  0x11: "Nissan 370Z",
  0x16: "Subaru Impreza WRX STI",
  0x17: "Shelby G.T. 500",
  0x1c: "Ford Escort RS Cosworth",
  0x1d: "Mitsubishi Lancer Evolution",
  0x1f: "Porsche Cayman S",
  0x21: "Porsche Cayenne Turbo S"
}

ClassCCars = {
  0x06: "Hummer H2",
  0x09: "VW Beetle",
  0x0b: "Chevrolet Camaro SS",
  0x12: "VW Type 2",
  0x13: "Nissan Cube",
  0x20: "Tesla Roaster",
  0x24: "Renault 4L",
  0x25: "Toyota Corolla GT-S",
  0x26: "Ford Explorer Sport Trac Adrenalin"
}

// -------------------- Progression & 100% --------------------

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
        byte(gpDict[addr]) == 1 &&
        prev(byte(gpDict[addr])) != 1
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
StarsUnlocked("Race Like an Egyptian", "Cairo", "Silver", 120)
StarsUnlocked("Racing with the Bulls", "Madrid", "Silver", 140)
StarsUnlocked("Marina Bay Drifter", "Singapore", "Silver", 160)
StarsUnlocked("Dubai Racer", "Dubai", "Silver", 180)
GPWon("Silver Speedster", "Progression", "Silver", SilverGP)

StarsUnlocked("Ripping up Rio", "Rio De Janeiro", "Gold", 200)
StarsUnlocked("Cairo Carnage", "Cairo", "Gold", 220)
StarsUnlocked("Madrid Mischief", "Madrid", "Gold", 140)
StarsUnlocked("Singapore Speedster", "Singapore", "Gold", 160)
StarsUnlocked("Dubai Drifter", "Dubai", "Gold", 180)
GPWon("Golden Grand Prix Winner", "Win_Condition", "Gold", GoldGP)

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

BronzeCircuitRaces = {
  0: ["Bronze", "Rio De Janeiro", 0x00, 0x00, 0x00, 1],
  1: ["Bronze", "Rio De Janeiro", 0x00, 0x00, 0x06, 2],
  2: ["Bronze", "Cairo", 0x00, 0x01, 0x00, 1],
  3: ["Bronze", "Cairo", 0x00, 0x01, 0x04, 2],
  4: ["Bronze", "Madrid", 0x00, 0x02, 0x00, 1],
  5: ["Bronze", "Madrid", 0x00, 0x02, 0x06, 2],
  6: ["Bronze", "Singapore", 0x00, 0x03, 0x00, 1],
  7: ["Bronze", "Singapore", 0x00, 0x03, 0x04, 2],
  8: ["Bronze", "Dubai", 0x00, 0x04, 0x00, 1],
  9: ["Bronze", "Dubai", 0x00, 0x04, 0x06, 2]
}

SilverCircuitRaces = {
  10: ["Silver", "Rio De Janeiro", 0x01, 0x00, 0x00, 1],
  11: ["Silver", "Rio De Janeiro", 0x01, 0x00, 0x06, 2],
  12: ["Silver", "Cairo", 0x01, 0x01, 0x00, 1],
  13: ["Silver", "Cairo", 0x01, 0x01, 0x04, 2],
  14: ["Silver", "Madrid", 0x01, 0x02, 0x00, 1],
  15: ["Silver", "Madrid", 0x01, 0x02, 0x06, 2],
  16: ["Silver", "Singapore", 0x01, 0x03, 0x00, 1],
  17: ["Silver", "Singapore", 0x01, 0x03, 0x04, 2],
  18: ["Silver", "Dubai", 0x01, 0x04, 0x00, 1],
  19: ["Silver", "Dubai", 0x01, 0x04, 0x06, 2]
}

GoldCircuitRaces = {
  20: ["Gold", "Rio De Janeiro", 0x02, 0x00, 0x00, 1],
  21: ["Gold", "Rio De Janeiro", 0x02, 0x00, 0x06, 2],
  22: ["Gold", "Cairo", 0x02, 0x01, 0x00, 1],
  23: ["Gold", "Cairo", 0x02, 0x01, 0x04, 2],
  24: ["Gold", "Madrid", 0x02, 0x02, 0x00, 1],
  25: ["Gold", "Madrid", 0x02, 0x02, 0x06, 2],
  26: ["Gold", "Singapore", 0x02, 0x03, 0x00, 1],
  27: ["Gold", "Singapore", 0x02, 0x03, 0x04, 2],
  28: ["Gold", "Dubai", 0x02, 0x04, 0x00, 1],
  29: ["Gold", "Dubai", 0x02, 0x04, 0x06, 2]
}

CircuitRaces = {
  0: ["Bronze", "Rio De Janeiro", 0x00, 0x00, 0x00, 1],
  1: ["Bronze", "Rio De Janeiro", 0x00, 0x00, 0x06, 2],
  2: ["Bronze", "Cairo", 0x00, 0x01, 0x00, 1],
  3: ["Bronze", "Cairo", 0x00, 0x01, 0x04, 2],
  4: ["Bronze", "Madrid", 0x00, 0x02, 0x00, 1],
  5: ["Bronze", "Madrid", 0x00, 0x02, 0x06, 2],
  6: ["Bronze", "Singapore", 0x00, 0x03, 0x00, 1],
  7: ["Bronze", "Singapore", 0x00, 0x03, 0x04, 2],
  8: ["Bronze", "Dubai", 0x00, 0x04, 0x00, 1],
  9: ["Bronze", "Dubai", 0x00, 0x04, 0x06, 2],

  10: ["Silver", "Rio De Janeiro", 0x01, 0x00, 0x00, 1],
  11: ["Silver", "Rio De Janeiro", 0x01, 0x00, 0x06, 2],
  12: ["Silver", "Cairo", 0x01, 0x01, 0x00, 1],
  13: ["Silver", "Cairo", 0x01, 0x01, 0x04, 2],
  14: ["Silver", "Madrid", 0x01, 0x02, 0x00, 1],
  15: ["Silver", "Madrid", 0x01, 0x02, 0x06, 2],
  16: ["Silver", "Singapore", 0x01, 0x03, 0x00, 1],
  17: ["Silver", "Singapore", 0x01, 0x03, 0x04, 2],
  18: ["Silver", "Dubai", 0x01, 0x04, 0x00, 1],
  19: ["Silver", "Dubai", 0x01, 0x04, 0x06, 2],

  20: ["Gold", "Rio De Janeiro", 0x02, 0x00, 0x00, 1],
  21: ["Gold", "Rio De Janeiro", 0x02, 0x00, 0x06, 2],
  22: ["Gold", "Cairo", 0x02, 0x01, 0x00, 1],
  23: ["Gold", "Cairo", 0x02, 0x01, 0x04, 2],
  24: ["Gold", "Madrid", 0x02, 0x02, 0x00, 1],
  25: ["Gold", "Madrid", 0x02, 0x02, 0x06, 2],
  26: ["Gold", "Singapore", 0x02, 0x03, 0x00, 1],
  27: ["Gold", "Singapore", 0x02, 0x03, 0x04, 2],
  28: ["Gold", "Dubai", 0x02, 0x04, 0x00, 1],
  29: ["Gold", "Dubai", 0x02, 0x04, 0x06, 2]
}

DriftRaces = {
  0: ["Bronze", "Rio De Janeiro", 0x00, 0x00, 0x02],
  2: ["Bronze", "Cairo", 0x00, 0x01, 0x02],
  4: ["Bronze", "Madrid", 0x00, 0x02, 0x07],
  6: ["Bronze", "Singapore", 0x00, 0x03, 0x05],
  9: ["Bronze", "Dubai", 0x00, 0x04, 0x02],

  10: ["Silver", "Rio De Janeiro", 0x01, 0x00, 0x02],
  12: ["Silver", "Cairo", 0x01, 0x01, 0x02],
  14: ["Silver", "Madrid", 0x01, 0x02, 0x07],
  16: ["Silver", "Singapore", 0x01, 0x03, 0x05],
  18: ["Silver", "Dubai", 0x01, 0x04, 0x02],

  20: ["Gold", "Rio De Janeiro", 0x02, 0x00, 0x02],
  22: ["Gold", "Cairo", 0x02, 0x01, 0x02],
  24: ["Gold", "Madrid", 0x02, 0x02, 0x07],
  26: ["Gold", "Singapore", 0x02, 0x03, 0x05],
  28: ["Gold", "Dubai", 0x02, 0x04, 0x02]
}

TimeAttackRaces = {
  0: ["Bronze", "Rio De Janeiro", 0x00, 0x00, 0x07],
  2: ["Bronze", "Cairo", 0x00, 0x01, 0x05],
  4: ["Bronze", "Madrid", 0x00, 0x02, 0x02],
  6: ["Bronze", "Singapore", 0x00, 0x03, 0x02],
  9: ["Bronze", "Dubai", 0x00, 0x04, 0x07],

  10: ["Silver", "Rio De Janeiro", 0x01, 0x00, 0x07],
  12: ["Silver", "Cairo", 0x01, 0x01, 0x05],
  14: ["Silver", "Madrid", 0x01, 0x02, 0x02],
  16: ["Silver", "Singapore", 0x01, 0x03, 0x02],
  18: ["Silver", "Dubai", 0x01, 0x04, 0x07],

  20: ["Gold", "Rio De Janeiro", 0x02, 0x00, 0x07],
  22: ["Gold", "Cairo", 0x02, 0x01, 0x05],
  24: ["Gold", "Madrid", 0x02, 0x02, 0x02],
  26: ["Gold", "Singapore", 0x02, 0x03, 0x02],
  28: ["Gold", "Dubai", 0x02, 0x04, 0x07]
}

// -------------------- Challenges --------------------
PlayerGPPoints = dword_be(0x0157c1dc)
NPC1GPPoints = dword_be(0x0157c1e0)
NPC2GPPoints = dword_be(0x0157c1e4)
NPC3GPPoints = dword_be(0x0157c1e8)
NPC4GPPoints = dword_be(0x0157c1ec)
NPC5GPPoints = dword_be(0x0157c1f0)
NPC6GPPoints = dword_be(0x0157c1f4)
NPC7GPPoints = dword_be(0x0157c1f8)

TotalPoints = PlayerGPPoints + NPC1GPPoints + NPC2GPPoints + NPC3GPPoints +
NPC4GPPoints + NPC5GPPoints + NPC6GPPoints + NPC7GPPoints

achievement(
  title = "The Silver Underdog",
  description = "Win the Silver Cup Grand Prix using any C class car",
  points = 10,
  trigger = (
    IsInGame() &&
    SelectedCup() == 0x01 &&
    SelectedArea() == 0x63 &&
    TotalPoints == 170 &&
    prev(TotalPoints) < 170 &&
    PlayerGPPoints > NPC1GPPoints &&
    PlayerGPPoints > NPC2GPPoints &&
    PlayerGPPoints > NPC3GPPoints &&
    PlayerGPPoints > NPC4GPPoints &&
    PlayerGPPoints > NPC5GPPoints &&
    PlayerGPPoints > NPC6GPPoints &&
    PlayerGPPoints > NPC7GPPoints &&
    any_of(ClassCCars, car => CurrentCar() == car)
  )
)

achievement(
  title = "Golden Racer",
  description = "Win the Gold Cup Grand Prix using any B class car",
  points = 10,
  trigger = (
    IsInGame() &&
    SelectedCup() == 0x02 &&
    SelectedArea() == 0x63 &&
    TotalPoints == 170 &&
    prev(TotalPoints) < 170 &&
    PlayerGPPoints > NPC1GPPoints &&
    PlayerGPPoints > NPC2GPPoints &&
    PlayerGPPoints > NPC3GPPoints &&
    PlayerGPPoints > NPC4GPPoints &&
    PlayerGPPoints > NPC5GPPoints &&
    PlayerGPPoints > NPC6GPPoints &&
    PlayerGPPoints > NPC7GPPoints &&
    any_of(ClassBCars, car => CurrentCar() == car)
  )
)

function DriftChallenge(achTitle, pointsAmountDesc, placeName, pointsAmountNum, cupId, locId, raceId, cupName){
  achievement(
    title = achTitle,
    description = "Earn " + pointsAmountDesc + " on the Drift Challenge in " + placeName + " in the " + cupName + " Cup",
    points = 10,
    trigger = (
      IsInGame() &&
      SelectedCup() == cupId &&
      SelectedArea() == locId &&
      SelectedEvent() == raceId &&
      DriftScore() >= pointsAmountNum &&
      prev(dword_be(ScorePointer + 0x3c)) < pointsAmountNum
    )
  )
}

DriftChallenge("The Samba Slide", "15,000", "Rio De Janeiro", 15000, 1, 0, 2, "Silver")
DriftChallenge("Drifting in De-Nile", "16,500", "Cairo", 16500, 0, 1, 2, "Bronze")
DriftChallenge("Drifting in Madrid", "13,000", "Madrid", 13000, 0, 2, 7, "Bronze")
DriftChallenge("Singapore Sling", "17,000", "Singapore", 17000, 0, 3, 5, "Bronze")
DriftChallenge("Dubai Drift King", "12,000", "Dubai", 12000, 0, 3, 2, "Bronze")

function ClassChallenge(achTitle, pointsAmountDesc, pointsAmountNum, cupName, carClassName, carClassList, circuitList){
    achievement(
    title = achTitle,
    description = "Earn " + pointsAmountDesc + " skill points on any circuit race in the " + cupName + " Cup using any " + carClassName + " class car",
    points = 10,
    trigger = (
      IsInGame() &&
      CurrentScore() >= pointsAmountNum &&
      prev(dword_be(ScorePointer + 0x38)) < pointsAmountNum &&
      any_of(circuitList, cr => 
        circuitList[cr][3] == SelectedArea() &&
        circuitList[cr][4] == SelectedEvent()
      ) &&
      any_of(carClassList, car => CurrentCar() == car)
    )
  )
}

ClassChallenge("Skid Mark Specialist", "70,000", 70000, "Bronze", "C", ClassCCars, BronzeCircuitRaces)
ClassChallenge("Sideways Certified", "107,000", 107000, "Silver", "B", ClassBCars, SilverCircuitRaces)
ClassChallenge("Style Icon", "110,000", 110000, "Gold", "A", ClassACars, GoldCircuitRaces)

// -------------------- Leaderboards --------------------
function CircuitRaceLeaderboard(cup, location, cupId, locId, raceId, raceNum){
  leaderboard(
    title = cup + " Cup - " + location + " - " + "Circuit " + raceNum + " - Race Timer",
    description = "Win the race in the quickest time",
    start = (
      IsInGame() &&
      SelectedCup() == cupId &&
      SelectedArea() == locId &&
      SelectedEvent() == raceId &&
      dword_be(0x00676920) == 0x02
    ),
    cancel = (
      !IsInGame()
    ),
    submit = (
      RaceCompleted() &&
      ReliableRaceTimer() > 0.0
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
    title = cup + " Cup - " + location + " - " + endDesc,
    description = "Earn the highest skill score in the event",
    start = (
      IsInGame() &&
      SelectedCup() == cupId &&
      SelectedArea() == locId &&
      SelectedEvent() == raceId &&
      dword_be(0x00676920) == 0x02
    ),
    cancel = (
      !IsInGame()
    ),
    submit = (
      RaceCompleted() &&
      CurrentScore() > 0
    ),
    value = (
      CurrentScore()
    ),
    lower_is_better = false
  )
}

function DriftScoreLeaderboard(cup, location, cupId, locId, raceId, endDesc){
  leaderboard(
    title = cup + " Cup - " + location + " - " + endDesc,
    description = "Earn the highest drift score in the event",
    start = (
      IsInGame() &&
      SelectedCup() == cupId &&
      SelectedArea() == locId &&
      SelectedEvent() == raceId &&
      dword_be(0x00676920) == 0x02
    ),
    cancel = (
      !IsInGame()
    ),
    submit = (
      RaceCompleted() &&
      CurrentScore() > 0
    ),
    value = (
      DriftScore()
      
    ),
    lower_is_better = false
  )
}

function TimeAttackRaceLeaderboard(cup, location, cupId, locId, raceId){
  leaderboard(
    title = cup + " Cup - " + location + " - " + "Time Attack - Race Timer",
    description = "Complete the event in the quickest time",
    start = (
      IsInGame() &&
      SelectedCup() == cupId &&
      SelectedArea() == locId &&
      SelectedEvent() == raceId &&
      dword_be(0x00676920) == 0x02
    ),
    cancel = (
      !IsInGame()
    ),
    submit = (
      RaceCompleted() &&
      ReliableRaceTimer() > 0.0
    ),
    value = (
      ReliableRaceTimer()
    ),
    format = "SECS",
    lower_is_better = true
  )
}


for race in CircuitRaces{
  CircuitRaceLeaderboard(CircuitRaces[race][0], CircuitRaces[race][1], CircuitRaces[race][2], CircuitRaces[race][3], CircuitRaces[race][4], CircuitRaces[race][5])
}

for race in CircuitRaces{
  SkillScoreLeaderboard(CircuitRaces[race][0], CircuitRaces[race][1], CircuitRaces[race][2], CircuitRaces[race][3], CircuitRaces[race][4], "Circuit " + CircuitRaces[race][5] + " - Skill Score")
}

for race in DriftRaces{
  DriftScoreLeaderboard(DriftRaces[race][0], DriftRaces[race][1], DriftRaces[race][2], DriftRaces[race][3], DriftRaces[race][4], "Drift Challenge - Score")
}

for race in TimeAttackRaces{
  TimeAttackRaceLeaderboard(TimeAttackRaces[race][0], TimeAttackRaces[race][1], TimeAttackRaces[race][2], TimeAttackRaces[race][3], TimeAttackRaces[race][4])
}

// -------------------- RP --------------------
Cups = {
  0x00: "Bronze",
  0x01: "Silver",
  0x02: "Gold"
}

Location = {
  0x00: "Rio De Janeiro",
  0x01: "Cairo",
  0x02: "Madrid",
  0x03: "Singapore",
  0x04: "Dubai",
  0x63: "Grand Prix"
}


rich_presence_conditional_display(!IsInGame() && CurrentProfile() == 0x00, "Preparing for a race! [Profile 1] [⭐ {0}] [💰 {1}]",
  rich_presence_value("Stars", dword_be(0x13392efc)),
  rich_presence_value("Money", dword_be(0x13392f00))
)
rich_presence_conditional_display(!IsInGame() && CurrentProfile() == 0x01, "Preparing for a race! [Profile 2] [⭐ {0}] [💰 {1}]",
  rich_presence_value("Stars", dword_be(0x133921ac)),
  rich_presence_value("Money", dword_be(0x133921b0))
)
rich_presence_conditional_display(!IsInGame() && CurrentProfile() == 0x02, "Preparing for a race! [Profile 3] [⭐ {0}] [💰 {1}]",
  rich_presence_value("Stars", dword_be(0x1339145c)),
  rich_presence_value("Money", dword_be(0x13391460))
)
rich_presence_conditional_display(!IsInGame() && CurrentProfile() == 0x03, "Preparing for a race! [Profile 4] [⭐ {0}] [💰 {1}]",
  rich_presence_value("Stars", dword_be(0x1339070c)),
  rich_presence_value("Money", dword_be(0x13390710))
)
rich_presence_conditional_display(!IsInGame() && CurrentProfile() == 0x04, "Preparing for a race! [Profile 5] [⭐ {0}] [💰 {1}]",
  rich_presence_value("Stars", dword_be(0x1338f9bc)),
  rich_presence_value("Money", dword_be(0x1338f9c0))
)
rich_presence_conditional_display(!IsInGame() && CurrentProfile() == 0x05, "Preparing for a race! [Profile 6] [⭐ {0}] [💰 {1}]",
  rich_presence_value("Stars", dword_be(0x1338ec6c)),
  rich_presence_value("Money", dword_be(0x1338ec70))
)
rich_presence_conditional_display(IsInGame(), "Racing in {0} in the {1} Cup driving the {2} [Skill Score: {3}]",
  rich_presence_lookup("Location", SelectedArea(), Location),
  rich_presence_lookup("Cup", SelectedCup(), Cups),
  rich_presence_lookup("Car", CurrentCar(), AllCars),
  rich_presence_value("SkillScore", CurrentScore())
)
rich_presence_display("Playing Need for Speed: Nitro")