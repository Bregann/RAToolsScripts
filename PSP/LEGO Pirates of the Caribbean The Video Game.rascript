// LEGO Pirates of the Caribbean: The Video Game
// #ID = 3040
LevelID = byte(0x00a17ac4)

//True Pirate
TruePirateInStoryLevels = 
bit3(0xa21362) + bit3(0xa21365) + bit7(0xa21366) + bit3(0xa21368) +
bit7(0xa21369) + bit1(0xa2136c) + bit5(0xa2136d) + bit7(0xa2136f) +
bit5(0xa21370) + bit1(0xa21372) + bit7(0xa21372) + bit5(0xa21373) +
bit7(0xa21375) + bit3(0xa21377) + bit7(0xa21378) + bit3(0xa2137a)

TruePirateInFreeplayLevels = 
bit4(0xa21362) + bit4(0xa21365) + bit0(0xa21367) + bit4(0xa21368) +
bit0(0xa2136a) + bit2(0xa2136c) + bit6(0xa2136d) + bit0(0xa21370) +
bit6(0xa21370) + bit2(0xa21372) + bit0(0xa21373) + bit6(0xa21373) +
bit0(0xa21376) + bit4(0xa21377) + bit0(0xa21379) + bit4(0xa2137a)

//Minikits
MinikitsL1 = 
bit3(0xa21362) + bit3(0xa21365) + bit7(0xa21366) + bit3(0xa21368) +
bit4(0xa21362) + bit4(0xa21365) + bit0(0xa21367) + bit4(0xa21368) +
bitcount(0xa2137d) + bitcount(0xa2137e) + bitcount(0xa2137f) + bitcount(0xa21380)

MinikitsL2 = 
bit7(0xa21369) + bit1(0xa2136c) + bit5(0xa2136d) + bit7(0xa2136f) +
bit0(0xa2136a) + bit2(0xa2136c) + bit6(0xa2136d) + bit0(0xa21370) +
bitcount(0xa21381) + bitcount(0xa21382) + bitcount(0xa21383) + bitcount(0xa21384)

MinikitsL3 = 
bit5(0xa21370) + bit1(0xa21372) + bit7(0xa21372) + bit5(0xa21373) +
bit6(0xa21370) + bit2(0xa21372) + bit0(0xa21373) + bit6(0xa21373) +
bitcount(0xa21385) + bitcount(0xa21386) + bitcount(0xa21387) + bitcount(0xa21388)

MinikitsL4 = 
bit7(0xa21375) + bit3(0xa21377) + bit7(0xa21378) + bit3(0xa2137a) + 
bit0(0xa21376) + bit4(0xa21377) + bit0(0xa21379) + bit4(0xa2137a) + 
bitcount(0xa21389) + bitcount(0xa2138a) + bitcount(0xa2138b) + bitcount(0xa2138c)

//Redbricks found
RedbricksFound = bitcount(0x00a21391) + bitcount(0x00a21392)


//Shop items
//Hints
HintsPurchased = 
bitcount(0xa21329) + bit0(0xa2132a) + bit1(0xa2132a) + bit2(0xa2132a)
+ bit3(0xa2132a) + bit4(0xa2132a) + bit5(0xa2132a)

