// Split/Second
// #ID = 18474

// this is the video that plays in the option menu
// only way I could figure out how to prevent save unlocks due to how the memory goes in game
// unlocks happen outside of races
Generic3Ascii = 0x656e6547

function CheatAndLoadProtection() => dword(0x00ab74d0) != 0xffffffff && dword(0x01fbf89e) != Generic3Ascii

Episode1RaceIds = [
  0x00c73390,
  0x00c73430,
  0x00c734d0,
  0x00c73570,
  0x00c73610,
  0x00c736f8
]

Episode2RaceIds = [
  0x00c737a0,
  0x00c73848,
  0x00c738f0,
  0x00c73990,
  0x00c73a30,
  0x00c73b18
]

Episode3RaceIds = [
  0x00c73bc0,
  0x00c73c78,
  0x00c72fe8,
  0x00c73060,
  0x00c73f08,
  0x00c73fe0
]

Episode4RaceIds = [
  0x00c74088,
  0x00c74128,
  0x00c741c8,
  0x00c74268,
  0x00c74308,
  0x00c743f8
]

Episode5RaceIds = [
  0x00c73da8,
  0x00c744a0,
  0x00c74548,
  0x00c745e8,
  0x00c74688,
  0x00c74728
]

Episode6RaceIds = [
  0x00c73e30,
  0x00c74a38,
  0x00c74ab0,
  0x00c74b48,
  0x00c74be8,
  0x00c74cd0
]

Episode7RaceIds = [
  0x00c74d78,
  0x00c74e18,
  0x00c74eb8,
  0x00c74f58,
  0x00c74ff8,
  0x00c750e0
]

Episode8RaceIds = [
  0x00c748d0,
  0x00c75180,
  0x00c75220,
  0x00c752c0,
  0x00c73d18,
  0x00c75360
]

Episode9RaceIds = [
  0x00c74970,
  0x00c756f0,
  0x00c75768,
  0x00c75808,
  0x00c758a8,
  0x00c75990
]

Episode10RaceIds = [
  0x00c75a38,
  0x00c75ad8,
  0x00c75b80,
  0x00c75c20,
  0x00c75cc0,
  0x00c75da8
]

Episode11RaceIds = [
  0x00c747c8,
  0x00c754d0,
  0x00c75560,
  0x00c75648,
  0x00c75e48,
  0x00c75ee8
]

Episode12RaceIds = [
  0x00c75561,
  0x00c76390,
  0x00c76430,
  0x00c764d0,
  0x00c76570,
  0x00c76658
]

BonusRaceIds = [
  0x00c735d8,
  0x00c739f8,
  0x00c73ed0,
  0x00c742d0,
  0x00c746f0,
  0x00c74bb0,
  0x00c74fc0,
  0x00c73ce0,
  0x00c756f0,
  0x00c75c88,
  0x00c75528,
  0x00c76538
]

CarUnlockIds = {
  0x00c76d70: "Corbetti Nero GT 400",
  0x00c76e28: "Hanzo Indus V8R",
  0x00c76ee0: "Ryback Mohawk",
  0x00c76f98: "Cobretti Irdium",
  0x00c77060: "Rayback Bandit",
  0x00c77138: "Corbetti GT RS",
  0x00c77218: "Corbetti GT500",
  0x00c772f8: "Cobretti Vortex",
  0x00c75f50: "Cobretti Cascade",
  0x00c76a90: "Hanzo Bayonet R",
  0x00c76b60: "Hanzo GT",
  0x00c76c40: "Ryback Thunder",
  0x00c77848: "Cobretti Pursuit",
  0x00c77900: "Cobretti Slipstream",
  0x00c779b8: "Ryback Coyote",
  0x00c77a98: "Cobretti 530 GTS",
  0x00c77b78: "Hanzo FX350",
  0x00c77c58: "Ryback Firestorm",
  0x00c77d38: "Ryback Titan",
  0x00c77e18: "Ryback Cyclone RS",
  0x00c77ef8: "Elite 440 Special",
  0x00c77fd8: "Elite S510",
  0x00c780b8: "Elite Goliath",
  0x00c78198: "Elite GT12"
}

// ------------------------ PROGRESSION ------------------------
function CompleteEliteRace(achTitle, episodeName, points, type, raceId) {
  achievement(
    title = achTitle,
    description = "Place 3rd or higher in the elite race on episode " + "\"" + episodeName + "\"",
    points = points,
    type = type,
    trigger = (
      CheatAndLoadProtection() &&
      (
        prev(dword(raceId)) < 0x1e) && // less than 30 as 3rd place gets 30
      (
        dword(raceId) == 0x32 ||
        (dword(raceId) >= 0x1e && dword(raceId) <= 0x32)
      )
    )
  )
}

