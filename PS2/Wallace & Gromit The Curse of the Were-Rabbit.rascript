// Wallace & Gromit: The Curse of the Were-Rabbit
// #ID = 21933

function InGame() => byte(0x008b160c) != 0x04
function MissionComplete(cardAddr) => byte(cardAddr) == 0x05 && (prev(byte(cardAddr)) == 0x03 || prev(byte(cardAddr)) == 0x04)
function MissionCompleteTrigger(cardAddr) => trigger_when(byte(cardAddr) == 0x05) && (prev(byte(cardAddr)) == 0x03 || prev(byte(cardAddr)) == 0x04)
Timer = float(dword(dword(0x00553020) + 0x6c) + 0x58)
NPCHealthTask = word(dword(dword(dword(0x00553020) + 0x70) + 0x58) + 0x5f4)

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
MissionCompleteAchievement("I Baked You a Pie", "ingredients collected for Mrs Mulch's Pie", 2, 0x0116e6bd)
MissionCompleteAchievement("West Wallaby Street Rabbit Cleaner", "West Wallaby St rabbits removed", 2, 0x0116e60d)
MissionCompleteAchievement("The Bank Organiser", "bank veg sorted", 3, 0x0116e644)
MissionCompleteAchievement("No Posters Left", "were-rabbit posters removed", 2, 0x0116e4fa)
MissionCompleteAchievement("They See Me Rolling", "barrels delivered to the customers", 2, 0x0116e602)
MissionCompleteAchievement("A Back Garden Pest Problem", "the back gardens - 100 pests collected", 5, 0x0116e481)
MissionCompleteAchievement("Rabbit Free Town Hall", "town hall cleared", 2, 0x0116e4ce)
MissionCompleteAchievement("Rex Racer", "beat Rex Leaching", 2, 0x0116e4d9)
MissionCompleteAchievement("Master Mechanic", "Winnie's van fixed", 2, 0x0116e70a)
MissionCompleteAchievement("The Woo-Rabbit", "Lady were-rabbit success", 3, 0x0116e455)
MissionCompleteAchievement("Were-Rabbit Spotted", "Wallace is the Were-Rabbit!", 3, 0x0116e65a)
MissionCompleteAchievement("Device Destroyer", "first diabolical device destroyed", 2, 0x0116e4c3)
MissionCompleteAchievement("Take Me to Church", "Mrs Windfall safely reached the church", 3, 0x0116e6b2)
MissionCompleteAchievement("Bank Bodyguard", "the bank is safe", 2, 0x0116e6a7)
MissionCompleteAchievement("Pitch Invaders Defeated", "rex is safe", 2, 0x0116e62e)
MissionCompleteAchievement("Defender of Vegetables", "Mrs Windfall's veg is safe", 2, 0x0116e4e4)
MissionCompleteAchievement("Cracking Football Player!", "bullseye!", 3, 0x0116e573)

//Challenges
function SpeedrunAchievement(achTitle, achDesc, points, cardAddr, timerSecsLeft) {
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            InGame() &&
            Timer >= timerSecsLeft &&
            MissionCompleteTrigger(cardAddr)
        )
    )
}

SpeedrunAchievement("West Wallaby Street Rabbit Speedrunner [m]", "Clear all the rabbits in the \"West Wallaby St rabbits removed\" mission with 6 minutes or more left on the timer", 5, 0x0116e60d, 360.0)
SpeedrunAchievement("They See Me Rolling Speedrunner [m]", "Unlock card \"barrels delivered to the customers\" with 1 minute 26 seconds or more left on the timer", 5, 0x0116e602, 86.0)
SpeedrunAchievement("Town Hall Rabbit Speedrunner [m]", "Clear all the rabbits in the \"town hall cleared\" mission with 5 minutes or more left on the timer", 5, 0x0116e4ce, 300.0)
SpeedrunAchievement("Mrs Windfall Veg Speedrunner [m]", "Clear all the rabbits in the \"Mrs Windfall's veg is safe\" mission with 3 minutes 40 seconds or more left on the timer", 5, 0x0116e4e4, 220.0)

function HealthAchievement(achTitle, achDesc, points, cardAddr, healthLeft) {
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            InGame() &&
            once(NPCHealthTask >= healthLeft) &&
            never((NPCHealthTask < healthLeft && NPCHealthTask > 0x00) || byte(0x008b160c) == 0x04 || byte(cardAddr) == 0x01) &&
            MissionCompleteTrigger(cardAddr)
        )
    )
}

HealthAchievement("Church Protector [m]", "Keep Mrs Windfall's health at 75 or above when escorting her to Church", 10, 0x0116e6b2, 75)
HealthAchievement("Most Secure Bank in Town [m]", "Keep Mr Windfall's health at 85 or above when protecting the bank", 10, 0x0116e6a7, 85)
HealthAchievement("Ultimate Rex Guardian [m]", "Keep Rex Leaching's health at 90 or above when protecting him at the park", 10, 0x0116e62e, 90)