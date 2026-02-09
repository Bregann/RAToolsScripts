// Go Vacation
// #ID = 35935

// -------------------- Helper Functions --------------------
OFFSET = 0x11A0
RA_MASK = 0x1FFFFFFF

function ChainPointer(base, offsets, accessor=dword_be)
{
    val = base
    val = val & RA_MASK
    
    for i in range(0, length(offsets) - 1)
    {
        addr = val + offsets[i]
        if (i == length(offsets) - 1)
        {
            val = accessor(addr)
        }
        else
        {
            val = dword_be(addr)
            val = val & RA_MASK
        }
    }
    
    return val
}

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

// -------------------- Variables --------------------

function CurrentScreen() => dword_be(0x1001eb50)
function IsInGame() => CurrentScreen() != 0xffffff00

TimerRaceStatus = ChainPointer(dword_be(0x00a50808), [0x90, 0x24, 0x1c0])
ChallengeTimer = ChainPointer(dword_be(0x00a50808), [0x90, 0x24, 0x42c])
function ChallengeComplete() => ChainPointer(dword_be(0x00a50808), [0x90, 0x24, 0x1e4]) != 0xffffffff

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
BadgeAchievement("Speedy Wheels", "Wheel Slider", CalculateOffsetAndReturnAddress(0x1003d0c8))
BadgeAchievement("Puck Pusher", "Table Hockey", CalculateOffsetAndReturnAddress(0x1003d0d1))
BadgeAchievement("Shatter-Proof Rhythm", "Glass Harp", CalculateOffsetAndReturnAddress(0x1003d0d3))
BadgeAchievement("Urban Acrobat", "Skate Tricks", CalculateOffsetAndReturnAddress(0x1003d0c6))
BadgeAchievement("Rail Rider", "Grind Master", CalculateOffsetAndReturnAddress(0x1003d0c7))
BadgeAchievement("Hammer Time", "Mole Panic", CalculateOffsetAndReturnAddress(0x1003d0ce))
BadgeAchievement("Batting Pro", "Power Hitter", CalculateOffsetAndReturnAddress(0x1003d0cc))
BadgeAchievement("Bucket List", "Bucket Ball", CalculateOffsetAndReturnAddress(0x1003d0cf))
BadgeAchievement("Punch-Out!", "Power Boxer", CalculateOffsetAndReturnAddress(0x1003d0cd))
BadgeAchievement("Putter Perfection", "Mini Golf", CalculateOffsetAndReturnAddress(0x1003d0d4))
BadgeAchievement("Gravity Defier", "Halfpipe", CalculateOffsetAndReturnAddress(0x1003d0c9))

BadgeAchievement("Winter Warfare", "Snowball Fight", CalculateOffsetAndReturnAddress(0x1003d0e8))
BadgeAchievement("Leader of the Pack", "Dog Sled", CalculateOffsetAndReturnAddress(0x1003d0e5))
BadgeAchievement("Alpine Racer", "Snow Races", CalculateOffsetAndReturnAddress(0x1003d0df))
BadgeAchievement("Perfect Routine", "Trick CHallenge", CalculateOffsetAndReturnAddress(0x1003d0e0))
BadgeAchievement("Slippery Slope", "Snow Tubing", CalculateOffsetAndReturnAddress(0x1003d0e4))
BadgeAchievement("Engine on Ice", "Snowmobile Races", CalculateOffsetAndReturnAddress(0x1003d0e2))
BadgeAchievement("Bumpy Business", "Mogul", CalculateOffsetAndReturnAddress(0x1003d0e1))
BadgeAchievement("Ice-Cold Style", "Snow Tricks", CalculateOffsetAndReturnAddress(0x1003d0e3))
BadgeAchievement("Do You Want to Build a Snowman?", "Snowman Making", CalculateOffsetAndReturnAddress(0x1003d0e6))
BadgeAchievement("Leap of Faith", "Ski Jumping", CalculateOffsetAndReturnAddress(0x1003d0e9))
BadgeAchievement("Here Fishy Fishy!", "Ice Fishing", CalculateOffsetAndReturnAddress(0x1003d0e7))

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
function SilverKeyAchievement(achTitle, points, keyDict, minigameName, keyName = ""){
  description = ""

  if(keyName != "") {
    description = "Unlock the " + "\"" + keyName + "\"" + " Silver Key from the " + "\"" + minigameName + "\"" + " minigame"
  }
  else {
    description = "Unlock the Silver Key from the " + "\"" + minigameName + "\"" + " minigame"
  }

  achievement(
    title = achTitle,
    description = description,
    points = points,
    trigger = (
      IsInGame() &&
      any_of(keyDict, addr =>
        bit7(keyDict[addr]) == 1 &&
        prev(bit7(keyDict[addr])) == 0
      )
    )
  )
}

