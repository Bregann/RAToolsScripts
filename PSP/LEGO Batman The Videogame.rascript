// LEGO Batman: The Videogame
// #ID = 18010

//Levels
CurrentLevel = byte(0x00b65678)

HeroEP1 = 0x03
HeroEP2 = 0x04
HeroEP3 = 0x05
HeroEP4 = 0x06
HeroEP5 = 0x07
HeroEP6 = 0x0a
HeroEP7 = 0x0b
HeroEP8 = 0x0c
HeroEP9 = 0x0d
HeroEP10 = 0x0e
HeroEP11 = 0x11
HeroEP12 = 0x12
HeroEP13 = 0x13
HeroEP14 = 0x14
HeroEP15 = 0x15
VillainEP1 = 0x17
VillainEP2 = 0x18
VillainEP3 = 0x19
VillainEP4 = 0x1a
VillainEP5 = 0x1b
VillainEP6 = 0x1c
VillainEP7 = 0x1d
VillainEP8 = 0x1e
VillainEP9 = 0x1f
VillainEP10 = 0x20
VillainEP11 = 0x21
VillainEP12 = 0x22
VillainEP13 = 0x23
VillainEP14 = 0x24
VillainEP15 = 0x25
WayneManor = 0x26
ArkhamAsylum = 0x27

function IsHeroEp() => CurrentLevel == HeroEP1 || CurrentLevel == HeroEP2  || CurrentLevel == HeroEP3  || CurrentLevel == HeroEP4  
|| CurrentLevel == HeroEP5  || CurrentLevel == HeroEP6  || CurrentLevel == HeroEP7  || CurrentLevel == HeroEP8 || CurrentLevel == HeroEP9 
|| CurrentLevel == HeroEP10  || CurrentLevel == HeroEP11  || CurrentLevel == HeroEP12  || CurrentLevel == HeroEP13  || CurrentLevel == HeroEP14
|| CurrentLevel == HeroEP15

function IsVillainEp() => CurrentLevel == VillainEP1 || CurrentLevel == VillainEP2  || CurrentLevel == VillainEP3  || CurrentLevel == VillainEP4  
|| CurrentLevel == VillainEP5  || CurrentLevel == VillainEP6  || CurrentLevel == VillainEP7  || CurrentLevel == VillainEP8 || CurrentLevel == VillainEP9 
|| CurrentLevel == VillainEP10  || CurrentLevel == VillainEP11  || CurrentLevel == VillainEP12  || CurrentLevel == VillainEP13  || CurrentLevel == VillainEP14
|| CurrentLevel == VillainEP15

