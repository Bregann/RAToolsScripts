// LEGO Harry Potter: Years 1-4
// #ID = 3037

//Level stuff
LevelID = byte(0x9ddcb0)

PrivetDrive=0x03
GringottsVaults=0x04
ShoppingInDiagonAlley=0x05
Platform934=0x06
GryffindorHouse=0x08
Transfiguration=0x09
FlyingLesson=0x0a
TheTrophyRoom=0x0b
TheMountainTroll=0x0c
Incendio=0x0d
PotionsClass=0x0e
TheQuidditchMatch=0x0f
TheResstrictedSection=0x11
TheLumosCharm=0x12
TheForbiddenForest=0x14
TheForbiddenCorridor=0x16
TheBurrow=0x17
BorginAndBurkes=0x18
ArrestoMomento=0x1b
CollectingIngredients=0x1f
TheDuellingClub=0x20
ThePolyjuicePotion=0x24
TheSlytherinCommonRoom=0x25
TheRevelioCharm=0x26
TomRiddlesDiary=0x27
TheDescendoCharm=0x28
TheSpiderHollow=0x29
TheChamberOfSecrets=0x2d
TheHogwartsExpress=0x2f
CareOfMagicalCreatures=0x30
BanishingBoggarts=0x31
HogsmeadeVillage=0x34
ThePatronusCharm=0x35
PursuingPeterPettigrew=0x36
TheShriekingShack=0x37
TheTimeTurner=0x3b
FreeingSirius=0x3c
TheQuidditchWorldCup=0x3d
TheSummoningCharm=0x3e
UnlockingOWLRevision=0x3f
TheFirstTask=0x41
ThePrefectsBathroom=0x42
TheSecondTask=0x43
TheThirdTask=0x44

//True Wizard
TrueWizardInLevels = 
bit3(0x9e2a1a) + bit7(0x9e2a1b) + bit3(0x9e2a1c) + bit7(0x9e2a1c) + 
bit3(0x9e2a1d) + bit3(0x9e2a1e) + bit7(0x9e2a1e) + bit3(0x9e2a1f) + 
bit7(0x9e2a1f) + bit3(0x9e2a20) + bit7(0x9e2a20) + bit3(0x9e2a21) + 
bit7(0x9e2a21) + bit7(0x9e2a22) + bit3(0x9e2a23) + bit3(0x9e2a24) + 
bit3(0x9e2a25) + bit7(0x9e2a25) + bit3(0x9e2a26) + bit7(0x9e2a27) + 
bit7(0x9e2a29) + bit3(0x9e2a2a) + bit3(0x9e2a2c) + bit7(0x9e2a2c) + 
bit3(0x9e2a2d) + bit7(0x9e2a2d) + bit3(0x9e2a2e) + bit7(0x9e2a2e) + 
bit7(0x9e2a30) + bit7(0x9e2a31) + bit3(0x9e2a32) + bit7(0x9e2a32) + 
bit3(0x9e2a34) + bit7(0x9e2a34) + bit3(0x9e2a35) + bit7(0x9e2a35) + 
bit7(0x9e2a37) + bit3(0x9e2a38) + bit7(0x9e2a38) + bit3(0x9e2a39) + 
bit7(0x9e2a39) + bit7(0x9e2a3a) + bit3(0x9e2a3b) + bit7(0x9e2a3b)

//Wizard Hats
WizardHatsUnlocked = 
bitcount(0x9e2a3c) + bitcount(0x9e2a3d) + bitcount(0x9e2a3e) + bitcount(0x9e2a3f) + 
bitcount(0x9e2a40) + bitcount(0x9e2a41) + bitcount(0x9e2a42) + bitcount(0x9e2a43) + 
bitcount(0x9e2a44) + bitcount(0x9e2a45) + bitcount(0x9e2a46) + bitcount(0x9e2a47) + 
bitcount(0x9e2a48) + bitcount(0x9e2a49) + bitcount(0x9e2a4a) + bitcount(0x9e2a4b) + 
bitcount(0x9e2a4c) + bitcount(0x9e2a4d) + bitcount(0x9e2a4e) + bitcount(0x9e2a4f) + 
bitcount(0x9e2a50) + bitcount(0x9e2a51) + TrueWizardInLevels

//Wizard Cards
WizardCardsUnlocked = 
bitcount(0x9e2a58) + bitcount(0x9e2a59) + bitcount(0x9e2a5a) + bitcount(0x9e2a5b) +
bitcount(0x9e2a5c) + bitcount(0x9e2a5d) + bitcount(0x9e2a5e) + bitcount(0x9e2a5f) +
bitcount(0x9e2a60) + bitcount(0x9e2a61) + bitcount(0x9e2a62)

