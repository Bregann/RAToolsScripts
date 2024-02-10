// Simpsons, The: Hit & Run
// #ID = 2199

// todo: method for checking cheats

// Game stuff
LevelID = byte(0x69d82b)
MissionNum = byte(0x69d82f)
GameState = byte(0x7f5c77)

function InGame(levelId) => GameState >= 0x09 && levelId == LevelID

// ========= Progression =========
Level1MissionsComplete = byte(0x69c7dc) + byte(0x69c7fc) + byte(0x69c81c) + byte(0x69c83c) + byte(0x69c85c) + byte(0x69c87c) + byte(0x69c89c)
Level21MissionsComplete = byte(0x69ca28) + byte(0x69ca48) + byte(0x69ca68) + byte(0x69ca88) + byte(0x69caa8) + byte(0x69cac8) + byte(0x69cae8)
Level31MissionsComplete = byte(0x69cc94) + byte(0x69ccb4) + byte(0x69ccd4) + byte(0x69ccf4) + byte(0x69cd14) + byte(0x69cd34) + byte(0x69cd54)
Level41MissionsComplete = byte(0x69cf00) + byte(0x69cf20) + byte(0x69cf40) + byte(0x69cf60) + byte(0x69cf80) + byte(0x69cfa0) + byte(0x69cfc0)
Level51MissionsComplete = byte(0x69d16c) + byte(0x69d18c) + byte(0x69d1ac) + byte(0x69d1cc) + byte(0x69d1ec) + byte(0x69d20c) + byte(0x69d22c)
Level61MissionsComplete = byte(0x69d3d8) + byte(0x69d3f8) + byte(0x69d418) + byte(0x69d438) + byte(0x69d458) + byte(0x69d478) + byte(0x69d498)
Level71MissionsComplete = byte(0x69d644) + byte(0x69d664) + byte(0x69d684) + byte(0x69d6a4) + byte(0x69d6c4) + byte(0x69d6e4) + byte(0x69d704)

achievement (
    title = "A Simple Task",
    description = "Complete the tutorial mission",
    points = 2,
    trigger = (
        InGame(0) &&
        byte(0x69c7bc) == 0x01 &&
        prev(byte(0x69c7bc)) == 0x00
    )
)

function LevelComplete(achName, achDesc, points, levelMissions, levelId)
{
    achievement (
        title = "A Simple Task",
        description = "Complete Cola Caper",
        points = 2,
        trigger = (
            InGame(levelId) &&
            measured(levelMissions == 0x07) &&
            prev(levelMissions) == 0x06
        )
    )
}

// ========= Bonus Missions =========
function MissionComplete(achName, missionName, missionCompleteValue, levelId)
{
        achievement (
        title = achName,
        description = "Complete bonus mission " + missionName,
        points = 3,
        trigger = (
            InGame(levelId) &&
            missionCompleteValue == 0x01 &&
            prev(missionCompleteValue) == 0x00
        )
    )
}

MissionComplete("This Old Shanty", "this old shanty", byte(0x69c91c), 0)
MissionComplete("Dial B For Blood", "dial b for blood", byte(0x69cb88), 1)
MissionComplete("Princi-pal", "princi-pal", byte(0x69cdf4), 2)
MissionComplete("Beached Love", "beached love", byte(0x69d060), 3)
MissionComplete("Kinky Frinky", "kinky frinky", byte(0x69d2cc), 4)
MissionComplete("Milking the Pigs", "milking the pigs", byte(0x69d538), 5)
MissionComplete("Flaming Tires", "flaming tires", byte(0x69d7a4), 6)

// ========= Races =========

Level1RacesComplete = byte(0x69c8bc) + byte(0x69c8dc) + byte(0x69c8fc)
Level2RacesComplete = byte(0x69cb28) + byte(0x69cb48) + byte(0x69cb68)
Level3RacesComplete = byte(0x69cd94) + byte(0x69cdb4) + byte(0x69cdd4)
Level4RacesComplete = byte(0x69d000) + byte(0x69d020) + byte(0x69d040)
Level5RacesComplete = byte(0x69d26c) + byte(0x69d28c) + byte(0x69d2ac)
Level6RacesComplete = byte(0x69d4d8) + byte(0x69d4f8) + byte(0x69d518)
Level7RacesComplete = byte(0x69d744) + byte(0x69d764) + byte(0x69d784)

function LevelEndMissionCompleteOrSkipped(completeMem, skippedMem)  => byte(completeMem) + byte(skippedMem) == 0x00

function RaceComplete(achName, achDesc, points, raceMissions, levelId, endMissionCompleted)
{
    achievement (
        title = achName,
        description = achDesc,
        points = points,
        trigger = (
            trigger_when(InGame(levelId)) &&
            raceMissions == 0x03 &&
            prev(raceMissions) == 0x02 &&
            endMissionCompleted
        )
    )
}

