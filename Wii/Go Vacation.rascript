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

// -------------------- Variables --------------------

function CurrentScreen() => dword_be(0x1001eb50)
function IsInGame() => CurrentScreen() != 0xffffff00

TimerRaceStatus = ChainPointer(dword_be(0x00a50808), [0x90, 0x24, 0x1c0])
ChallengeTimer = ChainPointer(dword_be(0x00a50808), [0x90, 0x24, 0x42c])
InGameTimer = ChainPointer(dword_be(0x00a50808), [0x90, 0x24, 0x1dc])
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
BadgeAchievement("Perfect Routine", "Trick Challenge", CalculateOffsetAndReturnAddress(0x1003d0e0))
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

// doesn't work, the timers are all funky and the game doesn't run right lol
function TimeLeaderboard(minigameRaceName, baseAddress, lowerIsBetter = true, currentScreen = 0x00160000) {
    keyDict = CalculateOffsetAndReturnAddress(baseAddress)
  
    //Generate the dictionary of addresses
    value_conditions = array_map(range(0, 7), i => 
      measured(
          // The Target Value (Save Slot Address)
        ((dword_be(baseAddress + (i * OFFSET)) + 3022) * 1000 / 5541),
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
    lower_is_better = lowerIsBetter
  )
}

function ScoreLeaderboard(minigameRaceName, baseAddress, divAmount = 4) {
    keyDict = CalculateOffsetAndReturnAddress(baseAddress)
    
    //Generate the dictionary of addresses
    value_conditions = array_map(range(0, 7), i => 
      measured(
          // The Target Value (Save Slot Address)
          dword_be(baseAddress + (i * OFFSET)) / divAmount,
      
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
          (dword_be(keyDict[addr]) > prev(dword_be(keyDict[addr])))
          ||
          (dword_be(keyDict[addr]) != 0xfffffffc && prev(dword_be(keyDict[addr])) == 0xfffffffc)
        )
    ),
    cancel = (
      always_false()
    ),
    submit = (
      any_of(keyDict, addr =>
        (dword_be(keyDict[addr]) > prev(dword_be(keyDict[addr])))
        ||
        (dword_be(keyDict[addr]) != 0xfffffffc && prev(dword_be(keyDict[addr])) == 0xfffffffc)
      )
    ),
    value = max_of(value_conditions),
    format = "SCORE",
    lower_is_better = false
  )
}

function SpeedrunTimeAchievement(achName, achDesc, points, keyDict, framesAmount){
  achievement(
    title = achName,
    description = achDesc,
    points = points,
    trigger = (
      IsInGame() &&
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
    )
  )
}

function ScoreAchievement(achName, achDesc, points, keyDict, pointsAmount){
  achievement(
    title = achName,
    description = achDesc,
    points = points,
    trigger = (
      IsInGame() &&
      any_of(keyDict, addr =>
        (
          dword_be(keyDict[addr]) >= pointsAmount &&
          prev(dword_be(keyDict[addr])) <= pointsAmount &&
          dword_be(keyDict[addr]) != 0xfffffffc
        )
        ||
        (
          dword_be(keyDict[addr]) >= pointsAmount && 
          prev(dword_be(keyDict[addr])) == 0xfffffffc &&
          dword_be(keyDict[addr]) != 0xfffffffc
        )
      )
    )
  )
}

function RankAchievement(achName, minigameName, keyDict, maxRank){
  achievement(
    title = achName,
    description = "Reach the highest rank in the " + minigameName + " minigame",
    points = 5,
    trigger = (
      IsInGame() &&
      any_of(keyDict, addr =>
        (
          byte(keyDict[addr]) == maxRank &&
          prev(byte(keyDict[addr])) <= maxRank &&
          byte (keyDict[addr]) != 0xff
        )
        ||
        (
          byte(keyDict[addr]) == maxRank && 
          prev(byte(keyDict[addr])) == 0xff &&
          byte(keyDict[addr]) != 0xff
        )
      )
    )
  )
}

// TimeLeaderboard("Marine Bike Races - Sprint Race - Stage 1", 0x1003c70c)
// TimeLeaderboard("Marine Bike Races - Sprint Race - Stage 2", 0x1003c710)
// TimeLeaderboard("Marine Bike Races - Sprint Race - Stage 3", 0x1003c714)

SpeedrunTimeAchievement("Sprinting on the Water", "Complete Stage 1 of the Marine Bike Sprint Race in under 0'54\"30", 5, CalculateOffsetAndReturnAddress(0x1003c70c), 27768)

// TimeLeaderboard("Marine Bike Races - Circuit Race - Stage 1", 0x1003c718)
// TimeLeaderboard("Marine Bike Races - Circuit Race - Stage 2", 0x1003c71c)
// TimeLeaderboard("Marine Bike Races - Circuit Race - Stage 3", 0x1003c720)

SpeedrunTimeAchievement("Marine Circuit Speedster", "Complete Stage 2 of the Marine Bike Circuit Race in under 3'21\"50", 5, CalculateOffsetAndReturnAddress(0x1003c71c), 109256)

