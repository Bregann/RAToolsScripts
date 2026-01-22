// Go Vacation
// #ID = 35935

OFFSET = 0x11A0
function IsInGame() => dword_be(0x1001eb50) != 0xffffff00

// -------------------- Helper Functions --------------------

// Dictionaries
function CalculateOffsetAndReturnAddress(baseAddr){
  dict = {}

  for i in range(0, 7) {
    dict[i + 1] = baseAddr + (i * OFFSET)
  }

  return dict
}

function CalculateOffsetArray(baseAddresses){
  dict = {}

  for i in range(0, 7) {
    addresses = []
    for addr in baseAddresses {
      array_push(addresses, addr + (i * OFFSET))
    }
    dict[i + 1] = addresses
  }

  return dict
}

// -------------------- Progression --------------------

function BadgeAchievement(achTitle, minigameName, badgeDict){
  achievement(
    title = achTitle,
    description = "Collect the stamp from playing the " + "\"" + minigameName + "\"" + " minigame",
    points = 3,
    type = "PROGRESSION",
    trigger = (
      IsInGame() &&
      any_of(badgeDict, addr =>
        bit7(badgeDict[addr]) == 1 &&
        prev(bit7(badgeDict[addr])) == 0
      )
    )
  )
}

BadgeAchievement("Marine Racer", "Marine Bike", CalculateOffsetAndReturnAddress(0x1003d0bd))
BadgeAchievement("I Believe I Can Fly", "Sky Diving", CalculateOffsetAndReturnAddress(0x1003d0c3))
BadgeAchievement("Shoreline Volley", "Beach Vollyball", CalculateOffsetAndReturnAddress(0x1003d0c5))
BadgeAchievement("Island Trailblazer", "ATV Racing", CalculateOffsetAndReturnAddress(0x1003d0bc))
BadgeAchievement("Underwater Adventure", "Scuba Diving", CalculateOffsetAndReturnAddress(0x1003d0c2))
BadgeAchievement("Riding the Waves", "Surfing", CalculateOffsetAndReturnAddress(0x1003d0c1))
BadgeAchievement("Say Hello to My Little Friend", "Water Gun Battle", CalculateOffsetAndReturnAddress(0x1003d0c4))
BadgeAchievement("Quad Acrobat", "ATV Tricks", CalculateOffsetAndReturnAddress(0x1003d0be))
BadgeAchievement("Aqua Aerobatics", "Marine Bike Tricks", CalculateOffsetAndReturnAddress(0x1003d0bf))
BadgeAchievement("Marine Iron Man", "Triathlon", CalculateOffsetAndReturnAddress(0x1003d0c0))

BadgeAchievement("City Racing", "Motor Fest", CalculateOffsetAndReturnAddress(0x1003d0ca))
BadgeAchievement("Boogie Wonderland", "Dance", CalculateOffsetAndReturnAddress(0x1003d0d2))
BadgeAchievement("Get Pied!", "Pie Throwing", CalculateOffsetAndReturnAddress(0x1003d0d0))
BadgeAchievement("Flying with the Birds", "Hang Gliding", CalculateOffsetAndReturnAddress(0x1003d0cb))
BadgeAchievement("Rail Rider", "Grind Master", CalculateOffsetAndReturnAddress(0x1003d0c7))
BadgeAchievement("Puck Pusher", "Table Hockey", CalculateOffsetAndReturnAddress(0x1003d0d1))
BadgeAchievement("Shatter-Proof Rhythm", "Glass Harp", CalculateOffsetAndReturnAddress(0x1003d0d3))
BadgeAchievement("Urban Acrobat", "Skate Tricks", CalculateOffsetAndReturnAddress(0x1003d0c6))
BadgeAchievement("Speedy Wheels", "Wheel Slider", CalculateOffsetAndReturnAddress(0x1003d0c8))
BadgeAchievement("Hammer Time", "Mole Panic", CalculateOffsetAndReturnAddress(0x1003d0ce))
BadgeAchievement("Batting Pro", "Power Hitter", CalculateOffsetAndReturnAddress(0x1003d0cc))
BadgeAchievement("Bucket List", "Bucket Ball", CalculateOffsetAndReturnAddress(0x1003d0cf))
BadgeAchievement("Punch-Out!", "Power Boxer", CalculateOffsetAndReturnAddress(0x1003d0cd))
BadgeAchievement("Putter Perfection", "Mini Golf", CalculateOffsetAndReturnAddress(0x1003d0d4))
BadgeAchievement("Gravity Defier", "Halfpipe", CalculateOffsetAndReturnAddress(0x1003d0c9))

