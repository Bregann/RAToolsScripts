// LEGO Harry Potter: Years 5-7
// #ID = 3038

LevelID = byte(0xae35ee)
DuelSelected = byte(0xae3074)

//True Wizard
TrueWizardInLevels = 
bit3(0xaebe67) + bit1(0xaebe6b) + bit3(0xaebe73) + bit5(0xaebe7b) +
bit1(0xaebe83) + bit7(0xaebe86) + bit3(0xaebe8b) + bit5(0xaebe90) +
bit5(0xaebe96) + bit1(0xaebe9b) +
bit7(0xaebe9e) + bit5(0xaebea2) + bit3(0xaebea6) + bit1(0xaebeaa)

//Wizard Hats
WizardHatsCollected = 
bitcount(0xaebeaf) + bitcount(0xaebeb0) + bitcount(0xaebeb1) +
bitcount(0xaebeb2) + bitcount(0xaebeb3) + bitcount(0xaebeb4) +
bitcount(0xaebeb5) + bit0(0xaebeb6) + bit1(0xaebeb6) + bit2(0xaebeb6) 
+ TrueWizardInLevels

//Red bricks
RedBricksFound = 
bitcount(0xaebeb9) + bit0(0xaebeba) + bit1(0xaebeba) + bit2(0xaebeba) +
bit3(0xaebeba) + bit4(0xaebeba) + bit5(0xaebeba)