//Characters
CharactersUnlocked = 
bit0(0xa21332) + bit2(0xa21332) + bit4(0xa21332) + bit6(0xa21332) + bit0(0xa21333) + 
bit2(0xa21333) + bit4(0xa21333) + bit6(0xa21333) + bit0(0xa21334) + bit2(0xa21334) + 
bit4(0xa21334) + bit6(0xa21334) + bit0(0xa21335) + bit2(0xa21335) + bit4(0xa21335) + 
bit6(0xa21335) + bit0(0xa21336) + bit2(0xa21336) + bit4(0xa21336) + bit6(0xa21336) + 
bit0(0xa21337) + bit2(0xa21337) + bit4(0xa21337) + bit6(0xa21337) + bit0(0xa21338) + 
bit2(0xa21338) + bit4(0xa21338) + bit6(0xa21338) + bit0(0xa21339) + bit2(0xa21339) + 
bit4(0xa21339) + bit6(0xa21339) + bit0(0xa2133a) + bit2(0xa2133a) + bit4(0xa2133a) + 
bit6(0xa2133a) + bit0(0xa2133b) + bit2(0xa2133b) + bit4(0xa2133b) + bit6(0xa2133b) + 
bit0(0xa2133c) + bit2(0xa2133c) + bit4(0xa2133c) + bit6(0xa2133c) + bit0(0xa2133d) + 
bit2(0xa2133d) + bit4(0xa2133d) + bit6(0xa2133d) + bit0(0xa2133e) + bit2(0xa2133e) + 
bit4(0xa2133e) + bit6(0xa2133e) + bit0(0xa2133f) + bit2(0xa2133f) + bit4(0xa2133f) + 
bit6(0xa2133f) + bit0(0xa21340) + bit2(0xa21340) + bit4(0xa21340) + bit6(0xa21340) + 
bit0(0xa21341) + bit2(0xa21341) + bit4(0xa21341) + bit6(0xa21341) + bit0(0xa21342) + 
bit2(0xa21342) + bit4(0xa21342) + bit6(0xa21342) + bit0(0xa21343) + bit2(0xa21343) + 
bit4(0xa21343) + bit6(0xa21343) + bit0(0xa21344) + bit2(0xa21344) + bit4(0xa21344) + 
bit6(0xa21344) + bit0(0xa21345) + bit2(0xa21345) + bit4(0xa21345) + bit6(0xa21345) + 
bit0(0xa21346) + bit2(0xa21346) + bit4(0xa21346) + bit6(0xa21346) + bit0(0xa21347) + 
bit2(0xa21347) + bit4(0xa21347) + bit6(0xa21347) + bit0(0xa21348) + bit2(0xa21348) + 
bit4(0xa21348) + bit6(0xa21348) + bit0(0xa21349) + bit2(0xa21349) + bit4(0xa21349) + 
bit6(0xa21349) + bit0(0xa2134a) + bit2(0xa2134a) + bit4(0xa2134a) + bit6(0xa2134a) + 
bit0(0xa2134b) + bit2(0xa2134b) + bit4(0xa2134b) + bit6(0xa2134b) + bit0(0xa2134c) + 
bit2(0xa2134c) + bit4(0xa2134c) + bit6(0xa2134c) + bit0(0xa2134d) + bit2(0xa2134d) + 
bit4(0xa2134d) + bit6(0xa2134d) + bit0(0xa2134e) + bit2(0xa2134e) + bit4(0xa2134e) + 
bit6(0xa2134e) + bit0(0xa2134f) + bit2(0xa2134f) + bit4(0xa2134f) + bit6(0xa2134f) + 
bit0(0xa21350) + bit2(0xa21350) + bit4(0xa21350) + bit6(0xa21350)

