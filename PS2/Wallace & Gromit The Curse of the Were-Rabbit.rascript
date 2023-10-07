// Wallace & Gromit: The Curse of the Were-Rabbit
// #ID = 21933

function InGame() => byte(0x008b160c) != 0x04
function MissionComplete(cardAddr) => byte(cardAddr) == 0x05 && (prev(byte(cardAddr)) == 0x03 || prev(byte(cardAddr)) == 0x04)
function PestMissionComplete(cardAddr) => byte(cardAddr) == 0x05 && prev(byte(cardAddr)) == 0x02
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

function PestCompleteAchievement(achTitle, cardName, points, cardAddr){
    achievement(
        title = achTitle,
        description = "Unlock card \"" + cardName + "\"",
        points = points,
        trigger = (
            InGame() &&
            PestMissionComplete(cardAddr)
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
PestCompleteAchievement("A Back Garden Pest Problem 1", "the back gardens - 25 pests collected", 3, 0x0116e46b)
PestCompleteAchievement("A Back Garden Pest Problem 2", "the back gardens - 50 pests collected", 5, 0x0116e476)
PestCompleteAchievement("A Back Garden Pest Problem 3", "the back gardens - 100 pests collected", 10, 0x0116e481)
MissionCompleteAchievement("Rabbit Free Town Hall", "town hall cleared", 2, 0x0116e4ce)
MissionCompleteAchievement("Rex Racer", "beat Rex Leaching", 2, 0x0116e4d9)
MissionCompleteAchievement("Master Mechanic", "Winnie's van fixed", 2, 0x0116e70a)
MissionCompleteAchievement("The Woo-Rabbit", "Lady were-rabbit success", 3, 0x0116e455)
MissionCompleteAchievement("Were-Rabbit Spotted", "Wallace is the Were-Rabbit!", 5, 0x0116e65a)
MissionCompleteAchievement("Device Destroyer", "first diabolical device destroyed", 2, 0x0116e4c3)
MissionCompleteAchievement("Take Me to Church", "Mrs Windfall safely reached the church", 3, 0x0116e6b2)
MissionCompleteAchievement("Bank Bodyguard", "the bank is safe", 2, 0x0116e6a7)
MissionCompleteAchievement("Pitch Invaders Defeated", "rex is safe", 2, 0x0116e62e)
MissionCompleteAchievement("Defender of Vegetables", "Mrs Windfall's veg is safe", 2, 0x0116e4e4)
MissionCompleteAchievement("Cracking Football Player!", "bullseye!", 3, 0x0116e573)
MissionCompleteAchievement("Hattrick!", "3 goals scored", 2, 0x0116e57e)
MissionCompleteAchievement("Blessed Gardens", "churchyard cleared of pests", 3, 0x0116e64f)
MissionCompleteAchievement("Holy Water Secured", "returned the vicar's bottles", 3, 0x0116e686)
PestCompleteAchievement("Back Garden Valve Collector 1", "1st valve collected", 3, 0x0116e497)
PestCompleteAchievement("Back Garden Valve Collector 2", "2nd valve collected", 5, 0x0116e4a2)
PestCompleteAchievement("Back Garden Valve Collector 3", "3rd valve collected", 10, 0x0116e4ad)
MissionCompleteAchievement("Not The Pumpkins!", "Were-Rabbit chaased to Wallersey", 5, 0x0116e6ff)
PestCompleteAchievement("The Church Pest Problem 1","the churchyard - 25 pests collected", 3, 0x0116e74c)
PestCompleteAchievement("The Church Pest Problem 2","the churchyard - 50 pests collected", 5, 0x0116e757)
PestCompleteAchievement("The Church Pest Problem 3","the churchyard - 100 pests collected", 10, 0x0116e762)
MissionCompleteAchievement("Rodent Remover","churchyard cleared of were-rats", 3, 0x0116e618)
MissionCompleteAchievement("Buzz Off!","town square cleared of were-bees", 3, 0x0116e665)
MissionCompleteAchievement("Look at All Those Chickens","all of growbag's chickens returned", 3, 0x0116e67b)
MissionCompleteAchievement("Woods Cleanup","woods cleared of pests", 4, 0x0116e639)
MissionCompleteAchievement("A Walk Through the Woods","jasminder returned home safely", 4, 0x0116e670)
MissionCompleteAchievement("Power Provider","growbag's generator restarted", 3, 0x0116e691)
MissionCompleteAchievement("Apple Delivery","Mrs Mulch home safe", 4, 0x0116e4ef)
MissionCompleteAchievement("Shaun the Sheep","sheep and goats all penned", 4, 0x0116e6f4)
MissionCompleteAchievement("Wallersey Rabbit Removal","Wallersey - clear the rabbits", 3, 0x0116ea4e)
MissionCompleteAchievement("Bunny Hopper Adventure","Dibber's ornaments returned safely", 5, 0x0116e9b4)
MissionCompleteAchievement("Leeky Vents","nursery veg saved", 4, 0x0116e8ee)
MissionCompleteAchievement("Wallersey Lower Towns Rabbits Cleared","Wallersey - lower town - rabbits!", 3, 0x0116ead2)
MissionCompleteAchievement("Doll Collector","find 10 dolls", 3, 0x0116e9d5)
MissionCompleteAchievement("Mole Masher","whack-a-mole", 4, 0x0116e95c)
MissionCompleteAchievement("Bell Bonger","beaten Alfie Crock", 3, 0x0116e90f)
MissionCompleteAchievement("A Little Old Lady and Her Giant Marrow","Betty's veg is saved", 3, 0x0116e988)
PestCompleteAchievement("The Allotments Pest Problem 1","the allotments - 25 pests collected", 3, 0x0116eafe)
PestCompleteAchievement("The Allotments Pest Problem 2","the allotments - 50 pests collected", 5, 0x0116eb09)
PestCompleteAchievement("The Allotments Pest Problem 3","the allotments - 100 pests collected", 10, 0x0116eb14)
MissionCompleteAchievement("Rabbit Rabbit Pumpkin","duckshoot", 5, 0x0116e972)
MissionCompleteAchievement("Ultimate Veg Sorter","successful veg sorting", 4, 0x0116e8f9)
MissionCompleteAchievement("Seed Stealer","found Harriet's seeds", 3, 0x0116e993)
MissionCompleteAchievement("Mr Dibber Escort","Mr Dibber safely reached his house", 4, 0x0116e930)
MissionCompleteAchievement("Where's My Keys?","found Mr Dibber's keys", 3, 0x0116e9ca)
MissionCompleteAchievement("Were-Rabbits In The Harbour","harbor opened", 4, 0x0116e93b)
PestCompleteAchievement("The Allotments Valve Collector 1", "1st valve collected", 3, 0x0116eb2a)
PestCompleteAchievement("The Allotments Valve Collector 2", "2nd valve collected", 5, 0x0116eb35)
PestCompleteAchievement("The Allotments Valve Collector 3", "3rd valve collected", 10, 0x0116eb40)
MissionCompleteAchievement("Into Grimsley", "Were-Rabbit chased to Grimsley", 5, 0x0116e9bf)
MissionCompleteAchievement("Blessed Wallersey Escort", "Vicar Safely Escorted From Wallersey", 5, 0x0116e925)
MissionCompleteAchievement("Rabbit Ship", "pests removed from the boat", 3, 0x0116e946)
MissionCompleteAchievement("The Vent Hopper", "hopped up the boat", 3, 0x0116e91a)
MissionCompleteAchievement("No Messages in These Bottles", "collected all the Veg-B-Big bottles", 5, 0x0116e99e)
MissionCompleteAchievement("Cleaned Steamer", "Rob's Steamer Is Safe", 4, 0x0116e951)
MissionCompleteAchievement("Factory Fired Up!", "factory restarted", 5, 0x0116ebe5)
MissionCompleteAchievement("Underground Rabbits", "rabbit warren", 3, 0x0116ecd7)
MissionCompleteAchievement("Factoy Hero", "saved the factory", 5, 0x0116ec06)
MissionCompleteAchievement("A Rabbit Free Cinema", "clear the cinema", 3, 0x0116ed45)
MissionCompleteAchievement("Devices Gone Wild", "rogue Anti-Pesto devices recovered", 5, 0x0116ebf0)
MissionCompleteAchievement("Goat Hearder", "returned all the goats", 5, 0x0116eb6c)
PestCompleteAchievement("The Farm Pest Problem 1","the farm - 25 pests collected", 3, 0x0116ec32)
PestCompleteAchievement("The Farm Pest Problem 2","the farm - 50 pests collected", 5, 0x0116ec3d)
PestCompleteAchievement("The Farm Pest Problem 3","the farm - 100 pests collected", 10, 0x0116ec48)
PestCompleteAchievement("The Factory Pest Problem 1","the factory - 25 pests collected", 3, 0x0116ec8a)
PestCompleteAchievement("The Factory Pest Problem 2","the factory - 50 pests collected", 5, 0x0116ec95)
PestCompleteAchievement("The Factory Pest Problem 3","the factory - 100 pests collected", 10, 0x0116eca0)
MissionCompleteAchievement("Scrapyard Cleanup","scrapyard cleared of pests", 3, 0x0116eb4b)
MissionCompleteAchievement("Seeds in the Wind","collected Mr Growbag's seeds", 3, 0x0116eb61)
MissionCompleteAchievement("Strange Scrapyard","cleared the scrapyard", 3, 0x0116eb56)
MissionCompleteAchievement("Into The Factory","monorail chase", 5, 0x0116ebc4)
PestCompleteAchievement("The Farm Valve Collector 1", "1st valve collected", 3, 0x0116ec5e)
PestCompleteAchievement("The Farm Valve Collector 2", "2nd valve collected", 5, 0x0116ec69)
PestCompleteAchievement("The Farm Valve Collector 3", "3rd valve collected", 10, 0x0116ec74)
PestCompleteAchievement("The Factory Valve Collector 1", "1st valve collected", 3, 0x0116ecb6)
PestCompleteAchievement("The Factory Valve Collector 2", "2nd valve collected", 5, 0x0116ecc1)
PestCompleteAchievement("The Factory Valve Collector 3", "3rd valve collected", 10, 0x0116eccc)
MissionCompleteAchievement("All Aboard The Rabbit Clearing Express!", "rabbit station", 3, 0x0116ed50)
MissionCompleteAchievement("To Tottington Hall", "the Were-Rabbit chased to Tottington Hall", 5, 0x0116ebcf)
MissionCompleteAchievement("A Dangerous Fairground", "fair cleared for the vegetable competition", 5, 0x0116ee00)
MissionCompleteAchievement("Midnight Adventure", "midnight vegetable visited", 5, 0x0116ee00)
MissionCompleteAchievement("Fairground Cleaned", "fairground cleared of rabbits", 3, 0x0116edf5)
MissionCompleteAchievement("Bunny Shooter", "bag-A-bunny", 4, 0x0116edbe)
MissionCompleteAchievement("Patio Cleanup", "Tottington Hall patio cleared", 4, 0x0116edbe)
MissionCompleteAchievement("Woody Cleanup", "Tottington Hall woods cleared", 5, 0x0116ee21)
MissionCompleteAchievement("Butterfly Chase", "caught the butterfly", 4, 0x0116ee21)
PestCompleteAchievement("The Church Valve Collector 1", "1st valve collected", 3, 0x0116ecb6)
PestCompleteAchievement("The Church Valve Collector 2", "2nd valve collected", 5, 0x0116ecc1)
PestCompleteAchievement("The Church Valve Collector 3", "3rd valve collected", 10, 0x0116eccc)
MissionCompleteAchievement("Mulch Seed Chase", "collected all Mr Mulch's seeds", 3, 0x0116e623)
MissionCompleteAchievement("He Scores!", "football shootout", 4, 0x0116ee0b)
MissionCompleteAchievement("Smashing Job", "crockery smash", 4, 0x0116e9e0)
MissionCompleteAchievement("Hungry Pumpkin", "feed the factory pumpkin", 4, 0x0116ebda)
MissionCompleteAchievement("Pumpkin Delivery", "giant pumpkin ready for the competition", 5, 0x0116ebfb)
MissionCompleteAchievement("Safe Cracker", "Mr Leaching's safes cracked", 3, 0x0116ec11)
MissionCompleteAchievement("Poster Removal", "all were-rabbit posters removed", 3, 0x0116e589)
MissionCompleteAchievement("Notes Blown Away", "returned all PC Mac's notes", 4, 0x0116e69c)
MissionCompleteAchievement("Balloon Rabbits", "bouncy Castle", 4, 0x0116ed9d)
MissionCompleteAchievement("Seed Chaser", "safe collection of all the seeds", 4, 0x0116ed9d)
MissionCompleteAchievement("The Woods Chase", "Were-Rabbit chased through the woods", 5, 0x0116edb3)
MissionCompleteAchievement("The End", "the Were-Rabbit is safe", 25, 0x0116ee84)

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
SpeedrunAchievement("Rodent Remover Speedrunner [m]", "Clear all the rats in the \"churchyard cleared of were-rats\" mission with 1 minutes 47 seconds or more left on the timer", 10, 0x0116e618, 107.0)
SpeedrunAchievement("Ultimate Device Recoverer [m]", "Complete the \"rogue Anti-Pesto devices recovered\" mission with 4 minutes or more left on the timer", 10, 0x0116ebf0, 240.0)

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
HealthAchievement("The Wood Protector [m]", "Keep Jasminder's health at 85 or above when escorting her home", 10, 0x0116e670, 85)
HealthAchievement("The Ultimate Mr Dibber Protection Service [m]", "Keep Mr Dibbers's health at 85 or above when escorting him home", 10, 0x0116e930, 90)
HealthAchievement("The Holy Escort [m]", "Keep Rev Hedges health at 90 or above when escorting him from Wallersey", 10, 0x0116e925, 90)

//Card collections
TotHallCards = byte(0x0116ed87) + byte(0x0116ee42) + byte(0x0116ee4d) + byte(0x0116ee58) + byte(0x0116ee63) + byte(0x0116ee79)
ChurchCards = byte(0x0116e86a) + byte(0x0116e875) + byte(0x0116e880) + byte(0x0116e88b) + byte(0x0116e896) + byte(0x0116e8a1)
TownCenterCards = byte(0x0116e7e6) + byte(0x0116e7f1) + byte(0x0116e7fc) + byte(0x0116e807) + byte(0x0116e812) + byte(0x0116e81d)
ParkCards = byte(0x0116e828) + byte(0x0116e833) + byte(0x0116e83e) + byte(0x0116e849) + byte(0x0116e854) + byte(0x0116e85f)
WoodsCards = byte(0x0116e8ac) + byte(0x0116e8b7) + byte(0x0116e8c2) + byte(0x0116e8cd) + byte(0x0116e8d8) + byte(0x0116e8e3)
TopOfTownCards = byte(0x0116ea17) + byte(0x0116ea22) + byte(0x0116ea2d) + byte(0x0116ea38) + byte(0x0116ea43) + byte(0x0116ea4e)
SeafrontCards = byte(0x0116ea59) + byte(0x0116ea64) + byte(0x0116ea6f) + byte(0x0116ea7a) + byte(0x0116ea90) + byte(0x0116ea9b)
LowerTownCards = byte(0x0116eaa6) + byte(0x0116eab1) + byte(0x0116eabc) + byte(0x0116eac7) + byte(0x0116ead2) + byte(0x0116eadd)
TownCards = byte(0x0116ece2) + byte(0x0116eced) + byte(0x0116ed03) + byte(0x0116ed19) + byte(0x0116ed3a) + byte(0x0116ed45)
IndustrialAreaCards = byte(0x0116ecd7) + byte(0x0116ecf8) + byte(0x0116ed0e) + byte(0x0116ed24) + byte(0x0116ed2f) + byte(0x0116ed50)

function AllCardsAchievement(achTitle, achDesc, cards) {
    achievement(
        title = achTitle,
        description = achDesc,
        points = 10,
        trigger = (
            InGame() &&
            cards == 30 &&
            prev(cards) != 30
        )
    )
}

AllCardsAchievement("100% Tottington Hall", "Collect all 6 cards in Tottington Hall", TotHallCards)
AllCardsAchievement("100% Town Center - Church", "Collect all 6 cards in the area town center - church", ChurchCards)
AllCardsAchievement("100% Town Center - Town Center", "Collect all 6 cards in the area town center - town center", TownCenterCards)
AllCardsAchievement("100% Town Center - Park", "Collect all 6 cards in the area town center - park", ParkCards)
AllCardsAchievement("100% Town Center - Woods", "Collect all 6 cards in the area town center - woods", WoodsCards)
AllCardsAchievement("100% Wallersey - Top of Town", "Collect all 6 cards in the area Wallersey - top of town", TopOfTownCards)
AllCardsAchievement("100% Wallersey - Seafront", "Collect all 6 cards in the area Wallersey - seafront", SeafrontCards)
AllCardsAchievement("100% Wallersey - Lower Town", "Collect all 6 cards in the area Wallersey - lower town", LowerTownCards)
AllCardsAchievement("100% Grimsley - Town", "Collect all 6 cards in the area Grimsley - town", TownCards)
AllCardsAchievement("100% Grimsley - Industrial Area", "Collect all 6 cards in the area Grimsley - industrial area", IndustrialAreaCards)

//Shop purchases
function ShopAchievement(achTitle, achDesc, itemAddr, points) {
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            InGame() &&
            byte(itemAddr) == 0x01 &&
            prev(byte(itemAddr)) == 0x00
        )
    )
}

MusicThemesPurchased = 
byte(0x0116f964) + byte(0x0116fa2c) + byte(0x0116faf4) + byte(0x0116fbbc) + byte(0x0116fc84) + byte(0x0116fd4c) + byte(0x0116fe14) + 
byte(0x0116fedc) + byte(0x0116ffa4) + byte(0x0117006c) + byte(0x01170134) + byte(0x011701fc) + byte(0x011702c4) + byte(0x0117038c)

function MusicAchievement(achTitle, achDesc, count) {
    achievement(
        title = achTitle,
        description = achDesc,
        points = 10,
        trigger = (
            InGame() &&
            MusicThemesPurchased == count &&
            prev(MusicThemesPurchased) == count - 1
        )
    )
}

ShopAchievement("Soothing Music", "Purchase the gramophone from the shop", 0x0116f89c, 5)
ShopAchievement("Hydration Hero", "Purchase the watering can from the shop", 0x01170e7c, 5)
ShopAchievement("It's Getting Hot in Here!", "Purchase the thermostat from the shop", 0x011717dc, 5)
MusicAchievement("Music Collector", "Purchase half the music available in the shop", 7)
MusicAchievement("Music Maestro", "Purchase all of the music available in the shop", 14)

achievement(
    title = "Cracking Job Lad! [m]",
    description = "Grow the Marrow to the maximum size before starting the vegetable competition",
    points = 25,
    trigger = (
        InGame() &&
        float(0x011abe50) == 160.0 &&
        prev(float(0x011abe50)) < 160.0 &&
        byte(0x0116edb3) != 0x05
    )
)