SilverKeyAchievement("Marine Sprint", 5, CalculateOffsetAndReturnAddress(0x1003cfc5), "Marine Bike Races", "Sprint Race: Clear All Stages")
SilverKeyAchievement("Driving Laps in the Water", 5, CalculateOffsetAndReturnAddress(0x1003cfc6), "Marine Bike Races", "Circuit Race: Clear All Stages")
SilverKeyAchievement("Ring Leader", 5, CalculateOffsetAndReturnAddress(0x1003cfc7), "Marine Bike Races", "Hoop Challenge: Clear All Stages")

SilverKeyAchievement("Skydiving Master", 5, CalculateOffsetAndReturnAddress(0x1003cfbf), "Sky Diving")

SilverKeyAchievement("Master of Beach Elimination", 5, CalculateOffsetAndReturnAddress(0x1003cfc1), "Beach Volleyball")

SilverKeyAchievement("Muddy Sprint", 5, CalculateOffsetAndReturnAddress(0x1003cfc2), "ATV Races", "Sprint Race: Clear All Stages")
SilverKeyAchievement("Mud-Caked Circuit Champion", 5, CalculateOffsetAndReturnAddress(0x1003cfc3), "ATV Races", "Circuit Race: Clear All Stages")
SilverKeyAchievement("Speeding Through the Gates", 5, CalculateOffsetAndReturnAddress(0x1003cfc4), "ATV Races", "Slalom Challenge: Clear All Stages")

SilverKeyAchievement("Recording Fish", 5, CalculateOffsetAndReturnAddress(0x1003cfbc), "Scuba Diving", "Free Diving: Complete 30% of the Diving Chart")
SilverKeyAchievement("Pro Fish Finder", 5, CalculateOffsetAndReturnAddress(0x1003cfbd), "Scuba Diving", "Free Diving: Complete 80% of the Diving Chart")
SilverKeyAchievement("Fish Searching Expert", 5, CalculateOffsetAndReturnAddress(0x1003cfbe), "Scuba Diving", "Fish Search: Clear All Levels")

SilverKeyAchievement("Tropical Harvester", 5, CalculateOffsetAndReturnAddress(0x1003cfcf), "Surfing", "Coco Challenge: Rank 4 or Higher")
SilverKeyAchievement("Heavy Water Hero", 5, CalculateOffsetAndReturnAddress(0x1003cfcd), "Surfing", "Big Wave Ride: Rank \"A\" or Higher")
SilverKeyAchievement("Skilled Surfer", 5, CalculateOffsetAndReturnAddress(0x1003cfce), "Surfing", "Score Trial: Rank 4 or Higher")

SilverKeyAchievement("Water Gun Warrior", 5, CalculateOffsetAndReturnAddress(0x1003cfc0), "Water Gun Battle")

SilverKeyAchievement("Flight of the Quad", 5, CalculateOffsetAndReturnAddress(0x1003cfc8), "ATV Tricks", "Jump Tricks: Rank 4 or Higher")
SilverKeyAchievement("Muddy Multi-tasker", 5, CalculateOffsetAndReturnAddress(0x1003cfc9), "ATV Tricks", "Ride & Tricks: Rank 4 or Higher")

SilverKeyAchievement("Wave Vaulter", 5, CalculateOffsetAndReturnAddress(0x1003cfca), "Marine Bike Tricks", "Jump Tricks: Rank 4 or Higher")
SilverKeyAchievement("Aquatic Rider and Trickster", 5, CalculateOffsetAndReturnAddress(0x1003cfcb), "Marine Bike Tricks", "Ride & Tricks: Rank 4 or Higher")

SilverKeyAchievement("Marine Multi-Sport Master", 5, CalculateOffsetAndReturnAddress(0x1003cfcc), "Triathlon")

SilverKeyAchievement("City Circuit Champ", 5, CalculateOffsetAndReturnAddress(0x1003cfe0), "Motor Fest", "Street Race: Clear All Stages")
SilverKeyAchievement("Sequence Speeder", 5, CalculateOffsetAndReturnAddress(0x1003cfe1), "Motor Fest", "Number Chaser: Clear All Stages")
SilverKeyAchievement("Two-Wheel Terror", 5, CalculateOffsetAndReturnAddress(0x1003cfe2), "Motor Fest", "Motorcycle Race: Clear All Stages")
SilverKeyAchievement("Nimble Navigator", 5, CalculateOffsetAndReturnAddress(0x1003cfe3), "Motor Fest", "Motorcycle Slalom: Clear All Stages")
SilverKeyAchievement("Left Turn Legend", 5, CalculateOffsetAndReturnAddress(0x1003cfe4), "Motor Fest", "Oval Race: Clear All Levels")

SilverKeyAchievement("Dance Fever", 5, CalculateOffsetAndReturnAddress(0x1003cfd8), "Dance")

SilverKeyAchievement("Pie Pro", 5, CalculateOffsetAndReturnAddress(0x1003cfd7), "Pie Throwing")

