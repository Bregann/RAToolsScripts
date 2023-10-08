// Who Wants to Be a Millionaire Junior
// #ID = 26278

CurrentQuestion = byte(0x000114)
SelectedOption = byte(0x000108)
CorrectAnswer = byte(0x003594)

function InGame() => byte(0x000124) == 0x01
function AllLifelinesAvailable() => bit0(0x000118) == 0x01 && bit1(0x000118) == 0x01 && bit2(0x000118) == 0x01
function CorrectAnswerSelected() => (SelectedOption == 0x00 && CorrectAnswer == 0x00) || (SelectedOption == 0x01 && CorrectAnswer == 0x01) || (SelectedOption == 0x02 && CorrectAnswer == 0x02) || (SelectedOption == 0x03 && CorrectAnswer == 0x03) 
function AnswerSelected() => byte(0x007eb7) == 0x08

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

AnswerCorrectlyAchievement("Getting Started", "Answer the £1,000 question correctly", 2, 0x05)
AnswerCorrectlyAchievementNoLL("Easy So Far", "Answer the £1,000 question correctly with all lifelines available", 3, 0x05)
AnswerCorrectlyAchievement("Cash Building", "Answer the £32,000 question correctly", 3, 0x0a)
AnswerCorrectlyAchievementNoLL("Not a Challenge!", "Answer the £32,000 question correctly with all lifelines available", 4, 0x0a)

achievement(
    title = "Millionaire!",
    description = "Answer the £1,000,000 question correctly",
    points = 4,
    trigger = (
        InGame() &&
        CurrentQuestion == 0x0e &&
        CorrectAnswerSelected() &&
        AnswerSelected()
    )
)

achievement(
    title = "Quiz Expert",
    description = "Answer the £1,000,000 question correctly with all lifelines available",
    points = 5,
    trigger = (
        InGame() &&
        CurrentQuestion == 0x0e &&
        CorrectAnswerSelected() &&
        AnswerSelected()
    )
)

achievement(
    title = "Against All Odds!",
    description = "Use up all 3 lifelines before you reach the £1,000 checkpoint then continue to win £1,000,000",
    points = 5,
    trigger= (
        InGame() &&
        once(CurrentQuestion < 0x04 &&
        bitcount(0x000118) == 0 &&
        prev(bitcount(0x000118)) == 1) &&
        never(byte(0x000124) == 0) &&
        CurrentQuestion == 0x0e &&
        CorrectAnswerSelected() &&
        AnswerSelected()
    )
)