// TimeLeaderboard("Marine Bike Races - Hoop Challenge - Stage 1", 0x1003c724)
// TimeLeaderboard("Marine Bike Races - Hoop Challenge - Stage 2", 0x1003c728)
// TimeLeaderboard("Marine Bike Races - Hoop Challenge - Stage 3", 0x1003c72c)
// TimeLeaderboard("Marine Bike Races - Hoop Challenge - Stage 4", 0x1003c730)
// TimeLeaderboard("Marine Bike Races - Hoop Challenge - Stage 5", 0x1003c734)

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

ScoreLeaderboard("Sky Diving - Level 1", 0x1003c7bc)
ScoreLeaderboard("Sky Diving - Level 2", 0x1003c7c0)
ScoreLeaderboard("Sky Diving - Level 3", 0x1003c7c4)

ScoreAchievement("Super Sky Diver", "Earn a score of 4200 or higher on Level 2 of the Sky Diving minigame", 5, CalculateOffsetAndReturnAddress(0x1003c7c0), 16800)

// TimeLeaderboard("ATV Racing - Sprint Race - Stage 1", 0x1003c6e0)
// TimeLeaderboard("ATV Racing - Sprint Race - Stage 2", 0x1003c6e4)
// TimeLeaderboard("ATV Racing - Sprint Race - Stage 3", 0x1003c6e8)

SpeedrunTimeAchievement("Sprinting and Jumping", "Complete Stage 2 of the ATV Racing Sprint Race in under 1'04\"00", 5, CalculateOffsetAndReturnAddress(0x1003c6e4), 34704)

// TimeLeaderboard("ATV Racing - Circuit Race - Stage 1", 0x1003c6ec)
// TimeLeaderboard("ATV Racing - Circuit Race - Stage 2", 0x1003c6f0)
// TimeLeaderboard("ATV Racing - Circuit Race - Stage 3", 0x1003c6f4)

SpeedrunTimeAchievement("Zooming Round the Beach", "Complete Stage 1 of the ATV Circuit Race in under 2'45\"00", 5, CalculateOffsetAndReturnAddress(0x1003c6ec), 88464)

// TimeLeaderboard("ATV Racing - Slalom Challenge - Stage 1", 0x1003c6f8)
// TimeLeaderboard("ATV Racing - Slalom Challenge - Stage 2", 0x1003c6fc)
// TimeLeaderboard("ATV Racing - Slalom Challenge - Stage 3", 0x1003c700)
// TimeLeaderboard("ATV Racing - Slalom Challenge - Stage 4", 0x1003c704)
// TimeLeaderboard("ATV Racing - Slalom Challenge - Stage 5", 0x1003c708)

achievement(
  title = "Off-road Flag Adventure",
  description = "Complete Stage 3 of the ATV Racing Slalom Challenge within the time limit without missing any gates",
  points = 5,
  trigger = (
    CurrentScreen() == 0x00020202
    &&
    once(
      TimerRaceStatus == 0x04 &&
      prev(TimerRaceStatus) == 0x03 &&
      !ChallengeComplete()
    ) 
    &&
    never(
      ChallengeTimer == prev(ChallengeTimer) + 151 ||
      ChallengeTimer > 3150
    ) 
    &&
    trigger_when(
      ChallengeTimer < 3150 &&
      TimerRaceStatus == 0x07
    )
  )
)

// scuba diving
chartedStuff = 
[
  0x1003d08c, 0x1003d08d, 0x1003d08e, 0x1003d08f, 0x1003d090, 0x1003d091, 
  0x1003d092, 0x1003d093,  0x1003d094, 0x1003d095, 0x1003d096, 0x1003d097, 
  0x1003d098, 0x1003d099, 0x1003d09a, 0x1003d09b, 0x1003d09c, 0x1003d09d, 
  0x1003d09e, 0x1003d09f, 0x1003d0a0, 0x1003d0a1, 0x1003d0a2, 0x1003d0a3, 
  0x1003d0a4, 0x1003d0a5, 0x1003d0a6, 0x1003d0a7, 0x1003d0a8, 0x1003d0a9, 
  0x1003d0aa, 0x1003d0ab, 0x1003d0ac, 0x1003d0ad, 0x1003d0ae, 0x1003d0af,
  0x1003d0b0, 0x1003d0b1, 0x1003d0b2, 0x1003d0b3
]

achievement(
  title = "Fish Finder Completionist",
  description = "Complete 100% of the Diving Chart in the Scuba Diving minigame",
  points = 10,
  trigger = (
    IsInGame() &&
    any_of(range(1, 8), fish =>
      sum_of(chartedStuff, addr => byte(addr + ((fish - 1) * OFFSET))) == 40 &&
      prev(sum_of(chartedStuff, addr => byte(addr + ((fish - 1) * OFFSET)))) < 40
    )
  )
)

