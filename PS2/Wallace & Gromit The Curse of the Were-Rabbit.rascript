// Wallace & Gromit: The Curse of the Were-Rabbit
// #ID = 21933

function InGame() => byte(0x008b160c) != 0x04
function MissionComplete(cardAddr) => byte(cardAddr) == 0x05 && prev(byte(cardAddr)) != 0x00
function MissionCompleteTrigger(cardAddr) => trigger_when(byte(cardAddr) == 0x05) && prev(byte(cardAddr)) != 0x00
Timer = float(dword(dword(0x00553020) + 0x6c) + 0x58)

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
MissionCompleteAchievement("West Wallaby Street Rabbit Cleaner", "West Wallaby St rabbits removed", 2, 0x0116e60d)
MissionCompleteAchievement("The Bank Organiser", "bank veg sorted", 3, 0x0116e644)
MissionCompleteAchievement("No Posters Left", "were-rabbit posters removed", 2, 0x0116e4fa)
MissionCompleteAchievement("They See Me Rolling", "barrels delivered to the customers", 2, 0x0116e602)
MissionCompleteAchievement("A Backyard Pest Problem", "the back gardens - 100 pests collected", 5, 0x0116e481)


//Challenges
function SpeedrunAchievement(achTitle, achDesc, points, cardAddr, timerSecsLeft){
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            InGame() &&
            Timer > timerSecsLeft &&
            MissionCompleteTrigger(cardAddr)
        )
    )
}

SpeedrunAchievement("West Wallaby Street Rabbit Speedrunner [m]", "Clear all the rabbits in the \"West Wallaby St rabbits removed \" mission with 6 minutes or more left on the timer", 5, 0x0116e60d, 360.0)
SpeedrunAchievement("They See Me Rolling Speedrunner [m]", "Complete mission \"barrels delivered to the customers\"with 1 minute 26 seconds or more left on the timer", 5, 0x0116e602, 86.0)