//Character unlocks
CharactersUnlocked = 
bit0(0xaebe25) + bit2(0xaebe25) + bit4(0xaebe25) + bit6(0xaebe25) + bit0(0xaebe26) + 
bit2(0xaebe26) + bit4(0xaebe26) + bit6(0xaebe26) + bit0(0xaebe27) + bit2(0xaebe27) + 
bit4(0xaebe27) + bit6(0xaebe27) + bit0(0xaebe28) + bit2(0xaebe28) + bit4(0xaebe28) + 
bit6(0xaebe28) + bit0(0xaebe29) + bit2(0xaebe29) + bit4(0xaebe29) + bit6(0xaebe29) + 
bit0(0xaebe2a) + bit2(0xaebe2a) + bit4(0xaebe2a) + bit6(0xaebe2a) + bit0(0xaebe2b) + 
bit2(0xaebe2b) + bit4(0xaebe2b) + bit6(0xaebe2b) + bit0(0xaebe2c) + bit2(0xaebe2c) + 
bit4(0xaebe2c) + bit6(0xaebe2c) + bit0(0xaebe2d) + bit2(0xaebe2d) + bit4(0xaebe2d) + 
bit6(0xaebe2d) + bit0(0xaebe2e) + bit2(0xaebe2e) + bit4(0xaebe2e) + bit6(0xaebe2e) + 
bit0(0xaebe2f) + bit2(0xaebe2f) + bit4(0xaebe2f) + bit6(0xaebe2f) + bit0(0xaebe30) + 
bit2(0xaebe30) + bit4(0xaebe30) + bit6(0xaebe30) + bit0(0xaebe31) + bit2(0xaebe31) + 
bit4(0xaebe31) + bit6(0xaebe31) + bit0(0xaebe32) + bit2(0xaebe32) + bit4(0xaebe32) + 
bit6(0xaebe32) + bit0(0xaebe33) + bit2(0xaebe33) + bit4(0xaebe33) + bit6(0xaebe33) + 
bit0(0xaebe34) + bit2(0xaebe34) + bit4(0xaebe34) + bit6(0xaebe34) + bit0(0xaebe35) + 
bit2(0xaebe35) + bit4(0xaebe35) + bit6(0xaebe35) + bit0(0xaebe36) + bit2(0xaebe36) + 
bit4(0xaebe36) + bit6(0xaebe36) + bit0(0xaebe37) + bit2(0xaebe37) + bit4(0xaebe37) + 
bit6(0xaebe37) + bit0(0xaebe38) + bit2(0xaebe38) + bit4(0xaebe38) + bit6(0xaebe38) + 
bit0(0xaebe39) + bit2(0xaebe39) + bit4(0xaebe39) + bit6(0xaebe39) + bit0(0xaebe3a) + 
bit2(0xaebe3a) + bit4(0xaebe3a) + bit6(0xaebe3a) + bit0(0xaebe3b) + bit2(0xaebe3b) + 
bit4(0xaebe3b) + bit6(0xaebe3b) + bit0(0xaebe3c) + bit2(0xaebe3c) + bit4(0xaebe3c) + 
bit6(0xaebe3c) + bit0(0xaebe3d) + bit2(0xaebe3d) + bit4(0xaebe3d) + bit6(0xaebe3d) + 
bit0(0xaebe3e) + bit2(0xaebe3e) + bit4(0xaebe3e) + bit6(0xaebe3e) + bit0(0xaebe3f) + 
bit2(0xaebe3f) + bit4(0xaebe3f) + bit6(0xaebe3f) + bit0(0xaebe40) + bit2(0xaebe40) + 
bit4(0xaebe40) + bit6(0xaebe40) + bit0(0xaebe41) + bit2(0xaebe41) + bit4(0xaebe41) + 
bit6(0xaebe41) + bit0(0xaebe42) + bit2(0xaebe42) + bit4(0xaebe42) + bit6(0xaebe42) + 
bit0(0xaebe43) + bit2(0xaebe43) + bit4(0xaebe43) + bit6(0xaebe43) + bit0(0xaebe44) + 
bit2(0xaebe44) + bit4(0xaebe44) + bit6(0xaebe44) + bit0(0xaebe45) + bit2(0xaebe45) + 
bit4(0xaebe45) + bit6(0xaebe45) + bit0(0xaebe46) + bit2(0xaebe46) + bit4(0xaebe46) + 
bit6(0xaebe46) + bit0(0xaebe47) + bit2(0xaebe47) + bit4(0xaebe47) + bit6(0xaebe47) + 
bit0(0xaebe48) + bit2(0xaebe48) + bit4(0xaebe48) + bit6(0xaebe48) + bit0(0xaebe49) + 
bit2(0xaebe49) + bit4(0xaebe49) + bit6(0xaebe49) + bit0(0xaebe4a) + bit2(0xaebe4a) + 
bit4(0xaebe4a) + bit6(0xaebe4a) + bit0(0xaebe4b) + bit2(0xaebe4b) + bit4(0xaebe4b) + 
bit6(0xaebe4b) + bit0(0xaebe4c) + bit2(0xaebe4c) + bit4(0xaebe4c) + bit6(0xaebe4c) + 
bit0(0xaebe4d) + bit2(0xaebe4d) + bit4(0xaebe4d) + bit6(0xaebe4d) + bit0(0xaebe4e) + 
bit2(0xaebe4e) + bit4(0xaebe4e) + bit6(0xaebe4e) + bit0(0xaebe4f)

//Duelling club completions
StudentDuelsWon = bitcount(0xaebee1) + bit0(0xaebee2)

OpenCategoryDuelsWon = 
bit2(0xaebee3) + bit3(0xaebee3) + bit4(0xaebee3) +
bit5(0xaebee3) + bit6(0xaebee3) + bit7(0xaebee3)

DumbledoresArmyDuelsWon = 
bit4(0xaebee5) + bit5(0xaebee5) + bit6(0xaebee5) + bit7(0xaebee5) +
bitcount(0xaebee6) + bit0(0xaebee7) + bit1(0xaebee7) + bit2(0xaebee7) + 
bit3(0xaebee7) + bit4(0xaebee7) + bit5(0xaebee7)

HogwartsStaffDuelsWon = bit6(0xaebee7)+ bit7(0xaebee7) + bitcount(0xaebee8)

