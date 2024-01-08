// Postman Pat and the Greendale Rocket
// #ID = 9099

ScreenId = byte(0x004438)
LevelId = byte(0x004430)

function PlatformerLevelComplete(achTitle, levelName, points, levelIdVal, screenIdVal) {
    achievement(
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

PlatformerLevelComplete("Visiting Mrs Goggins", "1-A", 3, 0x19, 0x0b)