//Freeplay unlocked
// 0x00 = locked
// 0x01 = unlocked
function HeroEP1FreeplayUnlocked() => byte(0xd639ef) == 0x01 && prev(byte(0xd639ef)) == 0x00
function HeroEP2FreeplayUnlocked() => byte(0xd639fb) == 0x01 && prev(byte(0xd639fb)) == 0x00
function HeroEP3FreeplayUnlocked() => byte(0xd63a07) == 0x01 && prev(byte(0xd63a07)) == 0x00
function HeroEP4FreeplayUnlocked() => byte(0xd63a13) == 0x01 && prev(byte(0xd63a13)) == 0x00
function HeroEP5FreeplayUnlocked() => byte(0xd63a1f) == 0x01 && prev(byte(0xd63a1f)) == 0x00
function HeroEP6FreeplayUnlocked() => byte(0xd63a43) == 0x01 && prev(byte(0xd63a43)) == 0x00
function HeroEP7FreeplayUnlocked() => byte(0xd63a4f) == 0x01 && prev(byte(0xd63a4f)) == 0x00
function HeroEP8FreeplayUnlocked() => byte(0xd63a5b) == 0x01 && prev(byte(0xd63a5b)) == 0x00
function HeroEP9FreeplayUnlocked() => byte(0xd63a67) == 0x01 && prev(byte(0xd63a67)) == 0x00
function HeroEP10FreeplayUnlocked() => byte(0xd63a73) == 0x01 && prev(byte(0xd63a73)) == 0x00
function HeroEP11FreeplayUnlocked() => byte(0xd63a97) == 0x01 && prev(byte(0xd63a97)) == 0x00
function HeroEP12FreeplayUnlocked() => byte(0xd63aa3) == 0x01 && prev(byte(0xd63aa3)) == 0x00
function HeroEP13FreeplayUnlocked() => byte(0xd63aaf) == 0x01 && prev(byte(0xd63aaf)) == 0x00
function HeroEP14FreeplayUnlocked() => byte(0xd63abb) == 0x01 && prev(byte(0xd63abb)) == 0x00
function HeroEP15FreeplayUnlocked() => byte(0xd63ac7) == 0x01 && prev(byte(0xd63ac7)) == 0x00
function VillainEP1FreeplayUnlocked() => byte(0xd63adf) == 0x01 && prev(byte(0xd63adf)) == 0x00
function VillainEP2FreeplayUnlocked() => byte(0xd63aeb) == 0x01 && prev(byte(0xd63aeb)) == 0x00
function VillainEP3FreeplayUnlocked() => byte(0xd63af7) == 0x01 && prev(byte(0xd63af7)) == 0x00
function VillainEP4FreeplayUnlocked() => byte(0xd63b03) == 0x01 && prev(byte(0xd63b03)) == 0x00
function VillainEP5FreeplayUnlocked() => byte(0xd63b0f) == 0x01 && prev(byte(0xd63b0f)) == 0x00
function VillainEP6FreeplayUnlocked() => byte(0xd63b1b) == 0x01 && prev(byte(0xd63b1b)) == 0x00
function VillainEP7FreeplayUnlocked() => byte(0xd63b27) == 0x01 && prev(byte(0xd63b27)) == 0x00
function VillainEP8FreeplayUnlocked() => byte(0xd63b33) == 0x01 && prev(byte(0xd63b33)) == 0x00
function VillainEP9FreeplayUnlocked() => byte(0xd63b3f) == 0x01 && prev(byte(0xd63b3f)) == 0x00
function VillainEP10FreeplayUnlocked() => byte(0xd63b4b) == 0x01 && prev(byte(0xd63b4b)) == 0x00
function VillainEP11FreeplayUnlocked() => byte(0xd63b57) == 0x01 && prev(byte(0xd63b57)) == 0x00
function VillainEP12FreeplayUnlocked() => byte(0xd63b63) == 0x01 && prev(byte(0xd63b63)) == 0x00
function VillainEP13FreeplayUnlocked() => byte(0xd63b6f) == 0x01 && prev(byte(0xd63b6f)) == 0x00
function VillainEP14FreeplayUnlocked() => byte(0xd63b7b) == 0x01 && prev(byte(0xd63b7b)) == 0x00
function VillainEP15FreeplayUnlocked() => byte(0xd63b87) == 0x01 && prev(byte(0xd63b87)) == 0x00

//Minikits
HeroMinikitsUnlocked = 
byte(0x00d639f1) + byte(0x00d639fd) + byte(0x00d63a09) + byte(0x00d63a15) + byte(0x00d63a21) +
byte(0x00d63a45) + byte(0x00d63a51) + byte(0x00d63a5d) + byte(0x00d63a69) + byte(0x00d63a75) +
byte(0x00d63a99) + byte(0x00d63aa5) + byte(0x00d63ab1) + byte(0x00d63abd) + byte(0x00d63ac9)

VillianMinikitsUnlocked = 
byte(0x00d63ae1) + byte(0x00d63aed) + byte(0x00d63af9) + byte(0x00d63b05) + byte(0x00d63b11) + 
byte(0x00d63b1d) + byte(0x00d63b29) + byte(0x00d63b35) + byte(0x00d63b41) + byte(0x00d63b4d) + 
byte(0x00d63b59) + byte(0x00d63b65) + byte(0x00d63b71) + byte(0x00d63b7d) + byte(0x00d63b89)

