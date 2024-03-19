// Transformers: The Game
// #ID = 21166

CurrentLevel = byte(0x00503c24)
ChapterCompleteShowing = byte(0x00c29f9c)

// ============= Progression =============

function ChapterComplete(achTitle, achDesc, points, achType, levelId, chaptersCompleteId, chaptersComplete)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        type = achType,
        trigger = (
            CurrentLevel == levelId &&
            chaptersCompleteId == chaptersComplete &&
            prev(chaptersCompleteId) == chaptersComplete - 1
        )
    )
}

function FinalLevelComplete(achTitle, achDesc, points, achType, levelId)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        type = achType,
        trigger = (
            CurrentLevel == levelId &&
            ChapterCompleteShowing == 0x01 &&
            prev(ChapterCompleteShowing) == 0x00
        )
    )
}

// Autobot missions
ChapterComplete("The Decepticons Have Arrived", "Complete mission \"Uninvited Guests\"", 4, "PROGRESSION", 0x00, byte(0x00cfaf89), 1)
ChapterComplete("Chasing Down Decepticons", "Complete mission \"Guardian Angel\"", 4, "PROGRESSION", 0x00, byte(0x00cfaf89), 2)
ChapterComplete("Sound of the Police", "Complete mission \"Protect and Serve\"", 4, "PROGRESSION", 0x00, byte(0x00cfaf89), 3)
ChapterComplete("More Decepticons!", "Complete mission \"Air Traffic Control\"", 4, "PROGRESSION", 0x00, byte(0x00cfaf89), 4)

ChapterComplete("Jazz the Distractor", "Complete mission \"Obstruction of Justice\"", 4, "PROGRESSION", 0x01, byte(0x00d021b9), 1)
ChapterComplete("Protecting Jazz", "Complete mission \"A Friend in Need\"", 4, "PROGRESSION", 0x01, byte(0x00d021b9), 2)
ChapterComplete("The Bumblebee Chase", "Complete mission \"Flight of the Bumblebee\"", 4, "PROGRESSION", 0x01, byte(0x00d021b9), 3)
ChapterComplete("Destroying Shockwave", "Complete mission \"Heavy Weapon\"", 4, "PROGRESSION", 0x01, byte(0x00d021b9), 4)

ChapterComplete("I Want to Break Free!", "Complete mission \"Breakout\"", 4, "PROGRESSION", 0x02, byte(0x00d01509), 1)
ChapterComplete("Tunnel Speedster", "Complete mission \"Tunnel Vision\"", 4, "PROGRESSION", 0x02, byte(0x00d01509), 2)
ChapterComplete("Generator Destroyer", "Complete mission \"Power Drain\"", 4, "PROGRESSION", 0x02, byte(0x00d01509), 3)
ChapterComplete("Securing the AllSpark", "Complete mission \"Waking Giant\"", 4, "PROGRESSION", 0x02, byte(0x00d01509), 4)

ChapterComplete("Energon Drones? More Like Energone Drones", "Complete mission \"Exterminator\"", 4, "PROGRESSION", 0x04, byte(0x00cffba9), 1)
ChapterComplete("You're Grounded!", "Complete mission \"Unfriendly Skies\"", 4, "PROGRESSION", 0x04, byte(0x00cffba9), 2)
ChapterComplete("Brawling Brawl", "Complete mission \"For The Fallen\"", 4, "PROGRESSION", 0x04, byte(0x00cffba9), 3)
ChapterComplete("Protecting The AllSpark", "Complete mission \"Keep Away\"", 4, "PROGRESSION", 0x04, byte(0x00cffba9), 4)

FinalLevelComplete("Taking Down Megatron", "Complete level \"The Ultimate Doom\"", 10, "PROGRESSION", 0x05)
FinalLevelComplete("Decepticon Battler", "Complete level \"Cybertron: Autobot\"", 4, "", 0x11)

// Decepticon missions
ChapterComplete("Destroying the Airbase", "Complete mission \"Sand Storm\"", 4, "PROGRESSION", 0x06, byte(0x00cfe249), 1)
ChapterComplete("Sabotaging the Comms", "Complete mission \"Communications Breakdown\"", 4, "PROGRESSION", 0x06, byte(0x00cfe249), 2)
ChapterComplete("Data Downloader", "Complete mission \"Seek and Destroy\"", 4, "PROGRESSION", 0x06, byte(0x00cfe249), 3)
ChapterComplete("Jet Takedown", "Complete mission \"Fire In The Sky\"", 4, "PROGRESSION", 0x06, byte(0x00cfe249), 4)