//Shop purchases
//hints
HintsPurchased = bitcount(0xaebe1d) + bit0(0xaebe1e) + bit1(0xaebe1e)
 + bit2(0xaebe1e) + bit3(0xaebe1e) + bit4(0xaebe1e) + bit5(0xaebe1e)

//characters
CharactersPurchased = 
bit1(0xaebe25) + bit3(0xaebe25) + bit5(0xaebe25) + bit7(0xaebe25) + bit1(0xaebe26) + 
bit3(0xaebe26) + bit5(0xaebe26) + bit7(0xaebe26) + bit1(0xaebe27) + bit3(0xaebe27) +
bit5(0xaebe27) + bit7(0xaebe27) + bit1(0xaebe28) + bit3(0xaebe28) + bit5(0xaebe28) + 
bit7(0xaebe28) + bit1(0xaebe29) + bit3(0xaebe29) + bit5(0xaebe29) + bit7(0xaebe29) + 
bit1(0xaebe2a) + bit3(0xaebe2a) + bit5(0xaebe2a) + bit7(0xaebe2a) + bit1(0xaebe2b) + 
bit3(0xaebe2b) + bit5(0xaebe2b) + bit7(0xaebe2b) + bit1(0xaebe2c) + bit3(0xaebe2c) + 
bit5(0xaebe2c) + bit7(0xaebe2c) + bit1(0xaebe2d) + bit3(0xaebe2d) + bit5(0xaebe2d) + 
bit7(0xaebe2d) + bit1(0xaebe2e) + bit3(0xaebe2e) + bit5(0xaebe2e) + bit7(0xaebe2e) + 
bit1(0xaebe2f) + bit3(0xaebe2f) + bit5(0xaebe2f) + bit7(0xaebe2f) + bit1(0xaebe30) + 
bit3(0xaebe30) + bit5(0xaebe30) + bit7(0xaebe30) + bit1(0xaebe31) + bit3(0xaebe31) + 
bit5(0xaebe31) + bit7(0xaebe31) + bit1(0xaebe32) + bit3(0xaebe32) + bit5(0xaebe32) + 
bit7(0xaebe32) + bit1(0xaebe33) + bit3(0xaebe33) + bit5(0xaebe33) + bit7(0xaebe33) + 
bit1(0xaebe34) + bit3(0xaebe34) + bit5(0xaebe34) + bit7(0xaebe34) + bit1(0xaebe35) + 
bit3(0xaebe35) + bit5(0xaebe35) + bit7(0xaebe35) + bit1(0xaebe36) + bit3(0xaebe36) + 
bit5(0xaebe36) + bit7(0xaebe36) + bit1(0xaebe37) + bit3(0xaebe37) + bit5(0xaebe37) + 
bit7(0xaebe37) + bit1(0xaebe38) + bit3(0xaebe38) + bit5(0xaebe38) + bit7(0xaebe38) + 
bit1(0xaebe39) + bit3(0xaebe39) + bit5(0xaebe39) + bit7(0xaebe39) + bit1(0xaebe3a) + 
bit3(0xaebe3a) + bit5(0xaebe3a) + bit7(0xaebe3a) + bit1(0xaebe3b) + bit3(0xaebe3b) + 
bit5(0xaebe3b) + bit7(0xaebe3b) + bit1(0xaebe3c) + bit3(0xaebe3c) + bit5(0xaebe3c) + 
bit7(0xaebe3c) + bit1(0xaebe3d) + bit3(0xaebe3d) + bit5(0xaebe3d) + bit7(0xaebe3d) + 
bit1(0xaebe3e) + bit3(0xaebe3e) + bit5(0xaebe3e) + bit7(0xaebe3e) + bit1(0xaebe3f) + 
bit3(0xaebe3f) + bit5(0xaebe3f) + bit7(0xaebe3f) + bit1(0xaebe40) + bit3(0xaebe40) + 
bit5(0xaebe40) + bit7(0xaebe40) + bit1(0xaebe41) + bit3(0xaebe41) + bit5(0xaebe41) + 
bit7(0xaebe41) + bit1(0xaebe42) + bit3(0xaebe42) + bit5(0xaebe42) + bit7(0xaebe42) + 
bit1(0xaebe43) + bit3(0xaebe43) + bit5(0xaebe43) + bit7(0xaebe43) + bit1(0xaebe44) + 
bit3(0xaebe44) + bit5(0xaebe44) + bit7(0xaebe44) + bit1(0xaebe45) + bit3(0xaebe45) + 
bit5(0xaebe45) + bit7(0xaebe45) + bit1(0xaebe46) + bit3(0xaebe46) + bit5(0xaebe46) + 
bit7(0xaebe46) + bit1(0xaebe47) + bit3(0xaebe47) + bit5(0xaebe47) + bit7(0xaebe47) + 
bit1(0xaebe48) + bit3(0xaebe48) + bit5(0xaebe48) + bit7(0xaebe48) + bit1(0xaebe49) + 
bit3(0xaebe49) + bit5(0xaebe49) + bit7(0xaebe49) + bit1(0xaebe4a) + bit3(0xaebe4a) + 
bit5(0xaebe4a) + bit7(0xaebe4a) + bit1(0xaebe4b) + bit3(0xaebe4b) + bit5(0xaebe4b) + 
bit7(0xaebe4b) + bit1(0xaebe4c) + bit3(0xaebe4c) + bit5(0xaebe4c) + bit7(0xaebe4c) + 
bit1(0xaebe4d) + bit3(0xaebe4d) + bit5(0xaebe4d) + bit7(0xaebe4d) + bit1(0xaebe4e) + 
bit3(0xaebe4e) + bit5(0xaebe4e) + bit7(0xaebe4e) + bit1(0xaebe4f)