SilverKeyAchievement("Needle in the Sky", 5, CalculateOffsetAndReturnAddress(0x1003cfe5), "Hang Gliding", "Balloon Buster: Clear All Stages")
SilverKeyAchievement("Through the Hoop", 5, CalculateOffsetAndReturnAddress(0x1003cfe6), "Hang Gliding", "Flying Hoops: Clear All Stages")

SilverKeyAchievement("Frictionless Phenomenon", 5, CalculateOffsetAndReturnAddress(0x1003cfdd), "Wheel Slider")

SilverKeyAchievement("Hockey Hero", 5, CalculateOffsetAndReturnAddress(0x1003cfd1), "Table Hockey")

SilverKeyAchievement("Musical Legend", 5, CalculateOffsetAndReturnAddress(0x1003cfd2), "Glass Harp")

SilverKeyAchievement("Park Life", 5, CalculateOffsetAndReturnAddress(0x1003cfda), "Skate Tricks", "Park Tricks: Rank 4 or Higher")
SilverKeyAchievement("Urban Legend", 5, CalculateOffsetAndReturnAddress(0x1003cfdb), "Skate Tricks", "Street Tricks: Clear All Stages")

SilverKeyAchievement("Rail Gliding Expert", 5, CalculateOffsetAndReturnAddress(0x1003cfdc), "Grind Master")

SilverKeyAchievement("Mole Masher", 5, CalculateOffsetAndReturnAddress(0x1003cfd5), "Mole Hitter")

SilverKeyAchievement("Hard Hitter", 5, CalculateOffsetAndReturnAddress(0x1003cfd3), "Power Hitter")

SilverKeyAchievement("Bucket Beast", 5, CalculateOffsetAndReturnAddress(0x1003cfd6), "Bucket Ball")

SilverKeyAchievement("Heavy Hitter", 5, CalculateOffsetAndReturnAddress(0x1003cfd4), "Power Boxer")

SilverKeyAchievement("Putt-Putt Professional", 5, CalculateOffsetAndReturnAddress(0x1003cfd9), "Mini Golf")

SilverKeyAchievement("Airbound Artist", 5, CalculateOffsetAndReturnAddress(0x1003cfd0), "Halfpipe")

SilverKeyAchievement("Snow Sniper", 5, CalculateOffsetAndReturnAddress(0x1003cfe7), "Snowball Fight")

SilverKeyAchievement("Professional Doggy Commander", 5, CalculateOffsetAndReturnAddress(0x1003cfe8), "Dog Sled")

SilverKeyAchievement("Snowy Sprint", 5, CalculateOffsetAndReturnAddress(0x1003cfea), "Snow Races", "Sprint Race: Clear All Stages")
SilverKeyAchievement("Gate Glider", 5, CalculateOffsetAndReturnAddress(0x1003cfeb), "Snow Races", "Slalom Challenge: Clear All Stages")

SilverKeyAchievement("Ski Fanatic", 5, CalculateOffsetAndReturnAddress(0x1003cff2), "Trick Challenge", "Ski Tricks: Clear All Levels")
SilverKeyAchievement("Board Brilliance", 5, CalculateOffsetAndReturnAddress(0x1003cff3), "Trick Challenge", "Snowboard Tricks: Clear All Levels")
SilverKeyAchievement("Engine Airborne", 5, CalculateOffsetAndReturnAddress(0x1003cff4), "Trick Challenge", "Snowmobile Tricks: Clear All Levels")

SilverKeyAchievement("Turbo Tubing", 5, CalculateOffsetAndReturnAddress(0x1003cff5), "Snow Tubing", "Sprint Race: Clear All Stages")
SilverKeyAchievement("Slide & Strike", 5, CalculateOffsetAndReturnAddress(0x1003cff6), "Snow Tubing", "Tube Bowling: Score 30+ pts")

SilverKeyAchievement("Snowmobile Sprint", 5, CalculateOffsetAndReturnAddress(0x1003cfef), "Snowmobile Races", "Sprint Race: Clear All Stages")
SilverKeyAchievement("Snowmobile Circuit Sweep", 5, CalculateOffsetAndReturnAddress(0x1003cff0), "Snowmobile Races", "Circuit Race: Clear All Stages")
SilverKeyAchievement("Snowy Trail Blazer", 5, CalculateOffsetAndReturnAddress(0x1003cff1), "Snowmobile Races", "Open Race: Clear All Stages")

SilverKeyAchievement("Mogul Master", 5, CalculateOffsetAndReturnAddress(0x1003cfee), "Mogul")

SilverKeyAchievement("Snowy Halfpipe", 5, CalculateOffsetAndReturnAddress(0x1003cfec), "Snow Tricks", "Halfpipe Tricks: Rank 4 or Higher")
SilverKeyAchievement("Skilful Descent", 5, CalculateOffsetAndReturnAddress(0x1003cfed), "Snow Tricks", "Slopestyle: Rank 4 or Higher")

SilverKeyAchievement("Airbound Athlete", 5, CalculateOffsetAndReturnAddress(0x1003cfe9), "Ski Jumping")

