// Who Wants to Be a Millionaire: 3rd Edition
// #ID = 2912

CurrentQuestion = byte(0x1ffe6c)
LifelinesAvailable = byte(0x1ffecc) + byte(0x1ffecd) + byte(0x1ffece)

function IsSinglePlayer() => byte(0x1ffe79) == 1
function AllLifelinesAvailable() => byte(0x1ffecc) + byte(0x1ffecd) + byte(0x1ffece) == 3
function NoLifelinesAvailable() => byte(0x1ffecc) + byte(0x1ffecd) + byte(0x1ffece) == 0

function Q1000Answered() => byte(0x1ffe6c) == 0x05 && prev(byte(0x1ffe6c)) == 0x04
function Q32000Answered() => byte(0x1ffe6c) == 0x0a && prev(byte(0x1ffe6c)) == 0x09
function Q1mAnswered() => byte(0x1ffe6c) == 0x0f && prev(byte(0x1ffe6c)) == 0x0e

function Q1000AnsweredTrigger() => trigger_when(byte(0x1ffe6c) == 0x05) && prev(byte(0x1ffe6c)) == 0x04
function Q32000AnsweredTrigger() => trigger_when(byte(0x1ffe6c) == 0x0a) && prev(byte(0x1ffe6c)) == 0x09
function Q1mAnsweredTrigger() => trigger_when(byte(0x1ffe6c) == 0x0f) && prev(byte(0x1ffe6c)) == 0x0e

// ================================
// Questions
// ================================


function QuestionAnswered(achTitle, achDesc, points, question)
{
    achievement (
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            IsSinglePlayer() &&
            question
        )
    )
}

function QuestionAnsweredNoFails(achTitle, achDesc, points, question)
{
    achievement (
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            IsSinglePlayer() &&
            AllLifelinesAvailable() &&
            question
        )
    )
}


QuestionAnswered("The First Checkpoint", "Answer the $1,000 question correctly", 2, Q1000Answered())
QuestionAnsweredNoFails("Flawless Foundation", "Answer the $1,000 question correctly with all lifelines available", 2, Q1000AnsweredTrigger())

QuestionAnswered("Building Up Money", "Answer the $32,000 question correctly", 3, Q32000Answered())
QuestionAnsweredNoFails("Quiz Genius", "Answer the $32,000 question correctly with all lifelines available", 3, Q32000AnsweredTrigger())

QuestionAnswered("The Million Dollar Question", "Answer the $1,000,000 question correctly", 5, Q1mAnswered())
QuestionAnsweredNoFails("Millionaire Mastermind", "Answer the $1,000,000 question correctly with all lifelines available", 5, Q1mAnsweredTrigger())

achievement (
    title = "Better Safe Than Sorry!",
    description = "Use all 3 lifelines on the $1,000,000 question and answer it correctly",
    points = 2,
    trigger = (
        IsSinglePlayer() &&
        once(AllLifelinesAvailable() && CurrentQuestion == 0x0e) &&
        NoLifelinesAvailable() &&
        Q1mAnswered() &&
        never(CurrentQuestion < 0x0e)
    )
)

achievement (
    title = "Did I Hear Coughing?",
    description = "Set your name to 'CHARLES' and answer the $1,000,000 question correctly",
    points = 2,
    trigger = (
        IsSinglePlayer() &&
        byte(0x1ffea8) == 0x43 && 
        byte(0x1ffea9) == 0x48 &&
        byte(0x1ffeaa) == 0x41 &&
        byte(0x1ffeab) == 0x52 &&
        byte(0x1ffeac) == 0x4C &&
        byte(0x1ffead) == 0x45 &&
        byte(0x1ffeae) == 0x53 &&
        Q1mAnsweredTrigger()
    )
)

achievement (
    title = "Not a Great Start",
    description = "Use all 3 lifelines on the $100 question",
    points = 1,
    trigger = (
        IsSinglePlayer() &&
        LifelinesAvailable == 0 &&
        prev(LifelinesAvailable) == 1 &&
        CurrentQuestion == 0x00
    )
)