// Bob the Builder: Festival of Fun
// #ID = 29057

LastLoadedLevel = byte(0x00256d08)
InGameTimer = float(dword(0x002f5f20) + 0x00)
Points = dword(dword(0x002f5f2c) + 0x00)
MessageShowing = byte(0x00257084)
CurrentMode = byte(0x00257193)

// ============= Progression =============
function LevelCompleted(achTitle, achDesc, points, achType, levelId, levelAwardAddr)
{
    achievement(
        title = achTitle,
        description = "Complete level " + achDesc,
        points = points,
        type = achType,
        trigger = (
            CurrentMode == 0x01 &&
            LastLoadedLevel == levelId &&
            levelAwardAddr != 0x03 &&
            prev(levelAwardAddr) == 0x03
        )
    )
}

LevelCompleted("Tidying Up", "\"Clear the ground\"", 2, "PROGRESSION", 0x03, byte(0x002f5ddc))
LevelCompleted("Scooping Up the Ground", "\"Dig the Foundations\"", 2, "PROGRESSION", 0x04, byte(0x002f5dde))
LevelCompleted("Dizzy Getting Busy", "\"Mix the Cement\"", 2, "PROGRESSION", 0x05, byte(0x002f5de0))
LevelCompleted("Plank Rush", "\"Get the Planks\"", 3, "PROGRESSION", 0x06, byte(0x002f5de2))
LevelCompleted("Lofty Lifting", "\"Build the Dome\"", 3, "PROGRESSION", 0x07, byte(0x002f5de4))
LevelCompleted("Wired Up", "\"Connect the Circuits\"", 3, "PROGRESSION", 0x08, byte(0x002f5de6))
LevelCompleted("Pizza Cooker", "\"Make the Pizzas\"", 3, "PROGRESSION", 0x09, byte(0x002f5de8))
LevelCompleted("Pizza Protector", "\"Protect the Food\"", 3, "PROGRESSION", 0x0a, byte(0x002f5dea))
LevelCompleted("Getting Arty", "\"Draw the poster\"", 3, "PROGRESSION", 0x0b, byte(0x002f5dec))
LevelCompleted("Song Time!", "\"Sing-a-long\"", 5, "WIN_CONDITION", 0x0c, byte(0x002f5dee))

EasyLevelTrophies = 
byte(0x002f5ddc) + byte(0x002f5dde) + byte(0x002f5de0) + byte(0x002f5de2) + byte(0x002f5de4) +
byte(0x002f5de6) + byte(0x002f5de8) + byte(0x002f5dea) + byte(0x002f5dec) + byte(0x002f5dee)

achievement(
    title = "Perfected Easy Mode",
    description = "Achieve gold on every level on easy difficulty in story mode",
    points = 10,
    trigger = (
        CurrentMode == 0x01 &&
        EasyLevelTrophies == 0x00 &&
        prev(EasyLevelTrophies) <= 0x03 &&
        LastLoadedLevel > 0x02
    )
)

function HardLevelCompleted(achTitle, achDesc, points, levelId, levelAwardAddr)
{
    achievement(
        title = achTitle,
        description = "Earn the gold trophy on " + achDesc + " in hard mode",
        points = points,
        trigger = (
            LastLoadedLevel == levelId &&
            levelAwardAddr == 0x00 &&
            prev(levelAwardAddr) != 0x00
        )
    )
}

HardLevelCompleted("Rubbish Free", "\"Clear the ground\"", 5, 0x03, byte(0x002f5df0))
HardLevelCompleted("Best Foundations Around", "\"Dig the Foundations\"", 5, 0x04, byte(0x002f5df2))
HardLevelCompleted("Perfect Cement", "\"Mix the Cement\"", 5, 0x05, byte(0x002f5df4))
HardLevelCompleted("Quicker Than Amazon", "\"Get the Planks\"", 5, 0x06, byte(0x002f5df6))
HardLevelCompleted("Dome Sweet Dome", "\"Build the Dome\"", 5, 0x07, byte(0x002f5df8))
HardLevelCompleted("Qualified Electrician", "\"Connect the Circuits\"", 5, 0x08, byte(0x002f5dfa))
HardLevelCompleted("Perfect Pizzas", "\"Make the Pizzas\"", 5, 0x09, byte(0x002f5dfc))
HardLevelCompleted("Outstanding in His Field", "\"Protect the Food\"", 5, 0x0a, byte(0x002f5dfe))
HardLevelCompleted("A Work of Art", "\"Draw the poster\"", 5, 0x0b, byte(0x002f5e00))
HardLevelCompleted("Voice of an Angel", "\"Sing-a-long\"", 5, 0x0c, byte(0x002f5e02))

// ============= Challenges =============
function SpeedrunAchievement(achTitle, achDesc, points, levelId, timerLeft)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            CurrentMode == 0x01 &&
            LastLoadedLevel == levelId &&
            trigger_when(MessageShowing == 0x01) &&
            prev(MessageShowing) == 0x00 &&
            InGameTimer >= timerLeft
        )
    )
}

function PointsAchievement(achTitle, achDesc, points, levelId, pointsGoal)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            CurrentMode == 0x05 &&
            LastLoadedLevel == levelId &&
            trigger_when(MessageShowing == 0x01) &&
            prev(MessageShowing) == 0x00 &&
            Points >= pointsGoal
        )
    )
}

SpeedrunAchievement("Speedy Cleaner", "Complete \"Clear the ground\" on easy mode with 55 or more seconds left on the clock", 5, 0x03, 55.0)
SpeedrunAchievement("Quickest Dome Built", "Complete \"Build the Dome\" on easy mode with 195 or more seconds left on the clock", 5, 0x07, 195.0)
PointsAchievement("Professional Scarecrow", "Earn 950 points on \"Protect the Food\" on hard mode", 5, 0x0a, 950)
PointsAchievement("Best Bob the Builder Singer", "Earn 1000 points on \"Sing-a-long\" on hard mode", 10, 0x0c, 1000)