SilverKeyAchievement("Court Dominator", 5, CalculateOffsetAndReturnAddress(0x1003cffc), "Tennis")

SilverKeyAchievement("Thundering Hooves", 5, CalculateOffsetAndReturnAddress(0x1003cffd), "Horseback Riding", "Sprint Race: Clear All Stages")
SilverKeyAchievement("Gallop and Gather", 5, CalculateOffsetAndReturnAddress(0x1003cffe), "Horseback Riding", "Coin Collect: Clear All Stages")

SilverKeyAchievement("Draft Popper", 5, CalculateOffsetAndReturnAddress(0x1003d005), "Paragliding", "Balloon Buster: Clear All Stages")
SilverKeyAchievement("Target Acquired", 5, CalculateOffsetAndReturnAddress(0x1003d006), "Paragliding", "Aimed Flight: Clear All Stages")

SilverKeyAchievement("River Rusher", 5, CalculateOffsetAndReturnAddress(0x1003d001), "Kayaking", "River Race: Clear All Stages")
SilverKeyAchievement("Gate Grazer", 5, CalculateOffsetAndReturnAddress(0x1003d002), "Kayaking", "River Slalom: Clear All Stages")
SilverKeyAchievement("River Riches", 5, CalculateOffsetAndReturnAddress(0x1003d003), "Kayaking", "Coin Collect: Clear All Stages")

SilverKeyAchievement("Route Master", 5, CalculateOffsetAndReturnAddress(0x1003cfff), "Off-Road Racing", "Open Race: Clear All Stages")
SilverKeyAchievement("Rallying Around", 5, CalculateOffsetAndReturnAddress(0x1003d000), "Off-Road Racing", "Rally Car: Clear All Stages")

SilverKeyAchievement("Torrent Tamer", 5, CalculateOffsetAndReturnAddress(0x1003d004), "Rafting")

SilverKeyAchievement("Shot Specialist", 5, CalculateOffsetAndReturnAddress(0x1003cff9), "Target Shooting")

SilverKeyAchievement("Fastest Gun in the West", 5, CalculateOffsetAndReturnAddress(0x1003cffa), "Quick Draw")

SilverKeyAchievement("Shattered Ceramic", 5, CalculateOffsetAndReturnAddress(0x1003cff8), "Clay Shooting")

SilverKeyAchievement("Marksman's Medal", 5, CalculateOffsetAndReturnAddress(0x1003cffb), "Rifle Shooting")

function GoldKeyAchievement(achTitle, points, keyDict, keyName){
  achievement(
    title = achTitle,
    description = "Unlock the " + "\"" + keyName + "\"" + " Gold Key",
    points = points,
    trigger = (
      IsInGame() &&
      any_of(keyDict, addr =>
        bit7(keyDict[addr]) == 1 &&
        prev(bit7(keyDict[addr])) == 0
      )
    )
  )
}

GoldKeyAchievement("Marine Resort Master", 10, CalculateOffsetAndReturnAddress(0x1003d05c), "Marine Resort Master")
GoldKeyAchievement("City Resort Master", 10, CalculateOffsetAndReturnAddress(0x1003d05d), "City Resort Master")
GoldKeyAchievement("Snow Resort Master", 10, CalculateOffsetAndReturnAddress(0x1003d05e), "Snow Resort Master")
GoldKeyAchievement("Mountain Resort Master", 10, CalculateOffsetAndReturnAddress(0x1003d05f), "Mountain Resort Master")
GoldKeyAchievement("Marine Gear Master", 10, CalculateOffsetAndReturnAddress(0x1003d060), "Marine Gear Master")
GoldKeyAchievement("City Gear Master", 10, CalculateOffsetAndReturnAddress(0x1003d061), "City Gear Master")
GoldKeyAchievement("Snow Gear Master", 10, CalculateOffsetAndReturnAddress(0x1003d062), "Snow Gear Master")
GoldKeyAchievement("Mountain Gear Master", 10, CalculateOffsetAndReturnAddress(0x1003d063), "Mountain Gear Master")
GoldKeyAchievement("Everyone's Friend", 5, CalculateOffsetAndReturnAddress(0x1003d064), "Everyone's Friend")
GoldKeyAchievement("Ball of Painful Memories", 10, CalculateOffsetAndReturnAddress(0x1003d065), "Ball of Painful Memories")
GoldKeyAchievement("Journeyman of Resorts", 10, CalculateOffsetAndReturnAddress(0x1003d066), "Journeyman of Resorts")
GoldKeyAchievement("Fun Master", 25, CalculateOffsetAndReturnAddress(0x1003d067), "Fun Master")