RaceComplete("Funny Pink Car Master", "Win all 3 street races in level 1 before reaching level 2", 10, Level1RacesComplete, 0x00, LevelEndMissionCompleteOrSkipped(0x0069c89c, 0x0069c8a4))
RaceComplete("Rolling Around in the Roller", "Win all 3 street races in level 2 before reaching level 3", 10, Level2RacesComplete, 0x01, LevelEndMissionCompleteOrSkipped(0x0069cae8, 0x0069caf0))
RaceComplete("Doll Car Dash", "Win all 3 street races in level 3 before reaching level 4", 10, Level3RacesComplete, 0x02, LevelEndMissionCompleteOrSkipped(0x0069cd54, 0x0069cd5c))
RaceComplete("Look at the Canyonero Go!", "Win all 3 street races in level 4 before reaching level 5", 10, Level4RacesComplete, 0x03, LevelEndMissionCompleteOrSkipped(0x0069cfc0, 0x0069cfc8))
RaceComplete("", "Win all 3 street races in level 5 before reaching level 6", 10, Level5RacesComplete, 0x04, LevelEndMissionCompleteOrSkipped(0x0069d22c, 0x0069d234))
RaceComplete("", "Win all 3 street races in level 6 before reaching level 7", 25, Level6RacesComplete, 0x05, LevelEndMissionCompleteOrSkipped(0x0069d498, 0x0069d4a0))

achievement (
    title = "Dead Close",
    description = "Win all 3 street races in level 7",
    points = 5,
    trigger = (
        InGame(0x06) &&
        Level7RacesComplete == 0x03 &&
        prev(Level7RacesComplete) == 0x02
    )
)

// ========= Collectibles =========
function Collectible(achTitle, levelId, achDesc, collectibleAmount, collectibleAddr)
{
    achievement (
        title = achTitle,
        description = achDesc + " " + levelId + 1,
        points = 10,
        trigger = (
            InGame(levelId) &&
            measured(collectibleAddr == collectibleAmount) &&
            prev(collectibleAddr) < collectibleAmount
        )
    )
}

//Wasps
Collectible("", 0x00, "Destroy every wasp in level", 20, byte(0x0069c95b))
Collectible("", 0x01, "Destroy every wasp in level", 20, byte(0x0069cbc7))
Collectible("", 0x02, "Destroy every wasp in level", 20, byte(0x0069ce33))
Collectible("", 0x03, "Destroy every wasp in level", 20, byte(0x0069d09f))
Collectible("", 0x04, "Destroy every wasp in level", 20, byte(0x0069d30b))
Collectible("", 0x05, "Destroy every wasp in level", 20, byte(0x0069d577))
Collectible("Undead Wasp Killer", 0x06, "Destroy every wasp in level", 20, byte(0x0069d7e3))

//Cards
Collectible("", 0x00, "Collect every collector card on level", 7, byte(0x0069c65b))
Collectible("", 0x01, "Collect every collector card on level", 7,  byte(0x0069c67b))
Collectible("", 0x02, "Collect every collector card on level", 7,  byte(0x0069c69b))
Collectible("", 0x03, "Collect every collector card on level", 7,  byte(0x0069c6bb))
Collectible("", 0x04, "Collect every collector card on level", 7,  byte(0x0069c6db))
Collectible("", 0x05, "Collect every collector card on level", 7,  byte(0x0069c6fb))
Collectible("", 0x06, "Collect every collector card on level", 7,  byte(0x0069c71b))

//Clothing
Collectible("", 0x00, "Purchase every outfit on level", 3, byte(0x0069c957))
Collectible("", 0x01, "Purchase every outfit on level", 3, byte(0x0069cbc3))
Collectible("", 0x02, "Purchase every outfit on level", 3, byte(0x0069ce2f))
Collectible("", 0x03, "Purchase every outfit on level", 3, byte(0x0069d09b))
Collectible("", 0x04, "Purchase every outfit on level", 3, byte(0x0069d307))
Collectible("", 0x05, "Purchase every outfit on level", 3, byte(0x0069d573))
Collectible("", 0x06, "Purchase every outfit on level", 3, byte(0x0069d7df))

//Vehicles
Level1Vehicles = Level1RacesComplete + byte(0x69c91c) + byte(0x0069c953)
Level2Vehicles = Level2RacesComplete + byte(0x69cb88) + byte(0x0069cbbf)
Level3Vehicles = Level3RacesComplete + byte(0x69cdf4) + byte(0x0069ce2b)
Level4Vehicles = Level4RacesComplete + byte(0x69d060) + byte(0x0069d097)
Level5Vehicles = Level5RacesComplete + byte(0x69d2cc) + byte(0x0069d303)
Level6Vehicles = Level6RacesComplete + byte(0x69d538) + byte(0x0069d56f)
Level7Vehicles = Level7RacesComplete + byte(0x69d7a4) + byte(0x0069d7db)

Collectible("", 0x00, "Unlock every vehicle on level", 5, Level1Vehicles)
Collectible("", 0x01, "Unlock every vehicle on level", 5, Level2Vehicles)
Collectible("", 0x02, "Unlock every vehicle on level", 5, Level3Vehicles)
Collectible("", 0x03, "Unlock every vehicle on level", 5, Level4Vehicles)
Collectible("", 0x04, "Unlock every vehicle on level", 5, Level5Vehicles)
Collectible("", 0x05, "Unlock every vehicle on level", 5, Level6Vehicles)
Collectible("", 0x06, "Unlock every vehicle on level", 5, Level7Vehicles)

//Gags
Collectible("", 0x00, "Activate every gag on level", 15, byte(0x0069c96f))
Collectible("", 0x01, "Activate every gag on level", 11,  byte(0x0069cbdb))
Collectible("", 0x02, "Activate every gag on level", 11,  byte(0x0069ce47))
Collectible("", 0x03, "Activate every gag on level", 15,  byte(0x0069d0b3))
Collectible("", 0x04, "Activate every gag on level", 6,  byte(0x0069d31f))
Collectible("", 0x05, "Activate every gag on level", 11,  byte(0x0069d58b))
Collectible("", 0x06, "Activate every gag on level", 15,  byte(0x0069d7f7))