CharactersPurchased = 
bit1(0xa21332) + bit3(0xa21332) + bit5(0xa21332) + bit7(0xa21332) + bit1(0xa21333) + 
bit3(0xa21333) + bit5(0xa21333) + bit7(0xa21333) + bit1(0xa21334) + bit3(0xa21334) + 
bit5(0xa21334) + bit7(0xa21334) + bit1(0xa21335) + bit3(0xa21335) + bit5(0xa21335) + 
bit7(0xa21335) + bit1(0xa21336) + bit3(0xa21336) + bit5(0xa21336) + bit7(0xa21336) + 
bit1(0xa21337) + bit3(0xa21337) + bit5(0xa21337) + bit7(0xa21337) + bit1(0xa21338) + 
bit3(0xa21338) + bit5(0xa21338) + bit7(0xa21338) + bit1(0xa21339) + bit3(0xa21339) + 
bit5(0xa21339) + bit7(0xa21339) + bit1(0xa2133a) + bit3(0xa2133a) + bit5(0xa2133a) + 
bit7(0xa2133a) + bit1(0xa2133b) + bit3(0xa2133b) + bit5(0xa2133b) + bit7(0xa2133b) + 
bit1(0xa2133c) + bit3(0xa2133c) + bit5(0xa2133c) + bit7(0xa2133c) + bit1(0xa2133d) + 
bit3(0xa2133d) + bit5(0xa2133d) + bit7(0xa2133d) + bit1(0xa2133e) + bit3(0xa2133e) + 
bit5(0xa2133e) + bit7(0xa2133e) + bit1(0xa2133f) + bit3(0xa2133f) + bit5(0xa2133f) + 
bit7(0xa2133f) + bit1(0xa21340) + bit3(0xa21340) + bit5(0xa21340) + bit7(0xa21340) + 
bit1(0xa21341) + bit3(0xa21341) + bit5(0xa21341) + bit7(0xa21341) + bit1(0xa21342) + 
bit3(0xa21342) + bit5(0xa21342) + bit7(0xa21342) + bit1(0xa21343) + bit3(0xa21343) + 
bit5(0xa21343) + bit7(0xa21343) + bit1(0xa21344) + bit3(0xa21344) + bit5(0xa21344) + 
bit7(0xa21344) + bit1(0xa21345) + bit3(0xa21345) + bit5(0xa21345) + bit7(0xa21345) + 
bit1(0xa21346) + bit3(0xa21346) + bit5(0xa21346) + bit7(0xa21346) + bit1(0xa21347) + 
bit3(0xa21347) + bit5(0xa21347) + bit7(0xa21347) + bit1(0xa21348) + bit3(0xa21348) + 
bit5(0xa21348) + bit7(0xa21348) + bit1(0xa21349) + bit3(0xa21349) + bit5(0xa21349) + 
bit7(0xa21349) + bit1(0xa2134a) + bit3(0xa2134a) + bit5(0xa2134a) + bit7(0xa2134a) + 
bit1(0xa2134b) + bit3(0xa2134b) + bit5(0xa2134b) + bit7(0xa2134b) + bit1(0xa2134c) + 
bit3(0xa2134c) + bit5(0xa2134c) + bit7(0xa2134c) + bit1(0xa2134d) + bit3(0xa2134d) + 
bit5(0xa2134d) + bit7(0xa2134d) + bit1(0xa2134e) + bit3(0xa2134e) + bit5(0xa2134e) + 
bit7(0xa2134e) + bit1(0xa2134f) + bit3(0xa2134f) + bit5(0xa2134f) + bit7(0xa2134f) + 
bit1(0xa21350) + bit3(0xa21350) + bit5(0xa21350) + bit7(0xa21350)

//Red bricks
RedbricksPurchased = bitcount(0x00a21393) + bitcount(0x00a21394)


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
    
    if(bitNum == 7)
    {
        return bit7(addr) == 0x01 && prev(bit7(addr)) == 0x00
    }
}

function LevelCompleteAchievement(achName, levelName, points, levelAddr, bitNum)
{
    achievement (
        title = achName,
        description = "Complete level " + levelName + " on story mode",
        points = points,
        trigger = (
            LevelID != 0x00 &&
            IsLevelCompleted(levelAddr, bitNum)
        )
    )
}

LevelCompleteAchievement("Port Royal", "Port Royal", 3, 0x00a213fd, 1)
LevelCompleteAchievement("Tortuga", "Tortuga", 3, 0x00a21365, 1)
LevelCompleteAchievement("Battle at Sea", "Battle at Sea", 3, 0x00a21366, 5)
LevelCompleteAchievement("Isla de Muerta", "Isla de Muerta", 3, 0x00a21368, 1)

LevelCompleteAchievement("Isla de Pelegostos", "Isla de Pelegostos", 3, 0x00a21369, 5)
LevelCompleteAchievement("Davy Jones' Key", "Davy Jones' Key", 3, 0x00a2136b, 7)
LevelCompleteAchievement("Isla Cruces", "Isla Cruces", 3, 0x00a2136d, 3)
LevelCompleteAchievement("The Kraken", "The Kraken", 3, 0x00a2136f, 5)

LevelCompleteAchievement("The Kraken", "The Kraken", 3, 0x00a21370, 3)
LevelCompleteAchievement("Escape the Dutchman", "Escape the Dutchman", 3, 0x00a21371, 7)
LevelCompleteAchievement("Shipwreck Cove", "Shipwreck Cove", 3, 0x00a21372, 5)
LevelCompleteAchievement("The Maelstrom", "The Maelstrom", 3, 0x00a21373, 3)

LevelCompleteAchievement("London", "London", 3, 0x00a21375, 5)
LevelCompleteAchievement("Queen Anne's Revenge", "Queen Anne's Revenge", 3, 0x00a21377, 1)
LevelCompleteAchievement("White Cap Bay", "White Cap Bay", 3, 0x00a21378, 5)
LevelCompleteAchievement("The Fountain of Youth", "The Fountain of Youth", 3, 0x00a2137a, 1)

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