//True batman
HeroTrueBatmans = 
byte(0x00d639ed) + byte(0x00d639f9) + byte(0x00d63a05) + byte(0x00d63a11) + byte(0x00d63a1d) +
byte(0x00d63a41) + byte(0x00d63a4d) + byte(0x00d63a59) + byte(0x00d63a65) + byte(0x00d63a71) +
byte(0x00d63a95) + byte(0x00d63aa1) + byte(0x00d63aad) + byte(0x00d63ab9) + byte(0x00d63ac5)

VillianTrueBatmans = 
byte(0x00d63add) + byte(0x00d63ae9) + byte(0x00d63af5) + byte(0x00d63b01) + byte(0x00d63b0d) + 
byte(0x00d63b19) + byte(0x00d63b25) + byte(0x00d63b31) + byte(0x00d63b3d) + byte(0x00d63b49) + 
byte(0x00d63b55) + byte(0x00d63b61) + byte(0x00d63b6d) + byte(0x00d63b79) + byte(0x00d63b85)

//Hostages saved
HeroHostagesSaved = bitcount(0x00d64000) + bit0(0x00d64001) + bit1(0x00d64001) + bit2(0x00d64001) + bit3(0x00d64001)

VillianHostagesSaved = 
bit4(0x00d64001) + bit5(0x00d64001) + bit6(0x00d64001) + bit7(0x00d64001) + 
bitcount(0x00d64002) + bit0(0x00d64003)

//Red Bricks collected
RedBricksCollected =
byte(0x00d639f3) + byte(0x00d639ff) + byte(0x00d63a0b) + byte(0x00d63a17) + byte(0x00d63a23) +
byte(0x00d63a47) + byte(0x00d63a53) + byte(0x00d63a5f) + byte(0x00d63a6b) + byte(0x00d63a77) +
byte(0x00d63a9b) + byte(0x00d63aa7) + byte(0x00d63ab3) + byte(0x00d63abf) + byte(0x00d63acb) +
byte(0x00d63ae3) + byte(0x00d63aef) + byte(0x00d63afb) + byte(0x00d63b07) + byte(0x00d63b13) + 
byte(0x00d63b1f) + byte(0x00d63b2b) + byte(0x00d63b37) + byte(0x00d63b43) + byte(0x00d63b4f) + 
byte(0x00d63b5b) + byte(0x00d63b67) + byte(0x00d63b73) + byte(0x00d63b7f) + byte(0x00d63b8b)

//Stud count
StudCount = dword(0x00d63dc0)
BonusStudCount = dword(0x00b65904)

//Characters purchased
CharactersPurchased = 
bitcount(0x00d63d78) + bitcount(0x00d63d79) + bitcount(0x00d63d7a) +
bitcount(0x00d63d7b) + bitcount(0x00d63d7c) + bitcount(0x00d63d7d) +
bit0(0x00d63d7e) + bit1(0x00d63d7e) + bit2(0x00d63d7e) + bit3(0x00d63d7e) + bit4(0x00d63d7e)

//Extras purchased
ExtrasPurchased = 
bitcount(0x00d63d88) + bitcount(0x00d63d89) + bit0(0x00d63d8a) +
bit1(0x00d63d8a) + bit2(0x00d63d8a) + bit3(0x00d63d8a)

//Data purchased
DataPurchased = 
bit3(0x00d63d70) + bit4(0x00d63d70) + bit5(0x00d63d70) + bit6(0x00d63d70) + 
bit7(0x00d63d70) + bitcount(0x00d63d71) + bitcount(0x00d63d72) + bitcount(0x00d63d73) + 
bitcount(0x00d63d74) + bitcount(0x00d63d75) + bit0(0x00d63d76) + bit1(0x00d63d76) +
bit2(0x00d63d76) + bit3(0x00d63d76) +bit4(0x00d63d76) + bit5(0x00d63d76)

//Suit upgrades purchased
SuitUpgradesPurchased = 
bitcount(0x00d63d98) + bit0(0x00d63d99) + bit1(0x00d63d99) + bit2(0x00d63d99) +
bit3(0x00d63d99) + bit4(0x00d63d99) + bit5(0x00d63d99) + bit6(0x00d63d99)