//Redbricks found
RedbricksFound = 
bitcount(0x9e2a54) + bit0(0x9e2a55) + bit1(0x9e2a55) + bit2(0x9e2a55) +
bit3(0x9e2a55) + bit4(0x9e2a55) + bit5(0x9e2a55) + bit6(0x9e2a55)

//Shop items
//Hints
HintsPurchased = 
bitcount(0x9e29e8) + bitcount(0x9e29e9) + bitcount(0x9e29ea) + bitcount(0x9e29eb) + 
bitcount(0x9e29ec) + bitcount(0x9e29ed) + bitcount(0x9e29ee) + bitcount(0x9e29ef) + 
bit0(0x9e29f0) + bit1(0x9e29f0) + bit2(0x9e29f0) + bit3(0x9e29f0)

//Characters
CharactersPurchased = 
bit1(0x9e29f6) + bit3(0x9e29f6) + bit5(0x9e29f6) + bit7(0x9e29f6) + bit1(0x9e29f7) + 
bit3(0x9e29f7) + bit5(0x9e29f7) + bit7(0x9e29f7) + bit1(0x9e29f8) + bit3(0x9e29f8) + 
bit5(0x9e29f8) + bit7(0x9e29f8) + bit1(0x9e29f9) + bit3(0x9e29f9) + bit5(0x9e29f9) + 
bit7(0x9e29f9) + bit1(0x9e29fa) + bit3(0x9e29fa) + bit5(0x9e29fa) + bit7(0x9e29fa) + 
bit1(0x9e29fb) + bit3(0x9e29fb) + bit5(0x9e29fb) + bit7(0x9e29fb) + bit1(0x9e29fc) + 
bit3(0x9e29fc) + bit5(0x9e29fc) + bit7(0x9e29fc) + bit1(0x9e29fd) + bit3(0x9e29fd) + 
bit5(0x9e29fd) + bit7(0x9e29fd) + bit1(0x9e29fe) + bit3(0x9e29fe) + bit5(0x9e29fe) + 
bit7(0x9e29fe) + bit1(0x9e29ff) + bit3(0x9e29ff) + bit7(0x9e29ff) + bit1(0x9e2a00) + 
bit5(0x9e2a00) + bit7(0x9e2a00) + bit1(0x9e2a01) + bit3(0x9e2a01) + bit5(0x9e2a01) + 
bit7(0x9e2a01) + bit1(0x9e2a02) + bit3(0x9e2a02) + bit7(0x9e2a02) + bit1(0x9e2a03) + 
bit3(0x9e2a03) + bit5(0x9e2a03) + bit7(0x9e2a03) + bit1(0x9e2a04) + bit3(0x9e2a04) + 
bit5(0x9e2a04) + bit7(0x9e2a04) + bit1(0x9e2a05) + bit3(0x9e2a05) + bit5(0x9e2a05) + 
bit7(0x9e2a05) + bit3(0x9e2a06) + bit5(0x9e2a06) + bit7(0x9e2a06) + bit1(0x9e2a07) + 
bit3(0x9e2a07) + bit5(0x9e2a07) + bit7(0x9e2a07) + bit1(0x9e2a08) + bit3(0x9e2a08) + 
bit5(0x9e2a08) + bit1(0x9e2a09) + bit3(0x9e2a09) + bit5(0x9e2a09) + bit7(0x9e2a09) + 
bit1(0x9e2a0a) + bit5(0x9e2a0a) + bit7(0x9e2a0a) + bit1(0x9e2a0b) + bit3(0x9e2a0b) + 
bit5(0x9e2a0b) + bit7(0x9e2a0b) + bit1(0x9e2a0c) + bit3(0x9e2a0c) + bit5(0x9e2a0c) + 
bit7(0x9e2a0c) + bit1(0x9e2a0d) + bit3(0x9e2a0d) + bit5(0x9e2a0d) + bit7(0x9e2a0d) + 
bit1(0x9e2a0e) + bit3(0x9e2a0e) + bit5(0x9e2a0e) + bit7(0x9e2a0e) + bit1(0x9e2a0f) + 
bit3(0x9e2a0f) + bit5(0x9e2a0f) + bit7(0x9e2a0f) + bit1(0x9e2a10) + bit3(0x9e2a10) + 
bit1(0x9e2a11) + bit5(0x9e2a11) + bit7(0x9e2a11) + bit1(0x9e2a12) + bit3(0x9e2a12) + 
bit5(0x9e2a12) + bit7(0x9e2a12) + bit1(0x9e2a13)

//Red bricks
RedbricksPurchased = 
bitcount(0x9e2a56) + bit0(0x9e2a57) + bit1(0x9e2a57) + bit2(0x9e2a57) +
bit3(0x9e2a57) + bit4(0x9e2a57) + bit5(0x9e2a57) + bit6(0x9e2a57)


