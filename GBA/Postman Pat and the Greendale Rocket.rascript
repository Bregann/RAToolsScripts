// Postman Pat and the Greendale Rocket
// #ID = 9099

ScreenId = byte(0x004438)
LevelId = byte(0x004430)

function PlatformerDriveLevelComplete(achTitle, levelName, points, levelIdVal, screenIdVal) {
    achievement (
        title = achTitle,
        description = "Complete level " + levelName,
        points = points,
        trigger = (
            prev(LevelId) == levelIdVal &&
            LevelId == 0x0a &&
            ScreenId == screenIdVal
        )
    )
}

function MiscLevelComplete(achTitle, levelName, points, levelIdVal, scoreAddr, score) {
    achievement (
        title = achTitle,
        description = "Complete level " + levelName,
        points = points,
        trigger = (
            LevelId == levelIdVal &&
            scoreAddr == score &&
            prev(scoreAddr) == score - 1
        )
    )
}

PlatformerDriveLevelComplete("Visiting Mrs Goggins", "1-A", 3, 0x19, 0x0b)
MiscLevelComplete("Sorting the Parcels", "1-B", 2, 0x16, byte(0x004b44), 6)
PlatformerDriveLevelComplete("Driving to Ajay", "1-C", 3, 0x13, 0x0d)

PlatformerDriveLevelComplete("On A Charlie Pringle Adventure", "2-A", 3, 0x1a, 0x0e)
MiscLevelComplete("High as a Kite", "2-B", 3, 0x17, byte(0x016480), 10)
PlatformerDriveLevelComplete("The Kite Chaser", "2-C", 2, 0x14, 0x10)

PlatformerDriveLevelComplete("Leather-Bound Bible", "3-A", 3, 0x19, 0x11)
MiscLevelComplete("Raining Holy Water!", "3-B", 3, 0x18, byte(0x014c20), 50)
PlatformerDriveLevelComplete("Police Hunter", "3-C", 3, 0x15, 0x0d)

PlatformerDriveLevelComplete("Double Trouble", "4-A", 3, 0x19, 0x14)
MiscLevelComplete("Ooh Butterflies!", "4-B", 4, 0x1a, byte(0x00dc24), 80)