BadgeAchievement("Winter Warfare", "Snowball Fight", CalculateOffsetAndReturnAddress(0x1003d0e8))
BadgeAchievement("Leader of the Pack", "Dog Sled", CalculateOffsetAndReturnAddress(0x1003d0e5))
BadgeAchievement("Alpine Racer", "Snow Races", CalculateOffsetAndReturnAddress(0x1003d0df))
BadgeAchievement("Ice-Cold Style", "Snow Tricks", CalculateOffsetAndReturnAddress(0x1003d0e0))
BadgeAchievement("Slippery Slope", "Snow Tubing", CalculateOffsetAndReturnAddress(0x1003d0e4))
BadgeAchievement("Engine on Ice", "Snowmobile Races", CalculateOffsetAndReturnAddress(0x1003d0e2))
BadgeAchievement("Bumpy Business", "Mogul", CalculateOffsetAndReturnAddress(0x1003d0e1))
BadgeAchievement("Perfect Routine", "Trick Challenge", CalculateOffsetAndReturnAddress(0x1003d0e3))
BadgeAchievement("Do You Want to Build a Snowman?", "Snowman Making", CalculateOffsetAndReturnAddress(0x1003d0e6))
BadgeAchievement("Leap of Faith", "Ski Jumping", CalculateOffsetAndReturnAddress(0x1003d0e9))

BadgeAchievement("Grand Slam Legend", "Tennis", CalculateOffsetAndReturnAddress(0x1003d0de))
BadgeAchievement("Horsing Around", "Horseback Riding", CalculateOffsetAndReturnAddress(0x1003d0d6))
BadgeAchievement("Wind Beneath My Wings", "Paragliding", CalculateOffsetAndReturnAddress(0x1003d0d8))
BadgeAchievement("Paddle Power", "Kayaking", CalculateOffsetAndReturnAddress(0x1003d0d5))
BadgeAchievement("Off-Road Adventure", "Off-Road Racing", CalculateOffsetAndReturnAddress(0x1003d0d7))
BadgeAchievement("White Water Warrior", "Rafting", CalculateOffsetAndReturnAddress(0x1003d0d9))
BadgeAchievement("Target in Sight", "Target Shooting", CalculateOffsetAndReturnAddress(0x1003d0db))
BadgeAchievement("Blink and You'll Miss It", "Quick Draw", CalculateOffsetAndReturnAddress(0x1003d0dc))
BadgeAchievement("Bird of Clay", "Clay Shooting", CalculateOffsetAndReturnAddress(0x1003d0da))
BadgeAchievement("Pinpoint Precision", "Rifle Shooting", CalculateOffsetAndReturnAddress(0x1003d0dd))

// -------------------- Keys --------------------
function SilverKeyAchievement(achTitle, description, points, baseAddresses, targetCount){
  achievement(
    title = achTitle,
    description = description,
    points = points,
    trigger = (
      IsInGame() &&
      any_of(range(1, 8), profileKey =>
        sum_of(baseAddresses, addr => byte(addr + ((profileKey - 1) * OFFSET))) == targetCount &&
        prev(sum_of(baseAddresses, addr => byte(addr + ((profileKey - 1) * OFFSET)))) < targetCount  
      )
    )
  )
}

// -------------------- Hints/Chests/Photo Spots --------------------
function TreasureChestAchievement(achTitle, locName, baseAddresses){
  achievement(
    title = achTitle,
    description = "Unlock every Treasure Chest in the " + locName,
    points = 10,
    trigger = (
      IsInGame() &&
      any_of(range(1, 8), profileKey =>
        sum_of(baseAddresses, addr => bit7(addr + ((profileKey - 1) * OFFSET))) == 7 &&
        prev(sum_of(baseAddresses, addr => bit7(addr + ((profileKey - 1) * OFFSET)))) == 6  
      )
    )
  )
}

function BalloonHintAchievement(achTitle, hintName, points, baseAddresses, targetCount){
  achievement(
    title = achTitle,
    description = "Find every " + "\"" + hintName + "\"" + " Balloon Hint",
    points = points,
    trigger = (
      IsInGame() &&
      any_of(range(1, 8), profileKey =>
        sum_of(baseAddresses, addr => byte(addr + ((profileKey - 1) * OFFSET))) == targetCount &&
        prev(sum_of(baseAddresses, addr => byte(addr + ((profileKey - 1) * OFFSET)))) < targetCount  
      )
    )
  )
}

function PhotoSpotAchievement(achTitle, locName, baseAddresses){
  achievement(
    title = achTitle,
    description = "Unlock every Photo Spot in the " + locName,
    points = 10,
    trigger = (
	      IsInGame() &&
        any_of(range(1, 8), profileKey =>
          sum_of(baseAddresses, addr => byte(addr + ((profileKey - 1) * OFFSET))) == 14 &&
          prev(sum_of(baseAddresses, addr => byte(addr + ((profileKey - 1) * OFFSET)))) == 13  
      )
	  )
  )
}