ScoreLeaderboard("Surfing - Big Wave Ride", 0x1003c77c)
ScoreLeaderboard("Surfing - Score Trial", 0x1003c784)

CocoHS = CalculateOffsetAndReturnAddress(0x1003c788)

achievement(
  title = "Coco Collecting Champion",
  description = "Collect all 99 coconuts in the Coco Challenge minigame",
  points = 5,
  trigger = (
    IsInGame() &&
    any_of(CocoHS, addr =>
      (
        dword_be(CocoHS[addr]) >= 396 &&
        prev(dword_be(CocoHS[addr])) <= 396 &&
        dword_be(CocoHS[addr]) != 0xfffffffc
      )
      ||
      (
        dword_be(CocoHS[addr]) >= 396 && 
        prev(dword_be(CocoHS[addr])) == 0xfffffffc &&
        dword_be(CocoHS[addr]) != 0xfffffffc
      )
    )
  )
)

RankAchievement("The Best Wave Rider", "Big Wave Ride", CalculateOffsetAndReturnAddress(0x1003cba4), 4)
RankAchievement("Scoring on the Waves", "Score Trial", CalculateOffsetAndReturnAddress(0x1003cba6), 4)

ScoreLeaderboard("Water Gun Battle - Score Attack - Sunshine Beach", 0x1003c7c8)
ScoreLeaderboard("Water Gun Battle - Score Attack - Mystic Jungle", 0x1003c7cc)
ScoreLeaderboard("Water Gun Battle - Score Attack - Marinus Ruins", 0x1003c7d0)

ScoreLeaderboard("ATV Tricks - Jump Tricks", 0x1003c744)
ScoreLeaderboard("ATV Tricks - Ride & Tricks", 0x1003c748)

RankAchievement("ATV Jump Pro Trickster", "ATV Tricks Jump Tricks", CalculateOffsetAndReturnAddress(0x1003cba0), 4)
RankAchievement("ATV Ride & Trick Expert", "ATV Tricks Ride & Tricks", CalculateOffsetAndReturnAddress(0x1003cba1), 4)

ScoreLeaderboard("Marine Bike Tricks - Jump Tricks", 0x1003c74c)
ScoreLeaderboard("Marine Bike Tricks - Ride & Tricks", 0x1003c750)

RankAchievement("Professional Bike Jumper", "Marine Bike Tricks Jump Tricks", CalculateOffsetAndReturnAddress(0x1003cba2), 4)
RankAchievement("Water Gliding And Tricking", "Marine Bike Tricks Ride & Tricks", CalculateOffsetAndReturnAddress(0x1003cba3), 4)

// TimeLeaderboard("Triathlon - Stage 1", 0x1003c738)
// TimeLeaderboard("Triathlon - Stage 2", 0x1003c73c)
// TimeLeaderboard("Triathlon - Stage 3", 0x1003c740)

SpeedrunTimeAchievement("Master of Bikes, Running & Racing", "Complete Stage 3 of the Triathlon in under 2'29\"70", 5, CalculateOffsetAndReturnAddress(0x1003c740), 80664)

// TimeLeaderboard("Motor Fest - Street Race - Stage 1", 0x1003c80c)
// TimeLeaderboard("Motor Fest - Street Race - Stage 2", 0x1003c810)
// TimeLeaderboard("Motor Fest - Street Race - Stage 3", 0x1003c814)
// TimeLeaderboard("Motor Fest - Street Race - Stage 4", 0x1003c818)
// TimeLeaderboard("Motor Fest - Street Race - Stage 5", 0x1003c81c)
// TimeLeaderboard("Motor Fest - Street Race - Stage 6", 0x1003c820)
// TimeLeaderboard("Motor Fest - Street Race - Stage 7", 0x1003c824)
// TimeLeaderboard("Motor Fest - Street Race - Stage 8", 0x1003c828)
// TimeLeaderboard("Motor Fest - Street Race - Stage 9", 0x1003c82c)
// TimeLeaderboard("Motor Fest - Street Race - Stage 10", 0x1003c830)

// TimeLeaderboard("Motor Fest - Number Chaser - Stage 1", 0x1003c834)
// TimeLeaderboard("Motor Fest - Number Chaser - Stage 2", 0x1003c838)
// TimeLeaderboard("Motor Fest - Number Chaser - Stage 3", 0x1003c83c)

// TimeLeaderboard("Motor Fest - Motorcycle Race - Stage 1", 0x1003c840)
// TimeLeaderboard("Motor Fest - Motorcycle Race - Stage 2", 0x1003c844)
// TimeLeaderboard("Motor Fest - Motorcycle Race - Stage 3", 0x1003c848)

// TimeLeaderboard("Motor Fest - Motorcycle Slalom - Stage 1", 0x1003c84c)
// TimeLeaderboard("Motor Fest - Motorcycle Slalom - Stage 2", 0x1003c850)
// TimeLeaderboard("Motor Fest - Motorcycle Slalom - Stage 3", 0x1003c854)
// TimeLeaderboard("Motor Fest - Motorcycle Slalom - Stage 4", 0x1003c858)
// TimeLeaderboard("Motor Fest - Motorcycle Slalom - Stage 5", 0x1003c85c)