// ================================
// Level Completions
// ================================

function IsLevelCompleted(addr, bitNum)
{
    if(bitNum == 1)
    {
        return bit1(addr) == 0x01 && prev(bit1(addr)) == 0x00
    }
    else
    {
        return bit5(addr) == 0x01 && prev(bit5(addr)) == 0x00
    }
}

function LevelCompleteAchievement(achName, levelName, levelId, points, levelAddr, bitNum)
{
    achievement (
        title = achName,
        description = "Complete level " + levelName,
        points = points,
        trigger = (
            LevelID == levelId &&
            IsLevelCompleted(levelAddr, bitNum)
        )
    )
}

LevelCompleteAchievement("The Beginning", "Privet Drive", PrivetDrive, 3, 0x9e2a1a, 1)
LevelCompleteAchievement("A Trip to Gringotts", "Gringotts Vaults", GringottsVaults, 3, 0x9e2a1b, 5)
LevelCompleteAchievement("Shopping Spree!", "Shopping In Diagon Alley", ShoppingInDiagonAlley, 3, 0x9e2a1c, 1)
LevelCompleteAchievement("All Aboard", "Platform 9 3/4", Platform934, 3, 0x9e2a1c, 5)
LevelCompleteAchievement("Gryffindor House", "Gryffindor House", GryffindorHouse, 3, 0x9e2a1d, 1) //to confirm
LevelCompleteAchievement("Transfiguration", "Transfiguration", Transfiguration, 2, 0x9e2a1e, 1)
LevelCompleteAchievement("I Can Fly!", "Flying Lesson", FlyingLesson, 3, 0x9e2a1e, 5)
LevelCompleteAchievement("An Award Winning School", "The Trophy Room", TheTrophyRoom, 3, 0x9e2a1f, 1)
LevelCompleteAchievement("The Troll in the Bathroom", "The Mountain Troll", TheMountainTroll, 3, 0x9e2a1f, 5)
LevelCompleteAchievement("Burn Baby Burn", "Incendio", Incendio, 2, 0x9e2a20, 1)
LevelCompleteAchievement("It's Brewing Time", "Potions Class", PotionsClass, 2, 0x9e2a20, 5)
LevelCompleteAchievement("A Malfunctioning Broom", "The Quidditch Match", TheQuidditchMatch, 3, 0x9e2a21, 1)
LevelCompleteAchievement("A Top Secret Area", "The Restricted Section", TheResstrictedSection, 3, 0x9e2a21, 5)
LevelCompleteAchievement("Now I Can See!", "The Lumos Charm", TheLumosCharm, 2, 0x9e2a22, 5)
LevelCompleteAchievement("The Forbidden Forest", "The Forbidden Forest", TheForbiddenForest, 3, 0x9e2a23, 1)
LevelCompleteAchievement("The Home of Fluffy", "The Forbidden Corridor", TheForbiddenCorridor, 3, 0x9e2a24, 1)
LevelCompleteAchievement("The Burrow", "The Burrow", TheBurrow, 3, 0x9e2a25, 1)
LevelCompleteAchievement("This Isn't Diagon Alley", "Borgin And Burkes", BorginAndBurkes, 3, 0x9e2a25, 5)
LevelCompleteAchievement("Arresto Momento", "Arresto Momento", ArrestoMomento, 2, 0x9e2a26, 1)
LevelCompleteAchievement("Collecting Ingredients", "Collecting Ingredients", CollectingIngredients, 3, 0x9e2a27, 5)
LevelCompleteAchievement("The Best Club Around", "The Duelling Club", TheDuellingClub, 3, 0x9e2a29, 5)
LevelCompleteAchievement("Changing Appearance", "The Polyjuice Potion", ThePolyjuicePotion, 3, 0x9e2a2a, 1)
LevelCompleteAchievement("Slytherin in the Room", "The Slytherin Common Room", TheSlytherinCommonRoom, 3, 0x9e2a2c, 1)
LevelCompleteAchievement("All Will Be Revealed", "The Revelio Charm", TheRevelioCharm, 2, 0x9e2a2c, 5)
LevelCompleteAchievement("It's Blank!", "Tom Riddles Diary", TomRiddlesDiary, 3, 0x9e2a2d, 1)
LevelCompleteAchievement("Descendo", "The Descendo Charm", TheDescendoCharm, 2, 0x9e2a2d, 5)
LevelCompleteAchievement("Visiting Aragog", "The Spider Hollow", TheSpiderHollow, 3, 0x9e2a2e, 1)
LevelCompleteAchievement("The Chamber of Secrets Has Been Opened", "The Chamber of Secrets", TheChamberOfSecrets, 3, 0x9e2a2e, 5)
LevelCompleteAchievement("An Unwelcome Visit", "The Hogwarts Express", TheHogwartsExpress, 3, 0x9e2a30, 5)
LevelCompleteAchievement("Meeting Buckbeak", "Care of Magical Creatures", CareOfMagicalCreatures, 3, 0x9e2a31, 5)
LevelCompleteAchievement("Riddikulus!", "Banishing Boggarts", BanishingBoggarts, 3, 0x9e2a32, 1)
LevelCompleteAchievement("All Roads Lead To Hogsmeade", "Hogsmeade Village", HogsmeadeVillage, 3, 0x9e2a32, 5)
LevelCompleteAchievement("The Patronus Charm", "The Patronus Charm", ThePatronusCharm, 3, 0x9e2a34, 1)
LevelCompleteAchievement("Ratcatchers", "Pursuing Peter Pettigrew", PursuingPeterPettigrew, 3, 0x9e2a34, 5)
LevelCompleteAchievement("The Shrieking Shack", "The Shrieking Shack", TheShriekingShack, 3, 0x9e2a35, 1)
LevelCompleteAchievement("If I Could Turn Back Time", "The Time Turner", TheTimeTurner, 3, 0x9e2a35, 5)
LevelCompleteAchievement("Sirius Is Free", "Freeing Sirius", FreeingSirius, 3, 0x9e2a37, 5)
LevelCompleteAchievement("The Quidditch World Cup", "The Quidditch World Cup", TheQuidditchWorldCup, 3, 0x9e2a38, 1)
LevelCompleteAchievement("Accio", "The Summoning Charm", TheSummoningCharm, 2, 0x9e2a38, 5)
LevelCompleteAchievement("Unlocking O.W.L Revision", "Unlocking O.W.L Revision", UnlockingOWLRevision, 3, 0x9e2a39, 1)
LevelCompleteAchievement("The Dragon Egg", "The First Task", TheFirstTask, 3, 0x9e2a39, 5)
LevelCompleteAchievement("Unlocking the Secret of the Egg", "The Prefects Bathroom", ThePrefectsBathroom, 3, 0x9e2a3a, 5)
LevelCompleteAchievement("An Underwater Adventure", "The Second Task", TheSecondTask, 3, 0x9e2a3b, 1)
LevelCompleteAchievement("The Maze to the Cup", "The Third Task", TheThirdTask, 3, 0x9e2a3b, 5)

