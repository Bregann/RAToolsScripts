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
LevelComplete("Letters in the Wind", "Windy Sack", 3, 0x0e)
LevelComplete("Trail Blazing", "Trail Blazing", 2, 0x0f)
LevelComplete("Eyes in the Sky", "Missing Mail", 3, 0x10)
LevelComplete("Angry Animals", "Animal Feed", 2, 0x11)
LevelComplete("Winner Winner", "Bike Race", 5, 0x12)

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
            Score >= scoreGoal
        )
    )
}

ScoreAchievement("School Prep Perfectionist", "Earn 15 points in the School Rush level", 5, 0x09, 15)
ScoreAchievement("Purrfessional Jess Hunter", "Earn 20 points or more in the Hide And Squeak level", 5, 0x0a, 20)
ScoreAchievement("Speedy Stamper", "Earn 35 points or more in the To Be Frank level", 5, 0x0b, 35)
ScoreAchievement("Sorting Office Speedster", "Earn 19 points or more in the Sorting Office level", 10, 0x0c, 19)
ScoreAchievement("No Letters Lost", "Earn 40 points or more in the Windy Sack level", 5, 0x0e, 40)
ScoreAchievement("Ultimate Trailblazer", "Earn 65 points or more in the Trail Blazing level", 10, 0x0f, 65)
ScoreAchievement("No More Missing Mail", "Earn 25 points or more in the Missing Mail level", 5, 0x10, 25)
ScoreAchievement("Well Fed Animals", "Earn 16 points or more in the Animal Feed level", 5, 0x11, 16)

//Some challenge achievements
achievement(
    title = "Fastest Van Packer Around!",
    description = "Fill up the first van fully before the timer goes below 40 seconds",
    points = 10,
    trigger = (
        CurrentScreen == 0x0d &&
        Timer >= 2000 &&
        trigger_when(Score == 24 &&
        prev(Score) == 22)
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
LevelLeaderboard("Windy Sack", 0x0e)
LevelLeaderboard("Trail Blazing", 0x0f)
LevelLeaderboard("Missing Mail", 0x10)
LevelLeaderboard("Animal Feed", 0x11)