// TimeLeaderboard("Motor Fest - Oval Race - Stage 1", 0x1003c860)
// TimeLeaderboard("Motor Fest - Oval Race - Stage 2", 0x1003c864)
// TimeLeaderboard("Motor Fest - Oval Race - Stage 3", 0x1003c868)

SpeedrunTimeAchievement("Number Chaser Route Master 1", "Complete Stage 1 of Number Chaser in under 2'00\"00", 10, CalculateOffsetAndReturnAddress(0x1003c834), 63376)
SpeedrunTimeAchievement("Number Chaser Route Master 2", "Complete Stage 2 of Number Chaser in under 1'26\"00", 10, CalculateOffsetAndReturnAddress(0x1003c838), 45970)
SpeedrunTimeAchievement("Number Chaser Route Master 3", "Complete Stage 3 of Number Chaser in under 2'45\"60", 10, CalculateOffsetAndReturnAddress(0x1003c83c), 88816)

ScoreLeaderboard("Dance - Colorful Life - Level 1", 0x1003c8f8, 2.5)
ScoreLeaderboard("Dance - Colorful Life - Level 2", 0x1003c8fc, 2.5)
ScoreLeaderboard("Dance - Colorful Life - Level 3", 0x1003c900, 2.5)

ScoreLeaderboard("Dance - Kung-Fu Traveller - Level 1", 0x1003c904, 2.5)
ScoreLeaderboard("Dance - Kung-Fu Traveller - Level 2", 0x1003c908, 2.5)
ScoreLeaderboard("Dance - Kung-Fu Traveller - Level 3", 0x1003c90c, 2.5)

ScoreLeaderboard("Dance - Twilight Rock - Level 1", 0x1003c910, 2.5)
ScoreLeaderboard("Dance - Twilight Rock - Level 2", 0x1003c914, 2.5)
ScoreLeaderboard("Dance - Twilight Rock - Level 3", 0x1003c918, 2.5)

ScoreLeaderboard("Dance - Miles of Smiles - Level 1", 0x1003c91c, 2.5)
ScoreLeaderboard("Dance - Miles of Smiles - Level 2", 0x1003c920, 2.5)
ScoreLeaderboard("Dance - Miles of Smiles - Level 3", 0x1003c924, 2.5)

ScoreLeaderboard("Dance - Dance Floor King - Level 1", 0x1003c928, 2.5)
ScoreLeaderboard("Dance - Dance Floor King - Level 2", 0x1003c92c, 2.5)
ScoreLeaderboard("Dance - Dance Floor King - Level 3", 0x1003c930, 2.5)

Level1Dance = [
  0x1003ccc7, 0x1003ccca, 0x1003cccd,
  0x1003ccd0, 0x1003ccd3
]

Level2Dance = [
  0x1003ccc8, 0x1003cccb, 0x1003ccce,
  0x1003ccd1, 0x1003ccd4
]

Level3Dance = [
  0x1003ccc9, 0x1003cccc, 0x1003cccf,
  0x1003ccd2, 0x1003ccd5
]

achievement(
  title = "Getting into the Groove",
  description = "Complete all of the songs in the Dance minigame on level 1 difficulty",
  points = 3,
  trigger = (
    IsInGame() &&
    any_of(range(1, 8), dance =>
      sum_of(Level1Dance, addr => byte(addr + ((dance - 1) * OFFSET))) == 5 &&
      prev(sum_of(Level1Dance, addr => byte(addr + ((dance - 1) * OFFSET)))) < 5
    )
  )
)

achievement(
  title = "Boogie Down",
  description = "Complete all of the songs in the Dance minigame on level 2 difficulty",
  points = 5,
  trigger = (
    IsInGame() &&
    any_of(range(1, 8), dance =>
      sum_of(Level2Dance, addr => byte(addr + ((dance - 1) * OFFSET))) == 5 &&
      prev(sum_of(Level2Dance, addr => byte(addr + ((dance - 1) * OFFSET)))) < 5
    )
  )
)

achievement(
  title = "Dancing Prodigy",
  description = "Complete all of the songs in the Dance minigame on level 3 difficulty",
  points = 10,
  trigger = (
    IsInGame() &&
    any_of(range(1, 8), dance =>
      sum_of(Level3Dance, addr => byte(addr + ((dance - 1) * OFFSET))) == 5 &&
      prev(sum_of(Level3Dance, addr => byte(addr + ((dance - 1) * OFFSET)))) < 5
    )
  )
)

ScoreAchievement("Can't Pie Me!", "Score over 100 points in Level 1 of the \"Pie Throwing\" minigame in the \"Dodge Fest\" mode", 5, CalculateOffsetAndReturnAddress(0x1003c8e8), 400)