CompleteEliteRace("Not a Rigged Race!", "Rigged to Blow", 5, "Progression", 0x00c736f8)
CompleteEliteRace("Splashing Down the Competition", "Splashdown", 5, "Progression", 0x00c73b18)
CompleteEliteRace("Big Race Boom!", "Big Rig Boom!", 5, "Progression", 0x00c73fe0)
CompleteEliteRace("Leaving the Competition in the Sunset", "Sunset", 5, "Progression", 0x00c743f8)
CompleteEliteRace("Skidding Over the Racers", "Hit the Skids", 5, "Progression", 0x00c74728)
CompleteEliteRace("Passing the Opponents", "Midway Pass", 5, "Progression", 0x00c74cd0)
CompleteEliteRace("Breaking Cars", "Threshold Break", 5, "Progression", 0x00c750e0)
CompleteEliteRace("Cleaning Up the Competition", "Cleaning Up", 5, "Progression", 0x00c75360)
CompleteEliteRace("Burning Rubber", "Scorched Rubber", 5, "Progression", 0x00c75990)
CompleteEliteRace("Boneyard Smash", "Boneyard Rush", 5, "Progression", 0x00c75da8)
CompleteEliteRace("One Elite Race to Go!", "One Last Push", 5, "Progression", 0x00c75ee8)
CompleteEliteRace("All Competitors Blown Up", "Out With a Bang", 10, "Win_Condition", 0x00c76658)

// ------------------------ bonus races unlocked ------------------------
function UnlockBonusRace(achTitle, episodeName, unlockId) {
  achievement(
    title = achTitle,
    description = "Unlock the bonus race on episode " + "\"" + episodeName + "\"",
    points = 4,
    trigger = (
      CheatAndLoadProtection() &&
      dword(unlockId) == 0x01 &&
      prev(dword(unlockId)) == 0x00
    )
  )
}

UnlockBonusRace("Rigged to Blow Bonus", "Rigged to Blow", BonusRaceIds[0])
UnlockBonusRace("Splashdown Bonus", "Splashdown", BonusRaceIds[1])
UnlockBonusRace("Big Rig Bonus!", "Big Rig Boom!", BonusRaceIds[2])
UnlockBonusRace("A Bonus Sunset Race", "Sunset", BonusRaceIds[3])
UnlockBonusRace("Hit the Bonus", "Hit the Skids", BonusRaceIds[4])
UnlockBonusRace("Midway Bonus", "Midway Pass", BonusRaceIds[5])
UnlockBonusRace("Bonus Threshold Reached", "Threshold Break", BonusRaceIds[6])
UnlockBonusRace("Cleaning Up Bonus Unlocks", "Cleaning Up", BonusRaceIds[7])
UnlockBonusRace("Burning Rubber Bonus", "Scorched Rubber", BonusRaceIds[8])
UnlockBonusRace("Boneyard Bonus", "Boneyard Rush", BonusRaceIds[9])
UnlockBonusRace("One Last Bonus Push", "One Last Push", BonusRaceIds[10])
UnlockBonusRace("Out With a Bonus Bang", "Out With a Bang", BonusRaceIds[11])

// ------------------------ 100% races ------------------------
function Tally(data) {
  total = 0
  for item in data{
      total = total + byte(item) / 0x32
  }
  
  return total
}

function PrevTally(data) {
  total = 0
  for item in data{
    total = total + prev(byte(item)) / 0x32
  }
  
  return total
}

function AllRaces1st(achTitle, episodeName, raceIds) {
  achievement(
      title = achTitle,
      description = "Get 50/50 credits across every race in episode " + "\"" + episodeName + "\"",
      points = 10,
      trigger = (
        CheatAndLoadProtection() &&
        Tally(raceIds) == 0x06 &&
        PrevTally(raceIds) == 0x05
      )
  )
}

AllRaces1st("Rigged to Blow Race Master", "Rigged to Blow", Episode1RaceIds)
AllRaces1st("Splashdown Race Master", "Splashdown", Episode2RaceIds)
AllRaces1st("Big Rig Boom! Race Master", "Big Rig Boom!", Episode3RaceIds)
AllRaces1st("Sunset Race Master", "Sunset", Episode4RaceIds)
AllRaces1st("Hit the Skids Race Master", "Hit the Skids", Episode5RaceIds)
AllRaces1st("Midway Pass Race Master", "Midway Pass", Episode6RaceIds)
AllRaces1st("Threshold Break Race Master", "Threshold Break", Episode7RaceIds)
AllRaces1st("Cleaning Up Race Master", "Cleaning Up", Episode8RaceIds)
AllRaces1st("Scorched Rubber Race Master", "Scorched Rubber", Episode9RaceIds)
AllRaces1st("Boneyard Rush Race Master", "Boneyard Rush", Episode10RaceIds)
AllRaces1st("One Last Push Race Master", "One Last Push", Episode11RaceIds)
AllRaces1st("Out With a Bang Race Master", "Out With a Bang", Episode12RaceIds)

// ------------------------ Car Unlocks ------------------------
function UnlockCar(carName, unlockId) {
  achievement(
    title = carName + " Unlocked",
    description = "Unlock the " + carName,
    points = 4,
    trigger = (
      CheatAndLoadProtection() && 
      dword(unlockId) == 0x01 &&
      prev(dword(unlockId)) == 0x00
    )
  )
}

