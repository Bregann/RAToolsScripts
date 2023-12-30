// Zoo Tycoon DS
// #ID = 7344

TutorialBitflags = bit0(0x0cf2c0) + bit1(0x0cf2c0) + bit2(0x0cf2c0)
function InGame() => byte(0x0cf334) == 0x38

//Beat scenario achievements
achievement(
    title = "Learning The Basics",
    description = "Complete all 3 tutorial scenarios",
    points = 3,
    trigger = (
        InGame() &&
        TutorialBitflags == 0x03 &&
        prev(TutorialBitflags) == 0x02
    )
)
function BeatScenario(achTitle, achDesc, points){
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            InGame() &&

        )
    )
}