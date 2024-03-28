// Transformers: The Game
// #ID = 21166

CurrentLevel = byte(0x00503c24)
LoadedIntoChapter = byte(dword(0x004a2a50) + 0x3e8)
LastLoadedChapterNum = byte(0x0055716c)
ChapterCompleteShowing = byte(0x00c29f9c)
function CheatCheck() => bit0(0x0052210c) + bit2(0x0052210c) + bit3(0x0052210c) == 0x00

// ============= Progression =============

function ChapterComplete(achTitle, achDesc, points, achType, levelId, chaptersCompleteId, chaptersComplete)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        type = achType,
        trigger = (
            CheatCheck() &&
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
            CheatCheck() &&
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
            CheatCheck() &&
            CurrentLevel == levelId &&
            challengesComplete == 8 &&
            prev(challengesComplete) != 8 &&
            prev(challengesComplete) != 0
        )
    )
}

// Autobot
ChallengesComplete("Suburb Sub Mission Master", "Complete all 4 challenges in \"The Suburbs\"", 10, 0x00, bitcount(0xcfafb0))
ChallengesComplete("More Than Meets the Sub Mission", "Complete all 4 challenges in \"More Than Meets the Eye\"", 10, 0x01, bitcount(0xd021e0))
ChallengesComplete("Inside Sub Mission Dam", "Complete all 4 challenges in \"Inside Hoover Dam\"", 10, 0x02, bitcount(0xd01530))
ChallengesComplete("The Last Sub Mission", "Complete all 4 challenges in \"The Last Stand\"", 10, 0x04, bitcount(0xcffbd0))

// Decepticon
ChallengesComplete("SOCCENT Sub Mission Military Base", "Complete all 4 challenges in \"SOCCENT Military Base\"", 10, 0x06, bitcount(0xcfe270))
ChallengesComplete("The Hunt for the Sub Missions", "Complete all 4 challenges in \"The Hunt for Sam Witwicky\"", 10, 0x07, bitcount(0xcfbc60))
ChallengesComplete("A Gathering Sub Mission", "Complete all 4 challenges in \"A Gathering Force\"", 10, 0x08, bitcount(0xd00880))
ChallengesComplete("City of the Sub Missions", "Complete all 4 challenges in \"City of the Machines\"", 10, 0x0a, bitcount(0xd03b40))

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
            CheatCheck() &&
            CurrentLevel != 0x0f &&
            masksCollected == maskAmount &&
            prev(masksCollected) == maskAmount - 1
        )
    )
}

TransformersSymbolsComplete("Unlocking Autobot Bonus Content", "Collect half of the transformers symbols across the Autobot levels", 5, AutobotMasks, 10)
TransformersSymbolsComplete("Collector of the Autobot Symbols", "Collect all of the transformers symbols in the Autobot levels", 10, AutobotMasks, 20)
TransformersSymbolsComplete("Evil Bonus Content Unlocked", "Collect half of the transformers symbols across the Decepticons levels", 5, DecepticonMasks, 10)
TransformersSymbolsComplete("The Ultimate Evil Symbol Collector", "Collect all of the transformers symbols across the Decepticons levels", 10, DecepticonMasks, 20)

function CubesCollected(achTitle, achDesc, points, levelId, cubeAmount)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            CheatCheck() &&
            CurrentLevel == levelId &&
            byte(0x00557048) == cubeAmount &&
            prev(byte(0x00557048)) == cubeAmount - 1
        )
    )
}

