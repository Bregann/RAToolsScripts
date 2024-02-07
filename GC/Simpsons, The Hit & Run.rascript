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
// Funny Pink Car Master
// Rolling Around in the Roller
// ??
// Look at the Canyonero Go!
// ??
// ??
// ??

Level1RacesComplete = byte(0x69c8bc) + byte(0x69c8dc) + byte(0x69c8fc)
Level2RacesComplete = byte(0x69cb28) + byte(0x69cb48) + byte(0x69cb68)
Level3RacesComplete = byte(0x69cd94) + byte(0x69cdb4) + byte(0x69cdd4)
Level4RacesComplete = byte(0x69d000) + byte(0x69d020) + byte(0x69d040)
Level5RacesComplete = byte(0x69d26c) + byte(0x69d28c) + byte(0x69d2ac)
Level6RacesComplete = byte(0x69d4d8) + byte(0x69d4f8) + byte(0x69d518)
Level7RacesComplete = byte(0x69d744) + byte(0x69d764) + byte(0x69d784)

function RaceComplete(achName, achDesc, points, raceMissions, levelId)
{
    achievement (
        title = achName
    )
}