// TimeLeaderboard("Hang Gliding - Balloon Buster - Stage 1", 0x1003c834)
// TimeLeaderboard("Hang Gliding - Balloon Buster - Stage 2", 0x1003c870)
// TimeLeaderboard("Hang Gliding - Balloon Buster - Stage 3", 0x1003c874)
// TimeLeaderboard("Hang Gliding - Balloon Buster - Stage 4", 0x1003c878)
// TimeLeaderboard("Hang Gliding - Balloon Buster - Stage 5", 0x1003c87c)

ScoreLeaderboard("Hang Gliding - Flying Hoops - Stage 1", 0x1003c880)
ScoreLeaderboard("Hang Gliding - Flying Hoops - Stage 2", 0x1003c884)
ScoreLeaderboard("Hang Gliding - Flying Hoops - Stage 3", 0x1003c888)
ScoreLeaderboard("Hang Gliding - Flying Hoops - Stage 4", 0x1003c88c)
ScoreLeaderboard("Hang Gliding - Flying Hoops - Stage 5", 0x1003c890)

// TimeLeaderboard("Wheel Slider - Stage 1", 0x1003c7fc)
// TimeLeaderboard("Wheel Slider - Stage 2", 0x1003c800)
// TimeLeaderboard("Wheel Slider - Stage 3", 0x1003c804)

Level1Glass = [
  0x1003c934, 0x1003c940, 0x1003c94c,
  0x1003c958, 0x1003c964
]

Level2Glass = [
  0x1003c938, 0x1003c944, 0x1003c950,
  0x1003c958, 0x1003c964
]

Level3Glass = [
  0x1003c93c, 0x1003c948, 0x1003c954,
  0x1003c958, 0x1003c964
]

achievement(
  title = "Glass Beginner",
  description = "Reach Pro rank on all of the songs on Level 1 difficulty in the \"Glass Harp\" minigame",
  points = 3,
  trigger = (
    IsInGame() &&
    any_of(range(1, 8), glass =>
      all_of(Level1Glass, addr => dword_be(addr + ((glass - 1) * OFFSET)) >= 0x08) &&
      prev(any_of(Level1Glass, addr => dword_be(addr + ((glass - 1) * OFFSET)) != 0x08))
    )
  )
)

achievement(
  title = "Glass Harmony",
  description = "Reach Pro rank on all of the songs on Level 2 difficulty in the \"Glass Harp\" minigame",
  points = 5,
  trigger = (
    IsInGame() &&
    any_of(range(1, 8), glass =>
      all_of(Level2Glass, addr => dword_be(addr + ((glass - 1) * OFFSET)) >= 0x08) &&
      prev(any_of(Level2Glass, addr => dword_be(addr + ((glass - 1) * OFFSET)) != 0x08))
    )
  )
)

achievement(
  title = "The Master of Glass",
  description = "Reach Pro rank on all of the songs on Level 3 difficulty in the \"Glass Harp\" minigame",
  points = 10,
  trigger = (
    IsInGame() &&
    any_of(range(1, 8), glass =>
      all_of(Level3Glass, addr => dword_be(addr + ((glass - 1) * OFFSET)) >= 0x08) &&
      prev(any_of(Level3Glass, addr => dword_be(addr + ((glass - 1) * OFFSET)) != 0x08))
    )
  )
)

ScoreLeaderboard("Skate Tricks - Park Tricks", 0x1003c7d8)
ScoreLeaderboard("Skate Tricks - Street Tricks - Stage 1", 0x1003c7dc)
ScoreLeaderboard("Skate Tricks - Street Tricks - Stage 2", 0x1003c7e0)
ScoreLeaderboard("Skate Tricks - Street Tricks - Stage 3", 0x1003c7e4)
ScoreLeaderboard("Skate Tricks - Street Tricks - Stage 4", 0x1003c7e8)
ScoreLeaderboard("Skate Tricks - Street Tricks - Stage 5", 0x1003c7ec)

RankAchievement("Becoming Tony Hawk", "Skate Tricks Park Tricks", CalculateOffsetAndReturnAddress(0x1003cba8), 0x04)

ScoreLeaderboard("Grind Master - Stage 1", 0x1003c7f0, 136)
ScoreLeaderboard("Grind Master - Stage 2", 0x1003c7f0, 136)
ScoreLeaderboard("Grind Master - Stage 3", 0x1003c7f0, 136)

ScoreAchievement("Grinding Along", "Reach over 2200ft on Stage 2 in the \"Grind Master\" minigame", 5, CalculateOffsetAndReturnAddress(0x1003c7f4), 293336)

ScoreLeaderboard("Mole Panic - Level 1", 0x1003c8cc)
ScoreLeaderboard("Mole Panic - Level 2", 0x1003c8d0)
ScoreLeaderboard("Mole Panic - Level 3", 0x1003c8d4)

ScoreLeaderboard("Power Hitter - Level 1", 0x1003c8a8)
ScoreLeaderboard("Power Hitter - Level 2", 0x1003c8ac)
ScoreLeaderboard("Power Hitter - Level 3", 0x1003c8b0)