MarineResortChests = 
[0x1003a5a9, 0x1003a5aa, 0x1003a5ab, 
0x1003a5ac, 0x1003a5ad, 0x1003a5ae,
0x1003a5af]

CityResortChests = 
[0x1003a5b0, 0x1003a5b1, 0x1003a5b2,
0x1003a5b3, 0x1003a5b4, 0x1003a5b5,
0x1003a5b6]

SnowResortChests = 
[0x1003a5b7, 0x1003a5b8, 0x1003a5b9,
0x1003a5ba, 0x1003a5bb, 0x1003a5bc,
0x1003a5bd
]

MountainResortChests = [
0x1003a5be, 0x1003a5bf, 0x1003a5c0,
0x1003a5c1, 0x1003a5c2, 0x1003a5c3,
0x1003a5c4
]

InformationBalloonHints = [
0x1003a5c5, 0x1003a5c6, 0x1003a5c7, 0x1003a5c8, 0x1003a5c9,
0x1003a5ca, 0x1003a5cb, 0x1003a5cc, 0x1003a5cd, 0x1003a5ce,
0x1003a5cf, 0x1003a5d0, 0x1003a5d1, 0x1003a5d2, 0x1003a5d3
]

MarineGuideBalloonHints = [
0x1003a5d4, 0x1003a5d5, 0x1003a5d6, 0x1003a5d7, 0x1003a5d8,
0x1003a5d9, 0x1003a5da, 0x1003a5db, 0x1003a5dc, 0x1003a5dd,
0x1003a5de, 0x1003a5df, 0x1003a5e0, 0x1003a5e1
]

CityGuideBalloonHints = [
0x1003a5e2, 0x1003a5e3, 0x1003a5e4, 
0x1003a5e5, 0x1003a5e6
]

SnowGuideBalloonHints = [
0x1003a5e7, 0x1003a5e8, 0x1003a5e9, 0x1003a5ea,
0x1003a5eb, 0x1003a5ec, 0x1003a5ed, 0x1003a5ee
]

MountainGuideBalloonHints = [
0x1003a5ef, 0x1003a5f0, 0x1003a5f1, 0x1003a5f2,
0x1003a5f3, 0x1003a5f4, 0x1003a5f5, 0x1003a5f6,
0x1003a5f7
]

MarineResortPhotoSpots = [
0x1003a5fc, 0x1003a5fd, 0x1003a5fe, 0x1003a5ff, 0x1003a603,
0x1003a604, 0x1003a605, 0x1003a606, 0x1003a600, 0x1003a601,
0x1003a607, 0x1003a608, 0x1003a602, 0x1003a609
]

CityResortPhotoSpots = [
0x1003a60a, 0x1003a60b, 0x1003a60c, 0x1003a60d, 0x1003a60e,
0x1003a611, 0x1003a612, 0x1003a613, 0x1003a614, 0x1003a615,
0x1003a60f, 0x1003a610, 0x1003a616, 0x1003a617
]

SnowResortPhotoSpots = [
0x1003a618, 0x1003a619, 0x1003a61a, 0x1003a61b, 0x1003a61c,
0x1003a61f, 0x1003a620, 0x1003a621, 0x1003a622, 0x1003a61d,
0x1003a61e, 0x1003a623, 0x1003a624, 0x1003a625
]

MountainResortPhotoSpots = [
0x1003a626, 0x1003a627, 0x1003a628, 0x1003a629, 0x1003a62a,
0x1003a62d, 0x1003a62e, 0x1003a62f, 0x1003a630, 0x1003a631,
0x1003a62b, 0x1003a62c, 0x1003a632, 0x1003a633
]

TreasureChestAchievement("", "Marine Resort", MarineResortChests)
TreasureChestAchievement("", "City Resort", CityResortChests)
TreasureChestAchievement("", "Snow Resort", SnowResortChests)
TreasureChestAchievement("", "Mountain Resort", MountainResortChests)

BalloonHintAchievement("", "Information", 5, InformationBalloonHints, 15)
BalloonHintAchievement("", "Marine Guide", 5, MarineGuideBalloonHints, 14)
BalloonHintAchievement("", "City Guide", 3, CityGuideBalloonHints, 5)
BalloonHintAchievement("", "Snow Guide", 4, SnowGuideBalloonHints, 8)
BalloonHintAchievement("", "Mountain Guide", 4, MountainGuideBalloonHints, 9)