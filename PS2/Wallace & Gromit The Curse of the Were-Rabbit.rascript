// Wallace & Gromit: The Curse of the Were-Rabbit
// #ID = 21933

function InGame() => byte(0x008b160c) != 0x04
function InGamePest() => byte(0x008b160c) == 0x08
function MissionComplete(cardAddr) => byte(cardAddr) == 0x05 && (prev(byte(cardAddr)) == 0x03 || prev(byte(cardAddr)) == 0x04)
function PestMissionComplete(cardAddr) => byte(cardAddr) == 0x05 && prev(byte(cardAddr)) != 0x05
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
            InGamePest() &&
            PestMissionComplete(cardAddr)
        )
    )
}

MissionCompleteAchievement("A Rabbit Free Lawn", "Front Lawn Cleared", 2, 0x0116ed5b)
MissionCompleteAchievement("Pumpkin Protector", "Cleared the Walled Garden", 2, 0x0116ed66)
MissionCompleteAchievement("Statue Removal Service", "Returned Lady Tottington's Statues", 2, 0x0116ed71)
MissionCompleteAchievement("I Baked You a Pie", "Ingredients Collected For Mrs Mulch's Pie", 2, 0x0116e6bd)
MissionCompleteAchievement("West Wallaby Street Rabbit Cleaner", "West Wallaby St Rabbits Removed", 2, 0x0116e60d)
MissionCompleteAchievement("The Bank Organiser", "Bank Veg Sorted", 3, 0x0116e644)
MissionCompleteAchievement("No Posters Left", "Were-rabbit Posters Removed", 2, 0x0116e4fa)
MissionCompleteAchievement("They See Me Rolling", "Barrels Delivered To The Customers", 2, 0x0116e602)
PestCompleteAchievement("A Back Garden Pest Problem 1", "The Back Gardens - 25 Pests Collected", 3, 0x0116e46b)
PestCompleteAchievement("A Back Garden Pest Problem 2", "the back gardens - 50 Pests Collected", 5, 0x0116e476)
PestCompleteAchievement("A Back Garden Pest Problem 3", "the back gardens - 100 Pests Collected", 10, 0x0116e481)
MissionCompleteAchievement("Rabbit Free Town Hall", "Town hall Cleared", 2, 0x0116e4ce)
MissionCompleteAchievement("Rex Racer", "Beat Rex Leaching", 2, 0x0116e4d9)
MissionCompleteAchievement("Master Mechanic", "Winnie's Van Fixed", 2, 0x0116e70a)
MissionCompleteAchievement("The Woo-Rabbit", "Lady Were-rabbit Success", 3, 0x0116e455)
MissionCompleteAchievement("Were-Rabbit Spotted", "Wallace is the Were-Rabbit!", 5, 0x0116e65a)
MissionCompleteAchievement("Device Destroyer", "First Diabolical Device Destroyed", 2, 0x0116e4c3)
MissionCompleteAchievement("Take Me to Church", "Mrs Windfall Safely Reached the Church", 3, 0x0116e6b2)
MissionCompleteAchievement("Bank Bodyguard", "The Bank is Safe", 2, 0x0116e6a7)
MissionCompleteAchievement("Pitch Invaders Defeated", "Rex is Safe", 2, 0x0116e62e)
MissionCompleteAchievement("Defender of Vegetables", "Mrs Windfall's Veg is Safe", 2, 0x0116e4e4)
MissionCompleteAchievement("Cracking Football Player!", "Bullseye!", 3, 0x0116e573)
MissionCompleteAchievement("Hattrick!", "3 Goals Scored", 2, 0x0116e57e)
MissionCompleteAchievement("Blessed Gardens", "Churchyard Cleared of Pests", 3, 0x0116e64f)
MissionCompleteAchievement("Holy Water Secured", "Returned The Vicar's Bottles", 3, 0x0116e686)
PestCompleteAchievement("Back Garden Valve Collector 1", "1st Valve Collected", 3, 0x0116e497)
PestCompleteAchievement("Back Garden Valve Collector 2", "2nd Valve Collected", 5, 0x0116e4a2)
PestCompleteAchievement("Back Garden Valve Collector 3", "3rd Valve Collected", 10, 0x0116e4ad)
MissionCompleteAchievement("Not The Pumpkins!", "Were-Rabbit Chaased to Wallersey", 5, 0x0116e6ff)
PestCompleteAchievement("The Church Pest Problem 1","The Churchyard - 25 Pests Collected", 3, 0x0116e74c)
PestCompleteAchievement("The Church Pest Problem 2","The Churchyard - 50 Pests Collected", 5, 0x0116e757)
PestCompleteAchievement("The Church Pest Problem 3","The Churchyard - 100 Pests Collected", 10, 0x0116e762)
MissionCompleteAchievement("Rodent Remover","Churchyard Cleared of Were-rats", 3, 0x0116e618)
MissionCompleteAchievement("Buzz Off!","Town Square Cleared of Were-bees", 3, 0x0116e665)
MissionCompleteAchievement("Look at All Those Chickens","All of Growbag's Chickens Returned", 3, 0x0116e67b)
MissionCompleteAchievement("Woods Cleanup","Woods Cleared of Pests", 4, 0x0116e639)
MissionCompleteAchievement("A Walk Through the Woods","Jasminder Returned Home Safely", 4, 0x0116e670)
MissionCompleteAchievement("Power Provider","Growbag's Generator Restarted", 3, 0x0116e691)
MissionCompleteAchievement("Apple Delivery","Mrs Mulch Home Safe", 4, 0x0116e4ef)
MissionCompleteAchievement("Shaun the Sheep","Sheep and Goats All Penned", 4, 0x0116e6f4)
MissionCompleteAchievement("Wallersey Rabbit Removal","Wallersey - Clear The Rabbits", 3, 0x0116ea4e)
MissionCompleteAchievement("Bunny Hopper Adventure","Dibber's Ornaments Returned Safely", 5, 0x0116e9b4)
MissionCompleteAchievement("Leeky Vents","Nursery Veg Saved", 4, 0x0116e8ee)
MissionCompleteAchievement("Wallersey Lower Towns Rabbits Cleared","Wallersey - Lower Town - Rabbits!", 3, 0x0116ead2)
MissionCompleteAchievement("Doll Collector","Find 10 Dolls", 3, 0x0116e9d5)
MissionCompleteAchievement("Mole Masher","Whack-a-Mole", 4, 0x0116e95c)
MissionCompleteAchievement("Bell Bonger","Beaten Alfie Crock", 3, 0x0116e90f)
MissionCompleteAchievement("A Little Old Lady and Her Giant Marrow","Betty's Veg is Saved", 3, 0x0116e988)
PestCompleteAchievement("The Allotments Pest Problem 1","The Allotments - 25 Pests Collected", 3, 0x0116eafe)
PestCompleteAchievement("The Allotments Pest Problem 2","The Allotments - 50 Pests Collected", 5, 0x0116eb09)
PestCompleteAchievement("The Allotments Pest Problem 3","The Allotments - 100 Pests Collected", 10, 0x0116eb14)
MissionCompleteAchievement("Rabbit Rabbit Pumpkin","Duckshoot", 5, 0x0116e972)
MissionCompleteAchievement("Ultimate Veg Sorter","Successful Veg Sorting", 4, 0x0116e8f9)
MissionCompleteAchievement("Seed Stealer","Found Harriet's Seeds", 3, 0x0116e993)
MissionCompleteAchievement("Mr Dibber Escort","Mr Dibber Safely Reached His House", 4, 0x0116e930)
MissionCompleteAchievement("Where's My Keys?","Found Mr Dibber's Keys", 3, 0x0116e9ca)
MissionCompleteAchievement("Were-Rabbits In The Harbour","Harbor Opened", 4, 0x0116e93b)
PestCompleteAchievement("The Allotments Valve Collector 1", "1st Valve Collected", 3, 0x0116eb2a)
PestCompleteAchievement("The Allotments Valve Collector 2", "2nd Valve Collected", 5, 0x0116eb35)
PestCompleteAchievement("The Allotments Valve Collector 3", "3rd Valve Collected", 10, 0x0116eb40)
MissionCompleteAchievement("Into Grimsley", "Were-Rabbit Chased to Grimsley", 5, 0x0116e9bf)
MissionCompleteAchievement("Blessed Wallersey Escort", "Vicar Safely Escorted From Wallersey", 5, 0x0116e925)
MissionCompleteAchievement("Rabbit Ship", "Pests Removed From the Boat", 3, 0x0116e946)
MissionCompleteAchievement("The Vent Hopper", "Hopped Up the Boat", 3, 0x0116e91a)
MissionCompleteAchievement("No Messages in These Bottles", "Collected All the Veg-B-Big bottles", 5, 0x0116e99e)
MissionCompleteAchievement("Cleaned Steamer", "Rob's Steamer Is Safe", 4, 0x0116e951)
MissionCompleteAchievement("Factory Fired Up!", "Factory Restarted", 5, 0x0116ebe5)
MissionCompleteAchievement("Underground Rabbits", "Rabbit Warren", 3, 0x0116ecd7)
MissionCompleteAchievement("Factoy Hero", "Saved the Factory", 5, 0x0116ec06)
MissionCompleteAchievement("A Rabbit Free Cinema", "Clear the Cinema", 3, 0x0116ed45)
MissionCompleteAchievement("Devices Gone Wild", "Rogue Anti-Pesto Devices Recovered", 5, 0x0116ebf0)
MissionCompleteAchievement("Goat Hearder", "Returned all the Goats", 5, 0x0116eb6c)
PestCompleteAchievement("The Farm Pest Problem 1","The farm - 25 Pests Collected", 3, 0x0116ec32)
PestCompleteAchievement("The Farm Pest Problem 2","The farm - 50 Pests Collected", 5, 0x0116ec3d)
PestCompleteAchievement("The Farm Pest Problem 3","The farm - 100 Pests Collected", 10, 0x0116ec48)
PestCompleteAchievement("The Factory Pest Problem 1","The factory - 25 Pests Collected", 3, 0x0116ec8a)
PestCompleteAchievement("The Factory Pest Problem 2","The factory - 50 Pests Collected", 5, 0x0116ec95)
PestCompleteAchievement("The Factory Pest Problem 3","The factory - 100 Pests Collected", 10, 0x0116eca0)
MissionCompleteAchievement("Scrapyard Cleanup","Scrapyard Cleared of Pests", 3, 0x0116eb4b)
MissionCompleteAchievement("Seeds in the Wind","Collected Mr Growbag's Seeds", 3, 0x0116eb61)
MissionCompleteAchievement("Strange Scrapyard","Cleared the Scrapyard", 3, 0x0116eb56)
MissionCompleteAchievement("Into The Factory","Monorail Chase", 5, 0x0116ebc4)
PestCompleteAchievement("The Farm Valve Collector 1", "1st Valve Collected", 3, 0x0116ec5e)
PestCompleteAchievement("The Farm Valve Collector 2", "2nd Valve Collected", 5, 0x0116ec69)
PestCompleteAchievement("The Farm Valve Collector 3", "3rd Valve Collected", 10, 0x0116ec74)
PestCompleteAchievement("The Factory Valve Collector 1", "1st Valve Collected", 3, 0x0116ecb6)
PestCompleteAchievement("The Factory Valve Collector 2", "2nd Valve Collected", 5, 0x0116ecc1)
PestCompleteAchievement("The Factory Valve Collector 3", "3rd Valve Collected", 10, 0x0116eccc)
MissionCompleteAchievement("All Aboard The Rabbit Clearing Express!", "Rabbit Station", 3, 0x0116ed50)
MissionCompleteAchievement("To Tottington Hall", "The Were-Rabbit Chased to Tottington Hall", 5, 0x0116ebcf)
MissionCompleteAchievement("A Dangerous Fairground", "Fair Cleared For The Vegetable Competition", 5, 0x0116ee00)
MissionCompleteAchievement("Midnight Adventure", "Midnight Vegetable Visited", 5, 0x0116ee00)
MissionCompleteAchievement("Fairground Cleaned", "Fairground Cleared of Rabbits", 3, 0x0116edf5)
MissionCompleteAchievement("Bunny Shooter", "Bag-A-Bunny", 4, 0x0116edbe)
MissionCompleteAchievement("Patio Cleanup", "Tottington Hall Patio Cleared", 4, 0x0116edbe)
MissionCompleteAchievement("Woody Cleanup", "Tottington Hall Woods Cleared", 5, 0x0116ee21)
MissionCompleteAchievement("Butterfly Chase", "Caught the Butterfly", 4, 0x0116ee21)
PestCompleteAchievement("The Church Valve Collector 1", "1st Valve Collected", 3, 0x0116e799)
PestCompleteAchievement("The Church Valve Collector 2", "2nd Valve Collected", 5, 0x0116e7a4)
PestCompleteAchievement("The Church Valve Collector 3", "3rd Valve Collected", 10, 0x0116e7af)
MissionCompleteAchievement("Mulch Seed Chase", "Collected all Mr Mulch's Seeds", 3, 0x0116e623)
MissionCompleteAchievement("He Scores!", "Football Shootout", 4, 0x0116ee0b)
MissionCompleteAchievement("Smashing Job", "Crockery Smash", 4, 0x0116e9e0)
MissionCompleteAchievement("Hungry Pumpkin", "Feed the Factory Pumpkin", 4, 0x0116ebda)
MissionCompleteAchievement("Pumpkin Delivery", "Giant Pumpkin Ready For the Competition", 5, 0x0116ebfb)
MissionCompleteAchievement("Safe Cracker", "Mr Leaching's Safes Cracked", 3, 0x0116ec11)
MissionCompleteAchievement("Poster Removal", "All Were-rabbit Posters Removed", 3, 0x0116e589)
MissionCompleteAchievement("Notes Blown Away", "Returned all PC Mac's Notes", 4, 0x0116e69c)
MissionCompleteAchievement("Balloon Rabbits", "Bouncy Castle", 4, 0x0116ed9d)
MissionCompleteAchievement("Seed Chaser", "Safe Collection of All The Seeds", 4, 0x0116ed9d)

//Couldn't be bothered to make a seperate method for these 2, they behave differently but the pest method works lol
PestCompleteAchievement("The Woods Chase", "Were-Rabbit chased through the woods", 5, 0x0116edb3)
PestCompleteAchievement("The End", "the Were-Rabbit is safe", 25, 0x0116ee84)

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
HealthAchievement("The Wood Protector [m]", "Keep Jasminder's health at 75 or above when escorting her home", 10, 0x0116e670, 75)
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
            (prev(cards) >= 20 && prev(cards) != 30)
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
    description = "Grow the Marrow to the maximum size (63.0\") before starting the vegetable competition",
    points = 25,
    trigger = (
        InGame() &&
        float(dword(0x005566b0)) >= 159.87 &&
        prev(float(dword(0x005566b0))) < 159.87 &&
        byte(0x0116edb3) != 0x05
    )
)