ScoreLeaderboard("Bucket Ball - Level 1", 0x1003c8d8)
ScoreLeaderboard("Bucket Ball - Level 2", 0x1003c8dc)
ScoreLeaderboard("Bucket Ball - Level 3", 0x1003c8e0)

ScoreLeaderboard("Power Boxer - Level 1", 0x1003c8c0)
ScoreLeaderboard("Power Boxer - Level 2", 0x1003c8c4)
ScoreLeaderboard("Power Boxer - Level 3", 0x1003c8c8)

ScoreLeaderboard("Halfpipe - Halfpipe Tricks", 0x1003c808)
RankAchievement("Halfpipe Master", "Halfpipe Tricks", CalculateOffsetAndReturnAddress(0x1003cba9), 0x04)

// TimeLeaderboard("Snowball Fight - Defend the Flag - Level 1", 0x1003cb30, false)
// TimeLeaderboard("Snowball Fight - Defend the Flag - Level 2", 0x1003cb34, false)
// TimeLeaderboard("Snowball Fight - Defend the Flag - Level 3", 0x1003cb38, false)

// TimeLeaderboard("Dog Sled - Beginner Stage", 0x1003cb20)
// TimeLeaderboard("Dog Sled - Intermediate Stage", 0x1003cb24)
// TimeLeaderboard("Dog Sled - Advanced Stage", 0x1003cb28)

SpeedrunTimeAchievement("Advanced Dog Sledder", "Complete the Advanced Dog Sled stage in under 2'00\"20", 10, CalculateOffsetAndReturnAddress(0x1003cb28), 63570)

// TimeLeaderboard("Snow Races - Sprint Race - Stage 1", 0x1003ca88)
// TimeLeaderboard("Snow Races - Sprint Race - Stage 2", 0x1003ca8c)
// TimeLeaderboard("Snow Races - Sprint Race - Stage 3", 0x1003ca90)
// TimeLeaderboard("Snow Races - Sprint Race - Stage 4", 0x1003ca94)
// TimeLeaderboard("Snow Races - Sprint Race - Stage 5", 0x1003ca98)

// TimeLeaderboard("Snow Races - Slalom Race - Stage 1", 0x1003ca9c)
// TimeLeaderboard("Snow Races - Slalom Race - Stage 2", 0x1003caa0)
// TimeLeaderboard("Snow Races - Slalom Race - Stage 3", 0x1003caa4)
// TimeLeaderboard("Snow Races - Slalom Race - Stage 4", 0x1003caa8)
// TimeLeaderboard("Snow Races - Slalom Race - Stage 5", 0x1003caac)

// TimeLeaderboard("Snow Tubing - Sprint Race - Stage 1", 0x1003caf8)
// TimeLeaderboard("Snow Tubing - Sprint Race - Stage 2", 0x1003cafc)
// TimeLeaderboard("Snow Tubing - Sprint Race - Stage 3", 0x1003cb00)
// TimeLeaderboard("Snow Tubing - Sprint Race - Stage 4", 0x1003cb04)
// TimeLeaderboard("Snow Tubing - Sprint Race - Stage 5", 0x1003cb08)

ScoreLeaderboard("Snow Tubing - Tube Bowling - Stage 1", 0x1003cb0c)
ScoreLeaderboard("Snow Tubing - Tube Bowling - Stage 2", 0x1003cb10)
ScoreLeaderboard("Snow Tubing - Tube Bowling - Stage 3", 0x1003cb14)
ScoreLeaderboard("Snow Tubing - Tube Bowling - Stage 4", 0x1003cb18)
ScoreLeaderboard("Snow Tubing - Tube Bowling - Stage 5", 0x1003cb1c)

BowlingLevels = [
  0x1003cb0c, 0x1003cb10, 0x1003cb14,
  0x1003cb18, 0x1003cb1c
]

achievement(
  title = "Bowling Pro",
  description = "Reach a total score of 240 or higher across all 5 bowling stages in the \"Snow Tubing\" minigame",
  points = 10,
  trigger = (
    IsInGame() &&
      any_of(range(1, 8), bowl =>
      all_of(BowlingLevels, addr => dword_be(addr + ((bowl - 1) * OFFSET)) != 0xfffffffc) &&
      sum_of(BowlingLevels, addr => dword_be(addr + ((bowl - 1) * OFFSET))) >= 960
    )
  )
)

// TimeLeaderboard("Snowmobile Races - Sprint Race - Stage 1", 0x1003cabc)
// TimeLeaderboard("Snowmobile Races - Sprint Race - Stage 2", 0x1003cac0)
// TimeLeaderboard("Snowmobile Races - Sprint Race - Stage 3", 0x1003cac4)
// TimeLeaderboard("Snowmobile Races - Sprint Race - Stage 4", 0x1003cac8)
// TimeLeaderboard("Snowmobile Races - Sprint Race - Stage 5", 0x1003cacc)

