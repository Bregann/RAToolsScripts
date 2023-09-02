// LEGO Pirates of the Caribbean: The Video Game
// #ID = 3040
LevelID = byte(0x00a17ac4)

//True Pirate
TruePirateInStoryLevels = 
TruePirateInFreeplayLevels = 

//Minikits
MinikitsL1 = 

MinikitsL2 = 

MinikitsL3 = 

MinikitsL4 = 

//Redbricks found
RedbricksFound = 


//Shop items
//Hints
HintsPurchased = 
bitcount(0xa21329) + bit0(0xa2132a) + bit1(0xa2132a) + bit2(0xa2132a)
+ bit3(0xa2132a) + bit4(0xa2132a) + bit5(0xa2132a)

//Characters
CharactersPurchased = 

//Red bricks
RedbricksPurchased = 


// ================================
// Level Completions
// ================================

function IsLevelCompleted(addr, bitNum)
{
    if(bitNum == 1)
    {
        return bit1(addr) == 0x01 && prev(bit1(addr)) == 0x00
    }
    
    if(bitNum == 3)
    {
        return bit3(addr) == 0x01 && prev(bit3(addr)) == 0x00
    }
    
    if(bitNum == 5)
    {
        return bit5(addr) == 0x01 && prev(bit5(addr)) == 0x00
    }
}

function LevelCompleteAchievement(achName, levelName, points, levelAddr, bitNum)
{
    achievement (
        title = achName,
        description = "Complete level " + levelName,
        points = points,
        trigger = (
            LevelID != 0x00 &&
            IsLevelCompleted(levelAddr, bitNum)
        )
    )
}

// ================================
// Level Bonus stuff
// ================================

function LevelCollectibles(achName, achDesc, points, collectible, collectibleAmount)
{
    achievement(
        title = achName,
        description = achDesc,
        points = points,
        trigger = (
            LevelID != 0x00 &&
            collectible >= collectibleAmount &&
            prev(collectible) <= collectibleAmount - 1
        )
    )
}


// ================================
// Shop stuff
// ================================

function ShopPurchases(achName, achDesc, points, purchaseItem, purchaseAmount)
{
    achievement(
        title = achName,
        description = achDesc,
        points = points,
        trigger = (
            LevelID == 0x00 &&
            purchaseItem == purchaseAmount &&
            prev(purchaseItem) == purchaseAmount - 1
        )
    )
}