CubesCollected("Suburbs Cube Hunter", "Collect half of the energon cubes in \"The Suburbs\"", 5, 0x00, 50)
CubesCollected("Suburbs Cube Master", "Collect all of the energon cubes in \"The Suburbs\"", 10, 0x00, 100)
CubesCollected("Cube Collector", "Collect half of the energon cubes in \"More Than Meets the Eye\"", 5, 0x01, 50)
CubesCollected("Meeting the Cubes", "Collect all of the energon cubes in \"More Than Meets the Eye\"", 10, 0x01,100)
CubesCollected("Dam Cube Gathering", "Collect half of the energon cubes in \"Inside Hoover Dam\"", 5, 0x02, 50)
CubesCollected("Found the Dam Cubes!", "Collect all of the energon cubes in \"Inside Hoover Dam\"", 10, 0x02, 100)
CubesCollected("The Last Cube Finder", "Collect half of the energon cubes in \"The Last Stand\"", 5, 0x04,50)
CubesCollected("The Last Cube", "Collect all of the energon cubes in \"The Last Stand\"", 10, 0x04, 100)

CubesCollected("Classified Cubes", "Collect half of the energon cubes in \"SOCCENT Military Base\"", 5, 0x06, 50)
CubesCollected("Top Secret Cubes Collected", "Collect all of the energon cubes in \"SOCCENT Military Base\"", 10, 0x06, 100)
CubesCollected("The Hunt for the Cubes", "Collect half of the energon cubes in \"The Hunt for Sam Witwicky\"", 5, 0x07, 50)
CubesCollected("The Hunt for the Cubes Completed", "Collect all of the energon cubes in \"The Hunt for Sam Witwicky\"", 10, 0x07, 100)
CubesCollected("Energon Cube Hoarder", "Collect half of the energon cubes in \"A Gathering Force\"", 5, 0x08, 50)
CubesCollected("Gathering Cubes", "Collect all of the energon cubes in \"A Gathering Force\"", 10, 0x08, 100)
CubesCollected("Urban Energon Collector", "Collect half of the energon cubes in \"City of the Machines\"", 5, 0x0a, 50)
CubesCollected("A City Full of Cubes", "Collect all of the energon cubes in \"City of the Machines\"", 10, 0x0a, 100)

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
            CheatCheck() &&
            CurrentLevel != 0x0f &&
            measured(skillsDone == skillsCount) &&
            prev(skillsDone) < skillsCount
        )
    )
}

SkillsComplete("A Skilled Autobot", "Complete half of the skills in the Autobot levels", 5, AutobotSkills, 13)
SkillsComplete("Optimus Prime Skills", "Complete all of the skills in the Autobot levels", 10, AutobotSkills, 25)
SkillsComplete("A Skilled Decepticon", "Complete half of the skills in the Decepticon levels", 5, DecepticonSkills, 11)
SkillsComplete("Evilest Decepticon Around", "Complete all of the skills in the Decepticon levels", 10, DecepticonSkills, 21)

// ============= Challenges =============
LightWeaponUsage = byte(dword(0x00518e80) + 0x2415)
HeavyWeaponUsage = byte(dword(0x00518e80) + 0x2485)

achievement(
    title = "No Weapons Needed",
    description = "Complete \"Guardian Angel\" with only using melee attacks",
    points = 10,
    trigger = (
        CheatCheck() &&
        once(
            prev(LoadedIntoChapter) == 0x00 &&
            LoadedIntoChapter == 0x01 &&
            CurrentLevel == 0x00 &&
            LastLoadedChapterNum == 0x32
        ) 
        &&
        never(
            CurrentLevel != 0x00 ||
            LastLoadedChapterNum != 0x32 ||
            LoadedIntoChapter == 0x00 ||
            LightWeaponUsage != 0x14 ||
            HeavyWeaponUsage != 0x0a
        )
        &&
        trigger_when(
            ChapterCompleteShowing == 0x01 &&
            prev(ChapterCompleteShowing) == 0x00
        )
    )
)

BuildingHealth = float(0x01e12598)

