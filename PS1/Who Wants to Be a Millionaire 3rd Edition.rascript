// Who Wants to Be a Millionaire: 3rd Edition
// #ID = 2912

CurrentQuestion = byte(0x1ffe6c)
Timer = word_be(tbyte(0x1fffc0) + 0x1D)

function IsSinglePlayer() => byte(0x1ffe79) == 1
function AllLifelinesAvailable() => byte(0x1ffecc) + byte(0x1ffecd) + byte(0x1ffece) == 3
function NoLifelinesAvailable() => byte(0x1ffecc) + byte(0x1ffecd) + byte(0x1ffece) == 0

function Q1000Answered() => byte(0x1ffe6c) == 0x05 && prev(byte(0x1ffe6c)) == 0x04
function Q32000Answered() => byte(0x1ffe6c) == 0x0a && prev(byte(0x1ffe6c)) == 0x09
function Q1mAnswered() => byte(0x1ffe6c) == 0x0f && prev(byte(0x1ffe6c)) == 0x0e

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


QuestionAnswered("q1000", "Answer the $1,000 question correctly", 2, Q1000Answered())
QuestionAnsweredNoFails("q1000 no lifelynes", "Answer the $1,000 question correctly with all lifelines available", 2, Q1000Answered())
QuestionAnswered("q32000", "Answer the $32,000 question correctly", 3, Q32000Answered())
QuestionAnsweredNoFails("q32000 no lifelynes", "Answer the $32,000 question correctly with all lifelines available", 3, Q1mAnswered())
QuestionAnswered("q1m", "Answer the $1,000,000 question correctly", 5, Q32000Answered())
QuestionAnsweredNoFails("q1m no lifelynes", "Answer the $1,000,000 question correctly with all lifelines available", 5, Q1mAnswered())

//use all 3 lifelines on the million dollar question
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
        trigger_when(Q1mAnswered())
    )
)