//Extras enabled
ExtrasEnabled = byte(0xb35ef8) +
byte(0xb35cc8) + byte(0xb35ce4) + byte(0xb35d00) + byte(0xb35d1c) + byte(0xb35d38) +
byte(0xb35d54) + byte(0xb35d70) + byte(0xb35d8c) + byte(0xb35da8) + byte(0xb35dc4) +
byte(0xb35de0) + byte(0xb35dfc) + byte(0xb35e18) + byte(0xb35e34) + byte(0xb35e50) +
byte(0xb35e6c) + byte(0xb35e88) + byte(0xb35ea4) + byte(0xb35ec0) + byte(0xb35edc)
// ================================
// Level Completions
// ================================

function LevelComplete(levelName, level, freePlayUnlocked)
{
    achievement(
        title = levelName,
        description = "Complete " + levelName + " on story mode",
        points = 3,
        trigger = (
            freePlayUnlocked &&
            CurrentLevel == level
        )
    )
}

LevelComplete("You Can Bank On Batman", HeroEP1, HeroEP1FreeplayUnlocked())
LevelComplete("An Icy Reception", HeroEP2, HeroEP2FreeplayUnlocked())
LevelComplete("Two-Face Chase", HeroEP3, HeroEP3FreeplayUnlocked())
LevelComplete("A Poisonous Appointment", HeroEP4, HeroEP4FreeplayUnlocked())
LevelComplete("The Riddler's Revenge", HeroEP5, HeroEP5FreeplayUnlocked())
LevelComplete("There She Goes Again", HeroEP6, HeroEP6FreeplayUnlocked())
LevelComplete("Batboat Battle", HeroEP7, HeroEP7FreeplayUnlocked())
LevelComplete("Under the City", HeroEP8, HeroEP8FreeplayUnlocked())
LevelComplete("Zoo's Company", HeroEP9, HeroEP9FreeplayUnlocked())
LevelComplete("Penguin's Lair", HeroEP10, HeroEP10FreeplayUnlocked())
LevelComplete("Joker's Home Turf", HeroEP11, HeroEP11FreeplayUnlocked())
LevelComplete("Little Fun at the Big Top", HeroEP12, HeroEP12FreeplayUnlocked())
LevelComplete("Flight of the Bat", HeroEP13, HeroEP13FreeplayUnlocked())
LevelComplete("In the Dark Night", HeroEP14, HeroEP14FreeplayUnlocked())
LevelComplete("To the Top of the Tower", HeroEP15, HeroEP15FreeplayUnlocked())
LevelComplete("The Riddler Makes a Withdrawal", VillainEP1, VillainEP1FreeplayUnlocked())
LevelComplete("On the Rocks", VillainEP2, VillainEP2FreeplayUnlocked())
LevelComplete("Green Fingers", VillainEP3, VillainEP3FreeplayUnlocked())
LevelComplete("An Enterprising Theft", VillainEP4, VillainEP4FreeplayUnlocked())
LevelComplete("Breaking Blocks", VillainEP5, VillainEP5FreeplayUnlocked())
LevelComplete("Rockin' the Docks", VillainEP6, VillainEP6FreeplayUnlocked())
LevelComplete("Stealing the Show", VillainEP7, VillainEP7FreeplayUnlocked())
LevelComplete("Harbouring a Grudge", VillainEP8, VillainEP8FreeplayUnlocked())
LevelComplete("A Daring Rescue", VillainEP9, VillainEP9FreeplayUnlocked())
LevelComplete("Arctic World", VillainEP10, VillainEP10FreeplayUnlocked())
LevelComplete("A Surprise for the Commissioner", VillainEP11, VillainEP11FreeplayUnlocked())
LevelComplete("Biplane Blast", VillainEP12, VillainEP12FreeplayUnlocked())
LevelComplete("The Joker's Masterpiece", VillainEP13, VillainEP13FreeplayUnlocked())
LevelComplete("The Lure of the Night", VillainEP14, VillainEP14FreeplayUnlocked())
LevelComplete("Dying of Laughter", VillainEP15, VillainEP15FreeplayUnlocked())

