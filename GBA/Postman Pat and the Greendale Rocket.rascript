// Postman Pat and the Greendale Rocket
// #ID = 9099

ScreenId = byte(0x004438)
LevelId = byte(0x004430)

function PlatformerLevelComplete(achTitle, levelName, points, levelIdVal, screenIdVal) {
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

PlatformerLevelComplete("Visiting Mrs Goggins", "1-A", 3, 0x19, 0x0b)
MiscLevelComplete("Sorting the Parcels", "1-B", 2, 0x16, byte(0x004b44), 6)