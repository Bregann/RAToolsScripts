// Need for Speed: Nitro
// #ID = 34593

OFFSET = 0xD50
function CurrentProfile() => dword_be(0x01578d80)

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
    0x1338ecc8, 0x1338ecc9, 0x1338ecca, 0x1338ecd4,
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
    description = "Earn 5 stars on every event in " + locName + " in the " + cupName + " Cup",
    points = 10,
    // confusing maths stuff lol
    trigger = (
      any_of(range(0, 5), p_id =>
        CurrentProfile() == p_id && 
        all_of(raceDict, addr => 
          byte(addr - ((p_id - 5) * OFFSET)) == 1
        ) &&
        any_of(raceDict, addr => 
          prev(byte(addr - ((p_id -5) * OFFSET))) != 1
        )
      )
    )
  )
}

AllStarsEarned("Rio Master - Bronze", "Rio De Janeiro", "Bronze", RioBronzeP6)