achievement(
    title = "City Protector",
    description = "Complete \"Heavy Weapon\" with the city having 70% or more health remaining",
    points = 10,
    trigger = (
        CheatCheck() &&
        once(
            prev(LoadedIntoChapter) == 0x00 &&
            LoadedIntoChapter == 0x01 &&
            CurrentLevel == 0x01 &&
            LastLoadedChapterNum == 0x34
        )
        &&
        never(
            CurrentLevel != 0x01 ||
            LastLoadedChapterNum != 0x34 ||
            LoadedIntoChapter == 0x00 ||
            (BuildingHealth < 112.5 && prev(BuildingHealth) >= 112.5)
        )
        &&
        trigger_when(
            ChapterCompleteShowing == 0x01 &&
            prev(ChapterCompleteShowing) == 0x00
        )
    )
)

MissionTimer = float(0x00c29b0c)

achievement(
    title = "The Generator Speedster",
    description = "Complete \"Power Drain\" with 2:12 or more left on the timer after destroying the 5th generator",
    points = 10,
    trigger = (
        CheatCheck() &&
        CurrentLevel == 0x02 &&
        LastLoadedChapterNum == 0x33 &&
        MissionTimer >= 133.0 &&
        byte(0x00c29ea0) == 5
    )
)

achievement(
    title = "Squishing Bugs",
    description = "Complete \"Exterminator\" only using melee attacks",
    points = 5,
    trigger = (
        CheatCheck() &&
        once(
            prev(LoadedIntoChapter) == 0x00 &&
            LoadedIntoChapter == 0x01 &&
            CurrentLevel == 0x04 &&
            LastLoadedChapterNum == 0x31
        ) 
        &&
        never(
            CurrentLevel != 0x04 ||
            LastLoadedChapterNum != 0x31 ||
            LoadedIntoChapter == 0x00 ||
            LightWeaponUsage != 0xc8 ||
            HeavyWeaponUsage != 0x0a
        )
        &&
        trigger_when(
            ChapterCompleteShowing == 0x01 &&
            prev(ChapterCompleteShowing) == 0x00
        )
    )
)

achievement(
    title = "Speedy Plane Destroyer",
    description = "Complete \"Fire in the Sky\" with 4:00 or more left on the timer",
    points = 10,
    trigger = (
        CheatCheck() &&
        CurrentLevel == 0x06 &&
        LastLoadedChapterNum == 0x34 &&
        MissionTimer >= 241.0 &&
        byte(0x00c29ea0) == 20
    )
)

achievement(
    title = "Sinister Puncher",
    description = "Complete \"Sinister Saviour\" only using melee attacks",
    points = 5,
    trigger = (
        CheatCheck() &&
        once(
            prev(LoadedIntoChapter) == 0x00 &&
            LoadedIntoChapter == 0x01 &&
            CurrentLevel == 0x08 &&
            LastLoadedChapterNum == 0x32
        ) 
        &&
        never(
            CurrentLevel != 0x08 ||
            LastLoadedChapterNum != 0x32 ||
            LoadedIntoChapter == 0x00 ||
            LightWeaponUsage != 0x64 ||
            HeavyWeaponUsage != 0x0a
        )
        &&
        trigger_when(
            ChapterCompleteShowing == 0x01 &&
            prev(ChapterCompleteShowing) == 0x00
        )
    )
)

achievement(
    title = "Pest Control!",
    description = "Complete \"Energon Overload\" without letting more than 6 Energon drones be alive at one time",
    points = 10,
    trigger = (
        CheatCheck() &&
        once(
            prev(LoadedIntoChapter) == 0x00 &&
            LoadedIntoChapter == 0x01 &&
            CurrentLevel == 0x0a &&
            LastLoadedChapterNum == 0x32
        ) 
        &&
        never(
            CurrentLevel != 0x0a ||
            LastLoadedChapterNum != 0x32 ||
            LoadedIntoChapter == 0x00 ||
            (byte(0x00c29ea0) > 6 && LoadedIntoChapter == 0x01)
        )
        &&
        trigger_when(
            ChapterCompleteShowing == 0x01 &&
            prev(ChapterCompleteShowing) == 0x00
        )
    )
)