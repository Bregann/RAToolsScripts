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
HeroEP1FreeplayUnlocked = byte(0xd639ef)
HeroEP2FreeplayUnlocked = byte(0xd639fb)
HeroEP3FreeplayUnlocked = byte(0xd63a07)
HeroEP4FreeplayUnlocked = byte(0xd63a13)
HeroEP5FreeplayUnlocked = byte(0xd63a1f)
HeroEP6FreeplayUnlocked = byte(0xd63a43)
HeroEP7FreeplayUnlocked = byte(0xd63a4f)
HeroEP8FreeplayUnlocked = byte(0xd63a5b)
HeroEP9FreeplayUnlocked = byte(0xd63a67)
HeroEP10FreeplayUnlocked = byte(0xd63a73)
HeroEP11FreeplayUnlocked = byte(0xd63a97)
HeroEP12FreeplayUnlocked = byte(0xd63aa3)
HeroEP13FreeplayUnlocked = byte(0xd63aaf)
HeroEP14FreeplayUnlocked = byte(0xd63abb)
HeroEP15FreeplayUnlocked = byte(0xd63ac7)
VillainEP1FreeplayUnlocked = byte(0xd63adf)
VillainEP2FreeplayUnlocked = byte(0xd63aeb)
VillainEP3FreeplayUnlocked = byte(0xd63af7)
VillainEP4FreeplayUnlocked = byte(0xd63b03)
VillainEP5FreeplayUnlocked = byte(0xd63b0f)
VillainEP6FreeplayUnlocked = byte(0xd63b1b)
VillainEP7FreeplayUnlocked = byte(0xd63b27)
VillainEP8FreeplayUnlocked = byte(0xd63b33)
VillainEP9FreeplayUnlocked = byte(0xd63b3f)
VillainEP10FreeplayUnlocked = byte(0xd63b4b)
VillainEP11FreeplayUnlocked = byte(0xd63b57)
VillainEP12FreeplayUnlocked = byte(0xd63b63)
VillainEP13FreeplayUnlocked = byte(0xd63b6f)
VillainEP14FreeplayUnlocked = byte(0xd63b7b)
VillainEP15FreeplayUnlocked = byte(0xd63b87)

//Minikits
HeroMinikitsUnlocked = 
byte(0x00d639f1) + byte(0x00d639fd) + byte(0x00d63a09) + byte(0x00d63a15) + byte(0x00d63a21) +
byte(0x00d63a45) + byte(0x00d63a51) + byte(0x00d63a5d) + byte(0x00d63a69) + byte(0x00d63a75) +
byte(0x00d63a99) + byte(0x00d63aa5) + byte(0x00d63ab1) + byte(0x00d63abd) + byte(0x00d63ac9)

VillianMinikitsUnlocked = 
byte(0x00d63ae1) + byte(0x00d63aed) + byte(0x00d63af9) + byte(0x00d63b05) + byte(0x00d63b11) + 
byte(0x00d63b1d) + byte(0x00d63b29) + byte(0x00d63b35) + byte(0x00d63b41) + byte(0x00d63b4d) + 
byte(0x00d63b59) + byte(0x00d63b65) + byte(0x00d63b71) + byte(0x00d63b7d) + byte(0x00d63b7d)

//True batman
HeroTrueBatmans = 
byte(0x00d639ed) + byte(0x00d639f9) + byte(0x00d63a05) + byte(0x00d63a11) + byte(0x00d63a1d) +
byte(0x00d63a41) + byte(0x00d63a4d) + byte(0x00d63a59) + byte(0x00d63a65) + byte(0x00d63a71) +
byte(0x00d63a95) + byte(0x00d63aa1) + byte(0x00d63aad) + byte(0x00d63ab9) + byte(0x00d63ac5)

VillianTrueBatmans = 
byte(0x00d63add) + byte(0x00d63ae9) + byte(0x00d63af5) + byte(0x00d63b01) + byte(0x00d63b0d) + 
byte(0x00d63b19) + byte(0x00d63b25) + byte(0x00d63b31) + byte(0x00d63b3d) + byte(0x00d63b49) + 
byte(0x00d63b55) + byte(0x00d63b61) + byte(0x00d63b6d) + byte(0x00d63b79) + byte(0x00d63b85)


//Red Bricks collected
RedBricksCollected =
byte(0x00d639f3) + byte(0x00d639ff) + byte(0x00d63a0b) + byte(0x00d63a17) + byte(0x00d63a23) +
byte(0x00d63a47) + byte(0x00d63a53) + byte(0x00d63a5f) + byte(0x00d63a6b) + byte(0x00d63a77) +
byte(0x00d63a9b) + byte(0x00d63aa7) + byte(0x00d63ab3) + byte(0x00d63abf) + byte(0x00d63acb) +
byte(0x00d63ae3) + byte(0x00d63aef) + byte(0x00d63afb) + byte(0x00d63b07) + byte(0x00d63b13) + 
byte(0x00d63b1f) + byte(0x00d63b2b) + byte(0x00d63b37) + byte(0x00d63b43) + byte(0x00d63b4f) + 
byte(0x00d63b5b) + byte(0x00d63b67) + byte(0x00d63b73) + byte(0x00d63b7f) + byte(0x00d63b8b)

//Hostages saved
HeroHostagesSaved = 
bitcount(0x00d64000) + bit0(0x00d64001) + bit1(0x00d64001) + bit2(0x00d64001) + bit3(0x00d64001)

VillianHostagesSaved = 
bit4(0x00d64001) + bit5(0x00d64001) + bit6(0x00d64001) + bit7(0x00d64001) + 
bitcount(0x00d64002) + bit0(0x00d64003)

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