// ================================
// Level Bonus stuff (wizard cards, true wizard, redbricks)
// ================================

function LevelCollectibles(achName, achDesc, points, collectible, collectibleAmount, prevCollectibleAmount)
{
    achievement(
        title = achName,
        description = achDesc,
        points = points,
        trigger = (
            LevelID != 0x00 &&
            collectible == collectibleAmount &&
            prev(collectible) <= prevCollectibleAmount
        )
    )
}

LevelCollectibles("Stud Collector", "Reach true wizard in half of the levels", 10, TrueWizardInLevels, 0x16, 0x15)
LevelCollectibles("Full Gringotts Vault", "Reach true wizard in all of the levels", 25, TrueWizardInLevels, 0x2c, 0x2b)
LevelCollectibles("Wizard Hat Fanatic", "Collect half of the wizard hats in the game", 10, WizardHatsUnlocked, 0x6e, 0x6d)
LevelCollectibles("The Master of Hats", "Collect all of the wizard hats in the game", 25, WizardHatsUnlocked, 0xdc, 0xdb)
LevelCollectibles("Wizard Card Whiz", "Collect half of the wizard cards in the game", 10, WizardHatsUnlocked, 0x2C, 0x2B)
LevelCollectibles("Ultimate Card Collector", "Collect all of the wizard cards in the game", 25, WizardCardsUnlocked, 0x58, 0x57)
LevelCollectibles("Accio Red Brick", "Collect all of the red bricks in the game", 25, RedbricksFound, 0x0f, 0x0e)

// ================================
// Shop stuff
// ================================

function ShopPurchases(achName, achDesc, points, purchaseItem, purchaseAmount, prevPurchaseAmount)
{
    achievement(
        title = achName,
        description = achDesc,
        points = points,
        trigger = (
            LevelID == 0x00 &&
            purchaseItem == purchaseAmount &&
            prev(purchaseItem) == prevPurchaseAmount
        )
    )
}

ShopPurchases("Ready For My O.W.Ls", "Purchase all the hints from the shop", 10, HintsPurchased, 0x44, 0x43)
ShopPurchases("The Great Red Brick Magician", "Purchase all the red bricks from the shop", 10, RedbricksPurchased, 0x0f, 0x0e)
ShopPurchases("Dumbledores Army", "Purchase all the characters shop", 25, CharactersPurchased, 0x6b, 0x6a)