//red bricks
RedBricksPurchased = 
bitcount(0xaebebb) + bit0(0xaebebc) + bit1(0xaebebc) + bit2(0xaebebc) +
bit3(0xaebebc) + bit4(0xaebebc) + bit5(0xaebebc)


// ================================
// Level Completions
// ================================

function IsLevelCompleted(addr, bitNum)
{
    if(bitNum == 1)
    {
        return bit1(addr) == 0x01 && prev(bit1(addr)) == 0x00
    }
    else if(bitNum == 2)
    {
        return bit2(addr) == 0x01 && prev(bit2(addr)) == 0x00
    }
    else if(bitNum == 3)
    {
        return bit3(addr) == 0x01 && prev(bit3(addr)) == 0x00
    }
    else if(bitNum == 4)
    {
        return bit4(addr) == 0x01 && prev(bit4(addr)) == 0x00
    }
    else if(bitNum == 5)
    {
        return bit5(addr) == 0x01 && prev(bit5(addr)) == 0x00
    }
    else if(bitNum == 6)
    {
        return bit6(addr) == 0x01 && prev(bit6(addr)) == 0x00
    }
    else
    {
        return bit7(addr) == 0x01 && prev(bit7(addr)) == 0x00
    }
}

function LevelCompleteAchievement(achName, levelName, levelAddr, bitNum)
{
    achievement (
        title = achName,
        description = "Complete " + levelName + " in story mode",
        points = 4,
        trigger = (
            LevelID != 0x00 &&
            IsLevelCompleted(levelAddr, bitNum)
        )
    )
}