// TimeLeaderboard("Snowmobile Races - Circuit Race - Stage 1", 0x1003cad0)
// TimeLeaderboard("Snowmobile Races - Circuit Race - Stage 2", 0x1003cad4)
// TimeLeaderboard("Snowmobile Races - Circuit Race - Stage 3", 0x1003cad8)
// TimeLeaderboard("Snowmobile Races - Circuit Race - Stage 4", 0x1003cadc)
// TimeLeaderboard("Snowmobile Races - Circuit Race - Stage 5", 0x1003cae0)

// TimeLeaderboard("Snowmobile Races - Open Race - Stage 1", 0x1003cae4)
// TimeLeaderboard("Snowmobile Races - Open Race - Stage 2", 0x1003cae8)
// TimeLeaderboard("Snowmobile Races - Open Race - Stage 3", 0x1003caec)
// TimeLeaderboard("Snowmobile Races - Open Race - Stage 4", 0x1003caf0)

// open race challenges
SpeedrunTimeAchievement("Snowmobile Speeder 1", "Complete Stage 1 of the Snowmobile Open Race in under 1'10\"00", 10, CalculateOffsetAndReturnAddress(0x1003cae4), 37778)
SpeedrunTimeAchievement("Snowmobile Speeder 2", "Complete Stage 2 of the Snowmobile Open Race in under 1'13\"90", 10, CalculateOffsetAndReturnAddress(0x1003cae8), 39784)
SpeedrunTimeAchievement("Snowmobile Speeder 3", "Complete Stage 3 of the Snowmobile Open Race in under 2'06\"00", 10, CalculateOffsetAndReturnAddress(0x1003caec), 68496)
SpeedrunTimeAchievement("Snowmobile Speeder 4", "Complete Stage 4 of the Snowmobile Open Race in under 2'21\"50", 10, CalculateOffsetAndReturnAddress(0x1003caf0), 76488)
SpeedrunTimeAchievement("Snowmobile Speeder 5", "Complete Stage 5 of the Snowmobile Open Race in under 2'27\"80", 10, CalculateOffsetAndReturnAddress(0x1003caf4), 79682)

ScoreLeaderboard("Mogul", 0x1003cab8)

ScoreLeaderboard("Snow Tricks - Halfpipe Tricks", 0x1003cab4)
ScoreLeaderboard("Snow Tricks - Slopestyle", 0x1003cab8)

RankAchievement("Snowy Halfpipe Hero", "Snow Tricks Halfpipe Tricks", CalculateOffsetAndReturnAddress(0x1003cbab), 0x04)
RankAchievement("Skilful Slopestyle Snow Trickster", "Snow Tricks Slopestyle", CalculateOffsetAndReturnAddress(0x1003cbaa), 0x04)

// TimeLeaderboard("Horseback Riding - Sprint Race - Level 1", 0x1003c9c4)
// TimeLeaderboard("Horseback Riding - Sprint Race - Level 2", 0x1003c9c8)
// TimeLeaderboard("Horseback Riding - Sprint Race - Level 3", 0x1003c9cc)
// TimeLeaderboard("Horseback Riding - Sprint Race - Level 4", 0x1003c9d0)
// TimeLeaderboard("Horseback Riding - Sprint Race - Level 5", 0x1003c9d4)

ScoreLeaderboard("Horseback Riding - Coin Collect - Level 1", 0x1003c9d8)
ScoreLeaderboard("Horseback Riding - Coin Collect - Level 2", 0x1003c9dc)
ScoreLeaderboard("Horseback Riding - Coin Collect - Level 3", 0x1003c9e0)
ScoreLeaderboard("Horseback Riding - Coin Collect - Level 4", 0x1003c9e4)
ScoreLeaderboard("Horseback Riding - Coin Collect - Level 5", 0x1003c9e8)

// horseback achievements
SpeedrunTimeAchievement("Galloping to Glory", "Complete Stage 2 of the Horseback Riding Sprint Race in under 1'14\"50", 5, CalculateOffsetAndReturnAddress(0x1003c9c8), 40138)
ScoreAchievement("Gold Collecting Horse", "Collect every coin on Stage 1 of the Horseback Riding Coin Collector minigame", 5, CalculateOffsetAndReturnAddress(0x1003c9d8), 2680)


// TimeLeaderboard("Paragliding - Balloon Buster - Level 1", 0x1003ca20)
// TimeLeaderboard("Paragliding - Balloon Buster - Level 2", 0x1003ca24)
// TimeLeaderboard("Paragliding - Balloon Buster - Level 3", 0x1003ca28)
// TimeLeaderboard("Paragliding - Balloon Buster - Level 4", 0x1003ca2c)
// TimeLeaderboard("Paragliding - Balloon Buster - Level 5", 0x1003ca30)

