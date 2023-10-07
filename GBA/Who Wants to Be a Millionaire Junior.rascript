// Who Wants to Be a Millionaire Junior
// #ID = 26278

CurrentQuestion = byte(0x000114)
function InGame() => byte(0x000124) == 0x01
function AllLifelinesAvailable => bit0(0x000118) == 0x01 && bit1(0x000118) == 0x01 && bit2(0x000118) == 0x01

function AnswerCorrectlyAchievement(achTitle, achDesc, points, question) {
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            InGame() &&
            CurrentQuestion == question &&
            prev(CurrentQuestion) == question - 1
        )
    )
}

function AnswerCorrectlyAchievementNoLL(achTitle, achDesc, points, question) {
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            InGame() &&
            AllLifelinesAvailable() &&
            CurrentQuestion == question &&
            prev(CurrentQuestion) == question - 1
        )
    )
}

AnswerCorrectlyAchievement("", "Answer the £1,000 question correctly", 2, 0x05)
AnswerCorrectlyAchievementNoLL("", "Answer the £1,000 question correctly without using any lifelines", 2, 0x05)
AnswerCorrectlyAchievement("", "Answer the £32,000 question correctly", 3, 0x0a)
AnswerCorrectlyAchievementNoLL("", "Answer the £32,000 question correctly without using any lifelines", 3, 0x0a)