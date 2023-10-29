// Postman Pat
// #ID = 24152

CurrentScreen = byte(0x00195ea4)
function InStoryMode() => byte(0x00195eac) == 0x00
Score = byte(0x00197654)
Timer = word(0x00195ec4)

//Level achievements
function LevelComplete(achName, levelName, points, levelId)
{
    achievement(
        title = achName,
        description = "Complete level " + levelName + " on story mode",
        points = points,
        trigger = (
            InStoryMode() &&
            CurrentScreen == 0x14 &&
            prev(CurrentScreen) == levelId
        )
    )
}

LevelComplete("Ready For School", "School Rush", 2, 0x09)
LevelComplete("Cat Hunter", "Hide And Squeak", 2, 0x0a)
LevelComplete("Stamping Out Problems", "To Be Frank", 3, 0x0b)
LevelComplete("Letters Ready", "Sorting Office", 3, 0x0c)
LevelComplete("PAT 1 Ready To Go!", "Van Jam", 3, 0x0d)
LevelComplete("Windy Sack", "Windy Sack", 2, 0x0e)
LevelComplete("Trail Blazing", "Trail Blazing", 2, 0x0f)
LevelComplete("Missing Mail", "Missing Mail", 2, 0x10)
LevelComplete("Animal Feed", "Animal Feed", 2, 0x11)
LevelComplete("Bike Race", "Bike Race", 2, 0x12)

//Score achievements
function ScoreAchievement(achName, achDesc, points, levelId, scoreGoal)
{
    achievement(
        title = achName,
        description = achDesc,
        points = points,
        trigger = (
            CurrentScreen == 0x14 &&
            prev(CurrentScreen) == levelId &&
            Score <= scoreGoal
        )
    )
}

ScoreAchievement("School Prep Perfectionist", "Earn 15 points in the School Rush level", 5, 0x09, 15)
ScoreAchievement("Purrfessional Jess Hunter", "Earn 20 points or more in the Hide And Squeak level", 5, 0x0a, 20)
ScoreAchievement("Speedy Stamper", "Earn 35 points or more in the To Be Frank level", 5, 0x0b, 35)
ScoreAchievement("Sorting Office Speedster", "Earn 19 points or more in the Sorting Office level", 10, 0x0c, 18)

//Some challenge achievements
achievement(
    title = "Fastest Van Packer Around!",
    description = "Fill up the first van fully before the timer goes below 40 seconds",
    points = 10,
    trigger = (
        CurrentScreen == 0x0d &&
        Timer >= 2000 &&
        Score == 24 &&
        prev(Score) == 22
    )
)

//Leaderboards
function LevelLeaderboard(levelName, levelId)
{
    leaderboard(
        title = levelName,
        description = "Get the highest score on " + levelName,
        start = (
            CurrentScreen == levelId &&
            prev(CurrentScreen) == 0x07
        ),
        cancel = (
            CurrentScreen < 0x09
        ),
        submit = (
            CurrentScreen == 0x14 &&
            prev(CurrentScreen) == levelId
        ),
        value = (Score),
        lower_is_better = false
    )
}

LevelLeaderboard("Hide And Squeak", 0x0a)
LevelLeaderboard("To Be Frank", 0x0b)
LevelLeaderboard("Sorting Office", 0x0c)
LevelLeaderboard("Van Jam", 0x0d)