// -------------------- School --------------------
function SchoolAchievement(achTitle, categoryName, resortName, points, baseAddresses, targetCount){
  achievement(
    title = achTitle,
    description = "Complete all of the lessons in the " + "\"" + categoryName + "\"" + " category in the " + resortName,
    points = points,
    trigger = (
      IsInGame() &&
      any_of(range(1, 8), profileLesson =>
        sum_of(baseAddresses, addr => byte(addr + ((profileLesson - 1) * OFFSET))) == targetCount &&
        prev(sum_of(baseAddresses, addr => byte(addr + ((profileLesson - 1) * OFFSET)))) == targetCount - 1
      )
    )
  )
}

MarineSchoolWalkSwim = [
  0x1003cbe0, 0x1003cbe1, 0x1003cbe2, 0x1003cbe3
]

MarineSchoolMarineBikeControls = [
  0x1003cbe4, 0x1003cbe5, 0x1003cbe6, 0x1003cbe7,
  0x1003cbe8, 0x1003cbe9, 0x1003cbea, 0x1003cbeb,
  0x1003cbec, 0x1003cbed
]

MarineSchoolMarineBikeTricks = [
  0x1003cbee, 0x1003cbef, 0x1003cbf0, 0x1003cbf1,
  0x1003cbf2, 0x1003cbf3, 0x1003cbf4, 0x1003cbf5,
  0x1003cbf6, 0x1003cbf7, 0x1003cbf8, 0x1003cbf9
]

MarineSchoolATVControls = [
  0x1003cbfa, 0x1003cbfb, 0x1003cbfc, 0x1003cbfd, 
  0x1003cbfe, 0x1003cbff, 0x1003cc00
]

MarineSchoolATVTricks = [
  0x1003cc01, 0x1003cc02, 0x1003cc03, 0x1003cc04, 
  0x1003cc05, 0x1003cc06, 0x1003cc07, 0x1003cc08, 
  0x1003cc09, 0x1003cc0a, 0x1003cc0b, 0x1003cc0c, 
  0x1003cc0d
]

MarineSchoolWindsurfBoard = [
  0x1003cc0e, 0x1003cc0f, 0x1003cc10
]

MarineSchoolNormalSurfingControls = [
  0x1003cc11, 0x1003cc12, 0x1003cc13, 0x1003cc14, 
  0x1003cc15, 0x1003cc16, 0x1003cc17, 0x1003cc18, 
  0x1003cc19, 0x1003cc1a, 0x1003cc1b
]

MarineSchoolNormalSurfingTricks = [
  0x1003cc1c, 0x1003cc1d, 0x1003cc1e, 0x1003cc1f, 
  0x1003cc20, 0x1003cc21, 0x1003cc22
]

MarineSchoolTubeSurfingControls = [
  0x1003cc23, 0x1003cc24, 0x1003cc25, 0x1003cc26, 
  0x1003cc27, 0x1003cc28, 0x1003cc29, 0x1003cc2a
]

MarineSchoolTubeSurfingTricks = [
  0x1003cc2b, 0x1003cc2c, 0x1003cc2d, 0x1003cc2e, 
  0x1003cc2f, 0x1003cc30, 0x1003cc31
]

CitySchoolWalking = [
  0x1003cc76, 0x1003cc77, 0x1003cc78
]

CitySchoolInlineSkatesControls = [
  0x1003cc79, 0x1003cc7a, 0x1003cc7b, 0x1003cc7c, 
  0x1003cc7d, 0x1003cc7e, 0x1003cc7f, 0x1003cc80, 
  0x1003cc81
]

CitySchoolInlineSkatesTricks = [
  0x1003cc82, 0x1003cc83, 0x1003cc84, 0x1003cc85, 
  0x1003cc86, 0x1003cc87, 0x1003cc88, 0x1003cc89, 
  0x1003cc8a, 0x1003cc8b, 0x1003cc8c, 0x1003cc8d, 
  0x1003cc8e, 0x1003cc8f, 0x1003cc90
]

CitySchoolSkateboardControls = [
  0x1003cc91, 0x1003cc92, 0x1003cc93, 0x1003cc94, 
  0x1003cc95, 0x1003cc96, 0x1003cc97, 0x1003cc98, 
  0x1003cc99
]

CitySchoolSkateboardTricks = [
  0x1003cc9a, 0x1003cc9b, 0x1003cc9c, 0x1003cc9d, 
  0x1003cc9e, 0x1003cc9f, 0x1003cca0, 0x1003cca1, 
  0x1003cca2, 0x1003cca3, 0x1003cca4, 0x1003cca5, 
  0x1003cca6, 0x1003cca7, 0x1003cca8, 0x1003cca9
]

SnowSchoolWalking = [
  0x1003cd92, 0x1003cd93, 0x1003cd94
]

SnowSchoolSkisControls = [
  0x1003cd95, 0x1003cd96, 0x1003cd97, 0x1003cd98, 
  0x1003cd99, 0x1003cd9a, 0x1003cd9b, 0x1003cd9c, 
  0x1003cd9d, 0x1003cd9e, 0x1003cd9f, 0x1003cda0, 
  0x1003cda1
]