LevelCompleteAchievement("Little Whinging Park", "year 5 chapter 1", 0xaebe67, 1)
LevelCompleteAchievement("A Trip To Hogsmeade", "year 5 chapter 2", 0xaebe6a, 7)
LevelCompleteAchievement("12 Grimmauld Place", "year 5 chapter 3", 0xaebe73, 1)
LevelCompleteAchievement("The Hall of Prophecy", "year 5 chapter 4", 0xaebe7b, 3)
LevelCompleteAchievement("Draught of Living Death", "year 6 chapter 1", 0xaebe82, 7)
LevelCompleteAchievement("The Three Broomsticks", "year 6 chapter 2", 0xaebe86, 5)
LevelCompleteAchievement("The Burrow", "year 6 chapter 3", 0xaebe8b, 1)
LevelCompleteAchievement("The Cave", "year 6 chapter 4", 0xaebe90, 3)
LevelCompleteAchievement("Godric's Hollow", "year 7 part 1 chapter 1", 0xaebe96, 3)
LevelCompleteAchievement("Malfoy Manor", "year 7 part 1 chapter 2", 0xaebe9a, 7)
LevelCompleteAchievement("Gringotts Break-in", "year 7 part 2 chapter 1", 0xaebe9e, 5)
LevelCompleteAchievement("The C", "year 7 part 2 chapter 2", 0xaebea2, 3)
LevelCompleteAchievement("Hogwarts Battle", "year 7 part 2 chapter 3", 0xaebea6, 1)
LevelCompleteAchievement("Harry vs Voldemort", "year 7 part 2 chapter 4", 0xaebea9, 7)

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
            collectible >= collectibleAmount &&
            prev(collectible) <= prevCollectibleAmount
        )
    )
}

LevelCollectibles("Accio Studs", "Reach true wizard in half of the levels", 10, TrueWizardInLevels, 0x07, 0x06)
LevelCollectibles("Richest Wizard Around", "Reach true wizard in all of the levels", 10, TrueWizardInLevels, 0x0e, 0x0d)
LevelCollectibles("The Hat Collector", "Collect half of the wizard hats in the game", 10, WizardHatsCollected, 0x25, 0x24)
LevelCollectibles("A Hat-tastic Collection", "Collect all of the wizard hats in the game", 25, WizardHatsCollected, 0x49, 0x48)
LevelCollectibles("Fantastic Finds", "Unlock half of the characters available in the game in levels", 10, CharactersUnlocked, 0x55, 0x54)
LevelCollectibles("Ultimate Witch and Wizard Collector", "Unlock all of the characters available in the game in levels", 25, CharactersUnlocked, 0xa9, 0xa8)
LevelCollectibles("Secrets Unveiled", "Collect all of the red bricks in the game", 25, RedBricksFound, 0x0e, 0x0d)

// ================================
// Shop Purchases
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

ShopPurchases("Wizarding Insights", "Purchase every hint in the game", 5, HintsPurchased, 0x0e, 0x0d)
ShopPurchases("Wizarding Upgrades", "Purchase every red brick in the game", 10, RedBricksPurchased, 0x0e, 0x0d)
ShopPurchases("Magical Shopper", "Purchase half of the characters in the game", 10, CharactersPurchased, 0x55, 0x54)
ShopPurchases("Mystical Recruits", "Purchase all of the characters in the game", 10, CharactersPurchased, 0xa9, 0xa8)

// ================================
// Duels Complete
// ================================

function DuelsComplete(achName, achDesc, points, duelType, duel, duelAmountComplete, prevDuelAmountComplete)
{
    achievement(
        title = achName,
        description = achDesc,
        points = points,
        trigger = (
            DuelSelected == duelType &&
            duel == duelAmountComplete &&
            prev(duel) == prevDuelAmountComplete
        )
    )
}

DuelsComplete("The Student Dueller", "Win all the duels in the 'students' category", 5, 0x00, StudentDuelsWon, 0x09, 0x08)
DuelsComplete("Wand Wielder", "Win all the duels in the 'open category' category", 5, 0x01, OpenCategoryDuelsWon, 0x06, 0x05)
DuelsComplete("Beating The Army", "Win all the duels in the 'Dumbledore's army' category", 10, 0x02, DumbledoresArmyDuelsWon, 0x12, 0x11)
DuelsComplete("Hope I Don't Get Expelled!", "Win all the duels in the 'Hogwarts staff' category", 5, 0x03, HogwartsStaffDuelsWon, 0x09, 0x08)
