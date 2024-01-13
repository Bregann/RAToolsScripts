// Postman Pat and the Greendale Rocket
// #ID = 9099

ScreenId = byte(0x004438)
LevelId = byte(0x004430)
TotalCollectiblesCollected = byte(0x00dc48) + byte(0x00dc4c) + byte(0x00dc50)

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

function CollectiblePlatformerLevels(achTitle, levelName, screenIdVal, collectibleAmount) {
    achievement (
        title = achTitle,
        description = "Collect all the stamps, parcels and letters on level " + levelName,
        points = 5,
        trigger = (
            ScreenId == screenIdVal &&
            measured(TotalCollectiblesCollected == collectibleAmount) &&
            prev(TotalCollectiblesCollected) < collectibleAmount
        )
    )
}

PlatformerDriveLevelComplete("Visiting Mrs Goggins", "1-A", 3, 0x19, 0x0b)
MiscLevelComplete("Sorting the Parcels", "1-B", 3, 0x16, byte(0x004b44), 6)
PlatformerDriveLevelComplete("Driving to Ajay", "1-C", 2, 0x13, 0x0d)

PlatformerDriveLevelComplete("On A Charlie Pringle Adventure", "2-A", 3, 0x1a, 0x0e)
MiscLevelComplete("High as a Kite", "2-B", 3, 0x17, byte(0x016480), 10)
PlatformerDriveLevelComplete("The Kite Chaser", "2-C", 2, 0x14, 0x10)

PlatformerDriveLevelComplete("Leather-Bound Bible", "3-A", 3, 0x19, 0x11)
MiscLevelComplete("Raining Holy Water!", "3-B", 3, 0x18, byte(0x014c20), 50)
PlatformerDriveLevelComplete("Police Hunter", "3-C", 2, 0x15, 0x0d)

PlatformerDriveLevelComplete("Double Trouble", "4-A", 3, 0x19, 0x14)
MiscLevelComplete("Ooh Butterflies!", "4-B", 3, 0x1a, byte(0x00dc24), 80)
PlatformerDriveLevelComplete("Ted Traveler", "4-C", 2, 0x13, 0x16)

PlatformerDriveLevelComplete("A Second Mrs Goggins Adventure", "5-A", 3, 0x19, 0x0b)
MiscLevelComplete("Stamp of Approval", "5-B", 3, 0x16, byte(0x014c20), 99)
PlatformerDriveLevelComplete("The Rocket Has Been Found!", "5-C", 5, 0x14, 0x19)

CollectiblePlatformerLevels("Stocking Up Mrs Goggins Shop", "1-A", 0x0b, 90)
CollectiblePlatformerLevels("Pat the Postal Pro", "2-A", 0x0e, 135)
CollectiblePlatformerLevels("Blessed Parcel Collection", "3-A", 0x11, 125)
CollectiblePlatformerLevels("Postal Perfection", "4-A", 0x14, 150)
CollectiblePlatformerLevels("Master of Letters", "5-A", 0x17, 140)

//Misc challenges
achievement (
    title = "Professional Parcel Sorter",
    description = "Complete level 1-B with 40 seconds or more left on the clock",
    points = 5,
    trigger = (
        ScreenId == 0x0c &&
        (byte(0x00b37a) >= 4 || byte(0x00b336) == 1) &&
        trigger_when(byte(0x004b44) == 6 &&
        prev(byte(0x004b44)) == 5)
    )
)