SnowSchoolSkisTricks = [
  0x1003cda2, 0x1003cda3, 0x1003cda4, 0x1003cda5, 
  0x1003cda6, 0x1003cda7, 0x1003cda8, 0x1003cda9, 
  0x1003cdaa, 0x1003cdab, 0x1003cdac, 0x1003cdad, 
  0x1003cdae, 0x1003cdaf, 0x1003cdb0
]

SnowSchoolSnowboardControls = [
  0x1003cdb1, 0x1003cdb2, 0x1003cdb3, 0x1003cdb4, 
  0x1003cdb5, 0x1003cdb6, 0x1003cdb7, 0x1003cdb8, 
  0x1003cdb9, 0x1003cdba, 0x1003cdbb, 0x1003cdbc, 
  0x1003cdbd
]

SnowSchoolSnowboardTricks = [
  0x1003cdbe, 0x1003cdbf, 0x1003cdc0, 0x1003cdc1, 
  0x1003cdc2, 0x1003cdc3, 0x1003cdc4, 0x1003cdc5, 
  0x1003cdc6, 0x1003cdc7, 0x1003cdc8, 0x1003cdc9, 
  0x1003cdca, 0x1003cdcb, 0x1003cdcc
]

SnowSchoolSnowmobileControls = [
  0x1003cdcd, 0x1003cdce, 0x1003cdcf, 0x1003cdd0, 
  0x1003cdd1
]

SnowSchoolSnowmobileTricks = [
  0x1003cdd2, 0x1003cdd3, 0x1003cdd4, 0x1003cdd5, 
  0x1003cdd6, 0x1003cdd7, 0x1003cdd8, 0x1003cdd9, 
  0x1003cdda, 0x1003cddb, 0x1003cddc, 0x1003cddd, 
  0x1003cdde
]

SnowSchoolSnowTube = [
  0x1003cddf, 0x1003cde0, 0x1003cde1, 0x1003cde2
]

MountainSchoolWalkingSwimming = [
  0x1003cd1e, 0x1003cd1f, 0x1003cd20, 0x1003cd21
]

MountainSchoolHorseControls = [
  0x1003cd22, 0x1003cd23, 0x1003cd24, 0x1003cd25, 
  0x1003cd26, 0x1003cd27, 0x1003cd28, 0x1003cd29, 
  0x1003cd2a, 0x1003cd2b
]

MountainSchoolOffRoadCar = [
  0x1003cd2c, 0x1003cd2d, 0x1003cd2e, 0x1003cd2f
]

MountainSchoolKayakControls = [
  0x1003cd30, 0x1003cd31, 0x1003cd32, 0x1003cd33, 
  0x1003cd34
]

SchoolAchievement("Just Keep Swimming", "Walk/Swim", "Marine School", 2, MarineSchoolWalkSwim, 4)
SchoolAchievement("Wave Runner 101", "Marine Bike Controls", "Marine School", 3, MarineSchoolMarineBikeControls, 10)
SchoolAchievement("Beginner Marine Biker", "Marine Bike Tricks", "Marine School", 4, MarineSchoolMarineBikeTricks, 12)
SchoolAchievement("ATV Beginner", "ATV Controls", "Marine School", 3, MarineSchoolATVControls, 7)
SchoolAchievement("Dirt Track Tricks", "ATV Tricks", "Marine School", 4, MarineSchoolATVTricks, 13)
SchoolAchievement("Sail Away", "Windsurf Board", "Marine School", 2, MarineSchoolWindsurfBoard, 3)
SchoolAchievement("Wave Leaner", "Normal Surfing Controls", "Marine School", 4, MarineSchoolNormalSurfingControls, 11)
SchoolAchievement("Shredding the Waves", "Normal Surfing Tricks", "Marine School", 3, MarineSchoolNormalSurfingTricks, 7)
SchoolAchievement("Tunnel Vision", "Tube Surfing Controls", "Marine School", 3, MarineSchoolTubeSurfingControls, 8)
SchoolAchievement("Tube Trickster", "Tube Surfing Tricks", "Marine School", 3, MarineSchoolTubeSurfingTricks, 7)

SchoolAchievement("Walking in the City", "Walk", "City School", 2, CitySchoolWalking, 4)
SchoolAchievement("Roller Ready", "Inline Skate Controls", "City School", 3, CitySchoolInlineSkatesControls, 7)
SchoolAchievement("Inline Trick Master", "Inline Skate Tricks", "City School", 4, CitySchoolInlineSkatesTricks, 15)
SchoolAchievement("Board Basic Training", "Skateboard Controls", "City School", 3, CitySchoolSkateboardControls, 9)
SchoolAchievement("Kickflip Classroom", "Skateboard Controls", "City School", 4, CitySchoolSkateboardTricks, 16)

