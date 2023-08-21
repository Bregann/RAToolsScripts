// Wallace & Gromit: The Curse of the Were-Rabbit
// #ID = 21933

function InGame() => byte(0x008b160c) == 0x08
function MissionComplete(cardAddr) => byte(cardAddr) == 0x05 && prev(byte(cardAddr)) != 0x00

// Progression achievements
function MissionCompleteAchievement(achTitle, cardName, points, cardAddr){
    achievement(
        title = achTitle,
        description = "Unlock card \"" + cardName + "\"",
        points = points,
        trigger = (
            InGame() &&
            MissionComplete(cardAddr)
        )
    )
}

MissionCompleteAchievement("A Rabbit Free Lawn", "front lawn cleared", 2, 0x0116ed5b)
MissionCompleteAchievement("Pumpkin Protector", "cleared the walled garden", 2, 0x0116ed66)
MissionCompleteAchievement("Statue Removal Service", "returned Lady Tottington's Statues", 2, 0x0116ed71)
MissionCompleteAchievement("I Baked You a Pie", "ingredients collected for Mrs Mulch's ", 2, 0x0116e6bd)