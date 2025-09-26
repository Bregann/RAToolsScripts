// Split/Second
// #ID = 18474

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
  0x00c75360 //missing 1
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
  0x01, // "Cleaning Up",
  0x00c756f0,
  0x02, // "Boneyard Rush",
  0x00c75528,
  0x00c76538
]

CarUnlockIds = {
  0xc76a90: "Hanzo Bayonet R",
  0xc76c40: "Ryback Thunder",
  0xc76d70: "Corbetti Nero GT 400",
  0xc76e28: "Hanzo Indus V8R",
  0xc76ee0: "Ryback Mohawk",
  0xc76f98: "Cobretti Irdium",
  0xc77060: "Rayback Bandit",
  0xc77138: "Corbetti GT RS",
  0xc77218: "Corbetti GT500",
  0xc772f8: "Cobretti Vortex",
  0xc77848: "Cobretti Pursuit",
  0xc77900: "Cobretti Slipstream",
  0xc779b8: "Ryback Coyote",
  0xc77a98: "Cobretti 530 GTS",
  0xc77b78: "Hanzo FX350",
  0xc77d38: "Ryback Titan",
  0xc77e18: "Ryback Cyclone RS",
  0xc77ef8: "Elite 440 Special",
  0xc77fd8: "Elite S510"
}

// ------------------------ PROGRESSION ------------------------
function CompleteEliteRace(achTitle, episodeName, points, type, raceId) {
  achievement(
    title = achTitle,
    description = "Place 3rd or higher in the elite race on episode " + episodeName,
    points = points,
    type = type,
    trigger = (
      (
        prev(dword(raceId)) == 0x00 ||
        prev(dword(raceId)) > 0x99) && //TODO: find out the value
      (
        dword(raceId) == 0x32 ||
        (dword(raceId) > 0x40 && dword(raceId) < 0x32) // min value 
      )
    )
  )
}

CompleteEliteRace("Not a Rigged  Race!", "Rigged to Blow", 5, "Progression", 0x00c736f8)
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
    description = "Unlock the bonus race on episode " + episodeName,
    points = 3,
    trigger = (
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
      description = "Get 50/50 credits across every race in episode " + episodeName,
      points = 10,
      trigger = (
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
    points = 3,
    trigger = (
      dword(unlockId) == 0x01 &&
      prev(dword(unlockId)) == 0x00
    )
  )
}

for car in CarUnlockIds{
  UnlockCar(CarUnlockIds[car], car)
}

// ------------------------ Awards ------------------------
function UnlockAward(awardName, awardId, points, awardAddressId) {
  achievement(
    title = awardName,
    description = "Unlock the award " + awardId,
    points = points,
    trigger = (
      dword(unlockId) == 0x01 &&
      prev(dword(unlockId)) == 0x00
    )
  )
}