SchoolAchievement("Winter Walking", "Walk", "Snow School", 2, CitySchoolWalking, 3)
SchoolAchievement("Skiing Fundamentals", "Ski Controls", "Snow School", 4, SnowSchoolSkisControls, 13)
SchoolAchievement("Freestyle Ski School", "Ski Tricks", "Snow School", 4, SnowSchoolSkisTricks, 15)
SchoolAchievement("Snowboarding Basics", "Snowboard Controls", "Snow School", 4, SnowSchoolSnowboardControls, 13)
SchoolAchievement("Board Acrobatics 101", "Snowboard Tricks", "Snow School", 4, SnowSchoolSnowboardTricks, 15)
SchoolAchievement("Snowmobile Safety Course", "Snowmobile Controls", "Snow School", 3, SnowSchoolSkisControls, 5)
SchoolAchievement("High-Speed Stunts", "Snowmobile Tricks", "Snow School", 4, SnowSchoolSnowmobileTricks, 16)
SchoolAchievement("Tubing Techniques", "Snow Tube", "Snow School", 2, SnowSchoolSnowTube, 4)

SchoolAchievement("Alpine Mobility", "Walk/Swim", "Mountain School", 2, MountainSchoolWalkingSwimming, 4)
SchoolAchievement("Equestrian Essentials", "Horse", "Mountain School", 3, MountainSchoolHorseControls, 10)
SchoolAchievement("4WD Fundamentals", "Off-Road Car", "Mountain School", 2, MountainSchoolOffRoadCar, 4)
SchoolAchievement("River Navigation Theory", "Kayak", "Mountain School", 2, MountainSchoolKayakControls, 5)

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

MarineResortChests = [
  0x1003a5a9, 0x1003a5aa, 0x1003a5ab, 
  0x1003a5ac, 0x1003a5ad, 0x1003a5ae,
  0x1003a5af
]

CityResortChests = [
  0x1003a5b0, 0x1003a5b1, 0x1003a5b2,
  0x1003a5b3, 0x1003a5b4, 0x1003a5b5,
  0x1003a5b6
]