ChapterComplete("Hunting for Sam Witwicky", "Complete mission \"Rough Justice\"", 4, "PROGRESSION", 0x07, byte(0x00cfbc39), 1)
ChapterComplete("Destruction for Frenzy", "Complete mission \"Race For Frenzy\"", 4, "PROGRESSION", 0x07, byte(0x00cfbc39), 2)
ChapterComplete("Chasing the Bee", "Complete mission \"Pursuit\"", 4, "PROGRESSION", 0x07, byte(0x00cfbc39), 3)
ChapterComplete("Bumblebee Down", "Complete mission \"Plight of the Bumblebee\"", 4, "PROGRESSION", 0x07, byte(0x00cfbc39), 4)

ChapterComplete("No More Radio", "Complete mission \"Clearing The Air\"", 4, "PROGRESSION", 0x08, byte(0x00d00859), 1)
ChapterComplete("Crushing Their Bones", "Complete mission \"Sinister Savior\"", 4, "PROGRESSION", 0x08, byte(0x00d00859), 2)
ChapterComplete("Plane Destruction", "Complete mission \"Fireworks\"", 4, "PROGRESSION", 0x08, byte(0x00d00859), 3)
ChapterComplete("On the Warpath", "Complete mission \"Warpath\"", 4, "PROGRESSION", 0x08, byte(0x00d00859), 4)

ChapterComplete("Removing the Jazz Spark", "Complete mission \"Nowhere To Run\"", 4, "PROGRESSION", 0x0a, byte(0x00d03b19), 1)
ChapterComplete("The Drone Army", "Complete mission \"Energon Overload\"", 4, "PROGRESSION", 0x0a, byte(0x00d03b19), 2)
ChapterComplete("The Mighty Has Fallen", "Complete mission \"The Mighty Will Fall\"", 4, "PROGRESSION", 0x0a, byte(0x00d03b19), 3)
ChapterComplete("Tearing Down the City", "Complete mission \"Devastation\"", 4, "PROGRESSION", 0x0a, byte(0x00d03b19), 4)

FinalLevelComplete("Optimus Not So Prime", "Complete mission \"Day of the Machines\"", 10, "WIN_CONDITION", 0x0b)
FinalLevelComplete("Autobot Battler", "Complete mission \"Cybertron: Decepticon\"", 4, "", 0x12)

function ChallengesComplete(achTitle, achDesc, points, levelId, challengesComplete)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            CurrentLevel == levelId &&
            challengesComplete == 8 &&
            prev(challengesComplete) != 8 &&
            prev(challengesComplete) != 0
        )
    )
}

// Autobot
ChallengesComplete("", "Complete all 4 challenges in \"The Suburbs\"", 0x00, bitcount(0xcfafb0))
ChallengesComplete("", "Complete all 4 challenges in \"More Than Meets the Eye\"", 0x01, bitcount(0xd021e0))
ChallengesComplete("", "Complete all 4 challenges in \"Inside Hoover Dam\"", 0x02, bitcount(0xd01530))
ChallengesComplete("", "Complete all 4 challenges in \"The Last Stand\"", 0x04, bitcount(0xcffbd0))

// Decepticon
ChallengesComplete("", "Complete all 4 challenges in \"SOCCENT Military Base\"", 0x06, bitcount(0xcfe270))
ChallengesComplete("", "Complete all 4 challenges in \"The Hunt for Sam Witwicky\"", 0x07, bitcount(0xcfbc60))
ChallengesComplete("", "Complete all 4 challenges in \"A Gathering Force\"", 0x08, bitcount(0xd00880))
ChallengesComplete("", "Complete all 4 challenges in \"City of the Machines\"", 0x0a, bitcount(0xd03b40))

// ============= Collectibles =============
AutobotMasks = bitcount(0xcfae50) + bitcount(0xcffa70) + bitcount(0xd013d0) + bitcount(0xd02080)
DecepticonMasks = bitcount(0xcfbb00) + bitcount(0xcfe110) + bitcount(0xd00720) + bitcount(0xd039e0)