// ================================
// Bonus Level Completions
// ================================

function BonusLevelComplete(achName, achDesc, level)
{
    achievement(
        title = achName,
        description = achDesc,
        points = 5,
        trigger = (
            CurrentLevel == level &&
            BonusStudCount == 0xf4240 &&
            prev(BonusStudCount) < 0xf4240
        )
    )
}

BonusLevelComplete("Wayne Manor", "Complete the hero bonus level", WayneManor)
BonusLevelComplete("Arkham Asylum", "Complete the villain bonus level", ArkhamAsylum)

// ================================
// Minikit/true batman completions
// ================================

function HeroVillianSplitAchievements(achName, achDesc, typeOfUnlock, amount, prevAmount, heroOrVillian)
{
    achievement (
        title = achName,
        description = achDesc,
        points = 25,
        trigger = (
            typeOfUnlock == amount &&
            prev(typeOfUnlock) == prevAmount &&
            heroOrVillian
            )
        )
}

HeroVillianSplitAchievements("Minikit Master", "Collect all 150 minikits in the hero levels", HeroMinikitsUnlocked, 0x96, 0x95, IsHeroEp())
HeroVillianSplitAchievements("Minikit Mastermind", "Collect all 150 minikits in the villian levels", VillianMinikitsUnlocked, 0x96, 0x95, IsVillainEp())
HeroVillianSplitAchievements("I'm Batman", "Reach true batman in the hero levels", HeroTrueBatmans, 0x0f, 0x0e, IsHeroEp())
HeroVillianSplitAchievements("The Dark Knight Rises", "Reach true batman in the villian levels", VillianTrueBatmans, 0x0f, 0x0e, IsVillainEp())
HeroVillianSplitAchievements("The Hero of Gotham", "Save every hostage in the hero levels", HeroHostagesSaved, 0x0c, 0x0b, IsHeroEp())
HeroVillianSplitAchievements("The Evil Hero of Gotham", "Save every hostage in the villian levels", VillianHostagesSaved, 0x0d, 0x0c, IsVillainEp())

// ================================
// Red brick collected completions
// ================================

achievement(
    title = "Master of the Red Bricks",
    description = "Collect every red brick from all hero and villian levels",
    points = 25,
    trigger = (
        RedBricksCollected == 0x1e &&
        prev(RedBricksCollected) == 0x1d &&
        CurrentLevel != 0x01
     )
)

// ================================
// Shop purchases
// ================================

function ShopPurchaseAchievements(achName, achDesc, points, typeOfUnlock, amount, prevAmount)
{
    achievement(
        title = achName,
        description = achDesc,
        points = points,
        trigger = (
            typeOfUnlock == amount &&
            prev(typeOfUnlock) == prevAmount &&
            CurrentLevel == 0x01
            )
        )
}

ShopPurchaseAchievements("True Data Hoarder", "Purchase all the data from the shop", 25, DataPurchased, 0x33, 0x32)
ShopPurchaseAchievements("Red Brick Domination", "Purchase all the extra from the shop", 10, ExtrasPurchased, 0x14, 0x13)
ShopPurchaseAchievements("Gotham's Finest", "Unlock every available character from the shop", 25, CharactersPurchased, 0x35, 0x34)
ShopPurchaseAchievements("Suited Up", "Unlock every suit upgrade from the shop", 25, SuitUpgradesPurchased, 0x0f, 0x0e)

// ================================
// Misc
// ================================
achievement(
    title = "Now I Can Buy My Own Batcave!",
    description = "Reach 1 billion studs",
    points = 5,
    trigger = (
        StudCount >= 0x3b9aca00 &&
        (prev(StudCount) <= 0x3b9aca00 && prev(StudCount) != 0x00) &&
        CurrentLevel != 0x00
     )
)

achievement(
    title = "Ultimate Chaos!",
    description = "Enable every red brick cheat at once",
    points = 5,
    trigger = (
        CurrentLevel != 0x00 &&
        ExtrasEnabled == 0x15 &&
        prev(ExtrasEnabled) == 0x14
    )
)