SnowResortChests = [
  0x1003a5b7, 0x1003a5b8, 0x1003a5b9,
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

TreasureChestAchievement("Marine Looter", "Marine Resort", MarineResortChests)
TreasureChestAchievement("Urban Exploration", "City Resort", CityResortChests)
TreasureChestAchievement("Glacial Plunder", "Snow Resort", SnowResortChests)
TreasureChestAchievement("Mountain Swag", "Mountain Resort", MountainResortChests)

BalloonHintAchievement("Frequently Asked Questions", "Information", 5, InformationBalloonHints, 15)
BalloonHintAchievement("Marine Intelligence", "Marine Guide", 5, MarineGuideBalloonHints, 14)
BalloonHintAchievement("Street Smart", "City Guide", 3, CityGuideBalloonHints, 5)
BalloonHintAchievement("Frosty Facts", "Snow Guide", 4, SnowGuideBalloonHints, 8)
BalloonHintAchievement("Higher Learning", "Mountain Guide", 4, MountainGuideBalloonHints, 9)

PhotoSpotAchievement("Capturing the Coast", "Marine Resort", MarineResortPhotoSpots)
PhotoSpotAchievement("Urban Paparazzi", "City Resort", CityResortPhotoSpots)
PhotoSpotAchievement("Say Freeze!", "Snow Resort", SnowResortPhotoSpots)
PhotoSpotAchievement("Summit Sightseer", "Mountain Resort", MountainResortPhotoSpots)

// -------------------- Leaderboard / Challenges --------------------
function TimeLeaderboard(minigameRaceName, baseAddress) {
    keyDict = CalculateOffsetAndReturnAddress(baseAddress)
    
    //Generate the dictionary of addresses
    value_conditions = array_map(range(0, 7), i => 
      measured(
          // The Target Value (Save Slot Address)
          dword_be(baseAddress + (i * OFFSET)) / 4,
      
          // The Condition: Only measure if Value != Prev Value
          when = dword_be(baseAddress + (i * OFFSET)) != prev(dword_be(baseAddress + (i * OFFSET)))
      )
    )

    leaderboard(
      title = minigameRaceName,
      description = "Complete the stage in the quickest time",
      start = (
        IsInGame() &&
        any_of(keyDict, addr =>
          (dword_be(keyDict[addr]) < prev(dword_be(keyDict[addr])))
          ||
          (dword_be(keyDict[addr]) != 0xfffffffc && prev(dword_be(keyDict[addr])) == 0xfffffffc)
        )
    ),
    cancel = (
      always_false()
    ),
    submit = (
      any_of(keyDict, addr =>
        (dword_be(keyDict[addr]) < prev(dword_be(keyDict[addr])))
        ||
        (dword_be(keyDict[addr]) != 0xfffffffc && prev(dword_be(keyDict[addr])) == 0xfffffffc)
      )
    ),
    value = max_of(value_conditions),
    format = "FRAMES",
    lower_is_better = true
  )
}

function ScoreLeaderboard(minigameRaceName, baseAddress) {
    keyDict = CalculateOffsetAndReturnAddress(baseAddress)
    
    //Generate the dictionary of addresses
    value_conditions = array_map(range(0, 7), i => 
      measured(
          // The Target Value (Save Slot Address)
          dword_be(baseAddress + (i * OFFSET)) / 4,
      
          // The Condition: Only measure if Value != Prev Value
          when = dword_be(baseAddress + (i * OFFSET)) != prev(dword_be(baseAddress + (i * OFFSET)))
      )
    )

    leaderboard(
      title = minigameRaceName,
      description = "Earn the highest points in the stage",
      start = (
        IsInGame() &&
        any_of(keyDict, addr =>
          (dword_be(keyDict[addr]) < prev(dword_be(keyDict[addr])))
          ||
          (dword_be(keyDict[addr]) != 0xfffffffc && prev(dword_be(keyDict[addr])) == 0xfffffffc)
        )
    ),
    cancel = (
      always_false()
    ),
    submit = (
      any_of(keyDict, addr =>
        (dword_be(keyDict[addr]) < prev(dword_be(keyDict[addr])))
        ||
        (dword_be(keyDict[addr]) != 0xfffffffc && prev(dword_be(keyDict[addr])) == 0xfffffffc)
      )
    ),
    value = max_of(value_conditions),
    format = "SCORE",
    lower_is_better = false
  )
}

function SpeedrunTimeAchievement(achName, achDesc, points, keyDict, framesAmount, screenAddr){
  achievement(
    title = achName,
    description = achDesc,
    points = points,
    trigger = (
      IsInGame() &&
      trigger_when(
        any_of(keyDict, addr =>
          (
            dword_be(keyDict[addr]) < framesAmount &&
            prev(dword_be(keyDict[addr])) > framesAmount
          )
          ||
          (
            dword_be(keyDict[addr]) < framesAmount && 
            prev(dword_be(keyDict[addr])) == 0xfffffffc
          )
        )
      ) &&
      CurrentScreen() == screenAddr &&
      TimerRaceStatus != 0x00
    )
  )
}

function ScoreAchievement(achName, achDesc, points, keyDict, pointsAmount, screenAddr){
  achievement(
    title = achName,
    description = achDesc,
    points = points,
    trigger = (
      IsInGame() &&
      trigger_when(
        any_of(keyDict, addr =>
          (
            dword_be(keyDict[addr]) >= pointsAmount &&
            prev(dword_be(keyDict[addr])) =< pointsAmount
          )
          ||
          (
            dword_be(keyDict[addr]) >= pointsAmount && 
            prev(dword_be(keyDict[addr])) == 0xfffffffc
          )
        )
      ) &&
      CurrentScreen() == screenAddr
    )
  )
}

TimeLeaderboard("Marine Bike Races - Sprint Race - Stage 1", 0x1003c70c)
TimeLeaderboard("Marine Bike Races - Sprint Race - Stage 2", 0x1003c710)
TimeLeaderboard("Marine Bike Races - Sprint Race - Stage 3", 0x1003c714)

SpeedrunTimeAchievement("Sprinting on the Water", "Complete Stage 1 of the Marine Bike Sprint Race in under 0'54\"30", 5, CalculateOffsetAndReturnAddress(0x1003c70c), 27768)

TimeLeaderboard("Marine Bike Races - Circuit Race - Stage 1", 0x1003c718)
TimeLeaderboard("Marine Bike Races - Circuit Race - Stage 2", 0x1003c71c)
TimeLeaderboard("Marine Bike Races - Circuit Race - Stage 3", 0x1003c720)

SpeedrunTimeAchievement("Marine Circuit Speedster", "Complete Stage 2 of the Marine Bike Circuit Race in under 3'21\"50", 5, CalculateOffsetAndReturnAddress(0x1003c71c), 109256)

TimeLeaderboard("Marine Bike Races - Hoop Challenge - Stage 1", 0x1003c724)
TimeLeaderboard("Marine Bike Races - Hoop Challenge - Stage 2", 0x1003c728)
TimeLeaderboard("Marine Bike Races - Hoop Challenge - Stage 3", 0x1003c72c)
TimeLeaderboard("Marine Bike Races - Hoop Challenge - Stage 4", 0x1003c730)
TimeLeaderboard("Marine Bike Races - Hoop Challenge - Stage 5", 0x1003c734)

achievement(
  title = "No Hoops Missed!",
  description = "Complete Stage 5 of the Marine Bike Hoop Challenge within the time limit without missing any hoops",
  points = 5,
  trigger = (
    CurrentScreen() == 0x00030204 
    &&
    once(
      TimerRaceStatus == 0x04 &&
      prev(TimerRaceStatus) == 0x03 &&
      !ChallengeComplete()
    ) 
    &&
    never(
      ChallengeTimer == prev(ChallengeTimer) + 151 ||
      ChallengeTimer > 3003
    ) 
    &&
    trigger_when(
      ChallengeTimer < 3003 &&
      TimerRaceStatus == 0x07
    )
  )
)