function TransformersSymbolsComplete(achTitle, achDesc, points, masksCollected, maskAmount)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            CurrentLevel != 0x0f &&
            masksCollected == maskAmount &&
            prev(masksCollected) == maskAmount - 1
        )
    )
}

TransformersSymbolsComplete("", "Collect half of the transformers symbols across the Autobot levels", 5, AutobotMasks, 10)
TransformersSymbolsComplete("", "Collect all of the transformers symbols in the Autobot levels", 10, AutobotMasks, 20)
TransformersSymbolsComplete("", "Collect half of the transformers symbols across the Decepticons levels", 5, DecepticonMasks, 10)
TransformersSymbolsComplete("", "Collect all of the transformers symbols across the Decepticons levels", 10, DecepticonMasks, 20)

function CubesCollected(achTitle, achDesc, points, levelId, cubeAmount)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            CurrentLevel == levelId &&
            byte() == cubeAmount &&
            byte() == cubeAmount - 1
        )
    )
}

CubesCollected("", "Collect half of the energon cubes in \"The Suburbs\"", 5, 50)
CubesCollected("", "Collect all of the energon cubes in \"The Suburbs\"", 10, 100)
CubesCollected("", "Collect half of the energon cubes in \"More Than Meets the Eye\"", 5, 50)
CubesCollected("", "Collect all of the energon cubes in \"More Than Meets the Eye\"", 10, 100)
CubesCollected("", "Collect half of the energon cubes in \"Inside Hoover Dam\"", 5, 50)
CubesCollected("", "Collect all of the energon cubes in \"Inside Hoover Dam\"", 10, 100)
CubesCollected("", "Collect half of the energon cubes in \"The Last Stand\"", 5, 50)
CubesCollected("", "Collect all of the energon cubes in \"The Last Stand\"", 10, 100)

CubesCollected("", "Collect half of the energon cubes in \"SOCCENT Military Base\"", 5, 50)
CubesCollected("", "Collect all of the energon cubes in \"SOCCENT Military Base\"", 10, 100)
CubesCollected("", "Collect half of the energon cubes in \"The Hunt for Sam Witwicky\"", 5, 50)
CubesCollected("", "Collect all of the energon cubes in \"The Hunt for Sam Witwicky\"", 10, 100)
CubesCollected("", "Collect half of the energon cubes in \"A Gathering Force\"", 5, 50)
CubesCollected("", "Collect all of the energon cubes in \"A Gathering Force\"", 10, 100)
CubesCollected("", "Collect half of the energon cubes in \"City of the Machines\"", 5, 50)
CubesCollected("", "Collect all of the energon cubes in \"City of the Machines\"", 10, 100)

AutobotSkills = 
byte(0xcfadbc) + byte(0xcfadc0) + byte(0xcfadc4) + byte(0xcfadc8) + byte(0xcfadd0) + 
byte(0xcff9dc) + byte(0xcff9e0) + byte(0xcff9e4) + byte(0xcff9e8) + byte(0xcff9f0) + 
byte(0xd0133c) + byte(0xd01340) + byte(0xd01344) + byte(0xd01348) + byte(0xd01350) +
byte(0xd01fec) + byte(0xd01ff0) + byte(0xd01ff4) + byte(0xd01ff8) + byte(0xd02000) + 
byte(0xd052ac) + byte(0xd052b0) + byte(0xd052b4) + byte(0xd052b8) + byte(0xd052c0) 

DecepticonSkills = 
byte(0xcfba6c) + byte(0xcfba70) + byte(0xcfba74) + byte(0xcfba78) + byte(0xcfba7c) + byte(0xcfba80) + 
byte(0xcfe088) + byte(0xcfe08c) + byte(0xcfe090) +
byte(0xd00698) + byte(0xd0069c) + byte(0xd006a0) + 
byte(0xd0394c) + byte(0xd03950) + byte(0xd03954) + byte(0xd03958) + byte(0xd0395c) + byte(0xd03960) + 
byte(0xd05f68) + byte(0xd05f6c) + byte(0xd05f70)

function SkillsComplete(achTitle, achDesc, points, skillsDone, skillsCount)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            CurrentLevel != 0x0f &&
			skillsDone == skillsCount &&
			prev(skillsDone) > skillsCount
        )
    )
}