ScoreLeaderboard("Paragliding - Aimed Flight - Level 1", 0x1003ca34)
ScoreLeaderboard("Paragliding - Aimed Flight - Level 2", 0x1003ca38)
ScoreLeaderboard("Paragliding - Aimed Flight - Level 3", 0x1003ca3c)
ScoreLeaderboard("Paragliding - Aimed Flight - Level 4", 0x1003ca40)
ScoreLeaderboard("Paragliding - Aimed Flight - Level 5", 0x1003ca44)

// TimeLeaderboard("Kayaking - River Race - Stage 1", 0x1003c988)
// TimeLeaderboard("Kayaking - River Race - Stage 2", 0x1003c988)
// TimeLeaderboard("Kayaking - River Race - Stage 3", 0x1003c988)
// TimeLeaderboard("Kayaking - River Race - Stage 4", 0x1003c988)
// TimeLeaderboard("Kayaking - River Race - Stage 5", 0x1003c988)

// TimeLeaderboard("Kayaking - River Slalom - Stage 1", 0x1003c99c)
// TimeLeaderboard("Kayaking - River Slalom - Stage 2", 0x1003c9a0)
// TimeLeaderboard("Kayaking - River Slalom - Stage 3", 0x1003c9a4)
// TimeLeaderboard("Kayaking - River Slalom - Stage 4", 0x1003c9a8)
// TimeLeaderboard("Kayaking - River Slalom - Stage 5", 0x1003c9ac)

ScoreLeaderboard("Kayaking - Coin Collect - Stage 1", 0x1003c9b0)
ScoreLeaderboard("Kayaking - Coin Collect - Stage 2", 0x1003c9b4)
ScoreLeaderboard("Kayaking - Coin Collect - Stage 3", 0x1003c9b8)
ScoreLeaderboard("Kayaking - Coin Collect - Stage 4", 0x1003c9bc)
ScoreLeaderboard("Kayaking - Coin Collect - Stage 5", 0x1003c9c0)

// TimeLeaderboard("Off-Road Racing - Open Race - Stage 1", 0x1003c9ec)
// TimeLeaderboard("Off-Road Racing - Open Race - Stage 2", 0x1003c9f0)
// TimeLeaderboard("Off-Road Racing - Open Race - Stage 3", 0x1003c9f4)

// TimeLeaderboard("Off-Road Racing - Rally Car - Stage 1", 0x1003c9f8)
// TimeLeaderboard("Off-Road Racing - Rally Car - Stage 2", 0x1003c9fc)
// TimeLeaderboard("Off-Road Racing - Rally Car - Stage 3", 0x1003ca00)
// TimeLeaderboard("Off-Road Racing - Rally Car - Stage 4", 0x1003ca04)
// TimeLeaderboard("Off-Road Racing - Rally Car - Stage 5", 0x1003ca08)
// TimeLeaderboard("Off-Road Racing - Rally Car - Stage 6", 0x1003ca0c)
// TimeLeaderboard("Off-Road Racing - Rally Car - Stage 7", 0x1003ca10)
// TimeLeaderboard("Off-Road Racing - Rally Car - Stage 8", 0x1003ca14)
// TimeLeaderboard("Off-Road Racing - Rally Car - Stage 9", 0x1003ca18)
// TimeLeaderboard("Off-Road Racing - Rally Car - Stage 10", 0x1003ca1c)

// off road racing open races
SpeedrunTimeAchievement("Off-Road Rush 1", "Complete Stage 1 of the Off-Road Racing Open Race in under 0'58\"50", 10, CalculateOffsetAndReturnAddress(0x1003c9ec), 29898)
SpeedrunTimeAchievement("Off-Road Rush 2", "Complete Stage 2 of the Off-Road Racing Open Race in under 0'54\"70", 10, CalculateOffsetAndReturnAddress(0x1003c9f0), 27928)
SpeedrunTimeAchievement("Off-Road Rush 3", "Complete Stage 3 of the Off-Road Racing Open Race in under 1'53\"20", 10, CalculateOffsetAndReturnAddress(0x1003c9f4), 59872)

// TimeLeaderboard("Rafting - Stage 1", 0x1003ca48)
// TimeLeaderboard("Rafting - Stage 2", 0x1003ca4c)
// TimeLeaderboard("Rafting - Stage 3", 0x1003ca50)

// TimeLeaderboard("Target Shooting - Level 1", 0x1003ca60)
// TimeLeaderboard("Target Shooting - Level 2", 0x1003ca64)
// TimeLeaderboard("Target Shooting - Level 3", 0x1003ca68)

//target shooting achievement?

ScoreLeaderboard("Clay Shooting - Short", 0x1003ca54)
ScoreLeaderboard("Clay Shooting - Middle", 0x1003ca58)
ScoreLeaderboard("Clay Shooting - Long", 0x1003ca5c)

// clay shooting achievement?
// TimeLeaderboard("Rifle Shooting - Level 1", 0x1003ca78)
// TimeLeaderboard("Rifle Shooting - Level 2", 0x1003ca7c)
// TimeLeaderboard("Rifle Shooting - Level 3", 0x1003ca80)

//rifle shooting achievement?