for car in CarUnlockIds{
  UnlockCar(CarUnlockIds[car], car)
}

// ------------------------ Awards ------------------------
function UnlockAward(awardName, points, awardAddressId) {
  achievement(
    title = awardName,
    description = "Unlock the award " + "\"" + awardName + "\"",
    points = points,
    trigger = (
      CheatAndLoadProtection() &&
      dword(awardAddressId) == 0x01 &&
      prev(dword(awardAddressId)) == 0x00
    )
  )
}

UnlockAward("Untouchable", 5, 0x00c7aa88)
UnlockAward("Split/Second", 5, 0x00c78410)
UnlockAward("Route Explorer", 5, 0x00c79a88)
UnlockAward("Bully", 10, 0x00c79ad8)
UnlockAward("Cheapskate", 5, 0x00c79b28)
UnlockAward("Zero to Hero", 10, 0x00c79be8)
UnlockAward("Frequent Flyer", 5, 0x00c79c48)
UnlockAward("Swept Away", 5, 0x00c79c48)
UnlockAward("The Pain Train", 5, 0x00c79d08)
UnlockAward("Shipwrecked", 5, 0x00c79d68)
UnlockAward("High Pipe", 5, 0x00c79dc8)
UnlockAward("Beat the Team", 10, 0x00c799e8)
UnlockAward("Beat the Team II: The Revenge", 10, 0x00c7ac88)
UnlockAward("Convoy", 10, 0x00c7ad48)
UnlockAward("Fearless", 5, 0x00c7ada8)
UnlockAward("Once, Twice, Three Time Evasive", 10, 0x00c7aec8)
UnlockAward("Triple Trouble", 5, 0x00c7af88)
UnlockAward("Giant Killer", 5, 0x00c7b7f8)
UnlockAward("Action Scene", 10, 0x00c7aad8)
UnlockAward("Back From the Brink", 10, 0x00c7abd8)

// ------------------------ RP ------------------------
function InGame() => byte(0x0098eff8) == 0x01
function Track() => dword(0x00c711d8)
function Mode() => dword(0x00c712f8)
function Car() => dword(0x00c71278)

tracks = {
    0x08f08d8b: "Airport Terminal",
    0x08f08ed5: "Dry Docks",
    0x08f08f7f: "Ferry Wharf",
    0x08f09029: "Port Bridge",
    0x08f090c8: "The Docks",
    0x08f09172: "Downtown Central",
    0x08f0921e: "Expressway",
    0x08f092ce: "Construction Site",
    0x08f0937e: "Power Plant",
    0x08f09432: "Storm Drain",
    0x08f094e2: "Canyon",
    0x08f09594: "Aircraft Graveyard",
    0x08f09642: "Downtown Circuit",
    0x08f096fe: "Desert Run",
    0x08f097bc: "Stormdrain Speedway",
    0x08f09872: "Warehouse Strip"
}

cars = {
    0x98b881b2: "Ryback Brawler",
    0x8c60bc74: "Cobretti 455 GT",
    0x3e0b33b0: "Ryback Tornado",
    0x806a18e4: "Cobrretti Nero GT400",
    0x9d36fdea: "Hanzo Indus V8R",
    0xb4251364: "Ryback Mohawk",
    0xbb3bc102: "Cobretti Iridium",
    0x6ad62190: "Ryback Bandit",
    0xb6d2e3d0: "Cobretti GT RS",
    0x68d41c6b: "Cobretti GT500",
    0x85c0c0a2: "Cobretti Vortex",
    0xfd647756: "Cobretti Cascade",
    0xecd192e6: "Hanzo Bayonet R",
    0xd234d011: "Hanzo GT",
    0x50296d91: "Ryback Thunder",
    0x5e09c2b2: "Cobretti Pursuit",
    0xb6112424: "Cobretti Slipstream",
    0xda1f374b: "Ryback Coyote",
    0xe1f9c24e: "Cobretti 530 GTS",
    0xf630622f: "Hanzo FX350",
    0x0ae69731: "Ryback Firestorm",
    0x49f5f760: "Ryback Titan",
    0x2c3eed6b: "Ryback Cyclone RS",
    0xc87b6251: "Elite 440 Special",
    0x75c31576: "Elite S510",
    0x882a6120: "Elite Goliath",
    0xde2a1c6c: "Elite GT12"
}

eventMode = {
    0x08f078e0: "Race",
    0x08f0791e: "Detonator",
    0x08f07961: "Elimination",
    0x08f079b0: "Air Strike",
    0x08f079ff: "Air Revenge",
    0x08f07a47: "Survival"
}




rich_presence_conditional_display(InGame(), "Browsing the menus")
rich_presence_display("Racing on {0} in {1} mode with the {2}",
    rich_presence_lookup("Track", Track(), tracks),
    rich_presence_lookup("Mode", Mode(), eventMode),
    rich_presence_lookup("Car", Car(), cars)
)