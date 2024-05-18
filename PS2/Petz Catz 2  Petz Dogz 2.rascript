// Petz: Catz 2 | Petz: Dogz 2
// #ID = 21954

function IsCatzAndInGame() => ascii_string_equals(0x0048c77d, "CATZ/BAS") && dword(0x004af57c) != 0x00
function IsDogzAndInGame() => ascii_string_equals(0x0048c89d, "DOGZ/BAS") && dword(0x004af6fc) != 0x00

// =============== PROGRESSION ===============
function DiaryTaskComplete(achTitle, achDesc, points, achType, catzAddr, dogzAddr, prevValue)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        type = achType,
        trigger = (
            (
                IsCatzAndInGame() && 
                byte(catzAddr) == 0x44 &&
                prev(byte(catzAddr)) == prevValue
            ) 
            ||
            (
                IsDogzAndInGame() && 
                byte(dogzAddr) == 0x44 &&
                prev(byte(dogzAddr)) == prevValue
            )
        )
    )
}

DiaryTaskComplete("Fun and Games!", "Complete the activities with Victor and exit Dolphin Coast", 2, "PROGRESSION", 0x01e4177c, 0x01e47d7c, 0x00)
DiaryTaskComplete("Ivlet Has Escaped", "Visit the jail and take the hat to Ivlet", 2, "PROGRESSION", 0x01e41790, 0x01e47d90, 0x00)
DiaryTaskComplete("Drug Store Repaired", "Repair Gertrude's drug store", 2, "PROGRESSION", 0x01e4179d, 0x01e47d9d, 0x03)
DiaryTaskComplete("Tom Back in Business", "Hand the herb oil to Tom to help him re-open his shop", 2, "PROGRESSION", 0x01e417a1, 0x01e47da1, 0x03)

// Added it in here so I didn't have to re-order the achievements later lol
achievement(
    title = "Food Finder",
    description = "Get the bonus reward from Saul when rescuing him in Whisker Woods",
    points = 3,
    type = "MISSABLE",
    trigger = (
        (
            IsCatzAndInGame() &&
            byte(0x01e417a4) == 0x34 &&
            byte(0x0050045a) == 0x10 &&
            prev(byte(0x0050045a)) == 0x00
        )
        ||
        (
            IsDogzAndInGame() &&
            byte(0x01e47da4) == 0x34 &&
            byte(0x005005da) == 0x10 &&
            prev(byte(0x005005da)) == 0x00
        )
    )
)

DiaryTaskComplete("Saul Saviour", "Rescue Saul in Whisker Woods", 3, "PROGRESSION", 0x01e417a4, 0x01e47da4, 0x34)
DiaryTaskComplete("Flower Power", "Repair the flower bed", 3, "PROGRESSION", 0x01e417a9, 0x01e47da9, 0x03)
DiaryTaskComplete("Bling Buyer", "Repair Sheila's fashion house", 3, "PROGRESSION", 0x1e417b3, 0x01e47daf, 0x03)
DiaryTaskComplete("Fishy Fixer", "Repair the aquarium", 3, "PROGRESSION", 0x01e417b4, 0x01e47db4, 0x34)
DiaryTaskComplete("Stanley Speed Boost", "Help Godfrey by speeding up Stanley with a new friend", 4, "PROGRESSION", 0x01e417bb, 0x01e47dbb, 0x34)
DiaryTaskComplete("The Animal Whisperer", "Learn \"Call\" from Saul", 3, "PROGRESSION", 0x01e417bd, 0x01e47dbd, 0x34)
DiaryTaskComplete("Icebreaker", "Melt the frozen river", 3, "PROGRESSION", 0x01e417c1, 0x01e47dc1, 0x03)
DiaryTaskComplete("A Zoo Without Animals", "Repair the zoo", 3, "PROGRESSION", 0x01e417ca, 0x01e47dca, 0x03)
DiaryTaskComplete("A Rocky Unlock", "Learn \"Pick Up and Throw\"", 2, "PROGRESSION", 0x01e417d4, 0x01e47dd4, 0x03)
DiaryTaskComplete("Rain Rain Go Away!", "Clear the rain from Pawville", 4, "PROGRESSION", 0x01e417d8, 0x01e47dd8, 0x03)
DiaryTaskComplete("Hero Healer", "Deliver the cough medicine to Toby & Daisy", 4, "PROGRESSION", 0x01e417dd, 0x01e47ddd, 0x03)
DiaryTaskComplete("Begone Bramble", "Remove the bramble from the windmill", 4, "PROGRESSION", 0x01e417e1, 0x01e47de1, 0x03)
DiaryTaskComplete("A Wise Wizard", "Meet Theophilus", 3, "PROGRESSION", 0x01e417e4, 0x01e47de4, 0x03)
DiaryTaskComplete("Lightning up the Way", "Repair the lighthouse and depart off to Monolith Isle", 4, "PROGRESSION", 0x01e417e9, 0x01e47de9, 0x03)
DiaryTaskComplete("Bubble Cave Adventure", "Find the Water crystal", 5, "PROGRESSION", 0x01e417f4, 0x01e47df4, 0x03)
DiaryTaskComplete("A Hot Hot Hot Journey", "Find the Earth crystal", 5, "PROGRESSION", 0x01e417fd, 0x01e47dfd, 0x03)
DiaryTaskComplete("Polar Expedition", "Find the Ice crystal", 5, "PROGRESSION", 0x01e41805, 0x01e47e05, 0x03)
DiaryTaskComplete("Storm Chaser", "Clear the tornados", 4, "PROGRESSION", 0x01e41810, 0x01e47e10, 0x34)
DiaryTaskComplete("Big Bad Wolf Down", "Defeat Ivlet", 10, "WIN_CONDITION", 0x01e41820, 0x01e47e20, 0x03)

// The bonus missions
DiaryTaskComplete("A Volcanic Task", "Return the lava stone to Charles", 5, "", 0x01e41864, 0x01e47e64, 0x03)
DiaryTaskComplete("Golden Fishy", "Return the golden fish to Charles", 5, "", 0x01e41868, 0x01e47e68, 0x03)

// The zoo animals
DiaryTaskComplete("Grizzly Angler Conqueror", "Catch the fish for the bear and return him to the zoo", 4, "", 0x01e4182c, 0x01e47e2c, 0x03)
DiaryTaskComplete("Ultimate Treasure Digger", "Beat the kiwi in the treasure hunt minigame", 4, "", 0x01e47e30, 0x01e47e30, 0x03)
DiaryTaskComplete("Boar off Back to the Zoo!", "Beat the boar in the flag race minigame", 4, "", 0x01e41834, 0x01e47e34, 0x03)
DiaryTaskComplete("Heave Ho", "Beat the elephant in the sled pull minigame", 4, "", 0x01e41838, 0x01e47e38, 0x03)
DiaryTaskComplete("Buffalo Slide", "Beat the buffalo in the chicken race minigame", 4, "", 0x01e4183c, 0x01e47e3c, 0x03)
DiaryTaskComplete("Flying High", "Beat the vulture in the rodeo minigame", 4, "", 0x01e41840, 0x01e47e40, 0x03)
DiaryTaskComplete("Monkeying Around", "Beat the monkey in the dodgeball minigame", 4, "", 0x01e41844, 0x01e47e44, 0x03)
DiaryTaskComplete("Ring Toss Champion", "Beat the giraffe in the ring toss battle minigame", 4, "", 0x01e41848, 0x01e47e48, 0x03)
DiaryTaskComplete("Cold Belly!", "Beat the penguin in the curling minigame", 4, "", 0x01e4184c, 0x01e47e4c, 0x03)
DiaryTaskComplete("Skidding Around", "Beat the lion in the hockey minigame", 4, "", 0x01e41850, 0x01e47e50, 0x03)
DiaryTaskComplete("They See Me Rolling", "Beat the panda in the barrel race minigame", 4, "", 0x01e41854, 0x01e47e54, 0x03)
DiaryTaskComplete("Raining Bananas and Apples", "Beat the gorilla in the fruit catch minigame", 4, "", 0x01e41858, 0x01e47e58, 0x03)

// =============== COLLECTIONS ===============
FishCollectionCatz = 
bit0(0x4dd9da) + bit2(0x4dd9da) + bit4(0x4dd9da) + bit6(0x4dd9da) + 
bit0(0x4dd9db) + bit2(0x4dd9db) + bit4(0x4dd9db) + bit6(0x4dd9db) + 
bit0(0x4dd9dc) + bit2(0x4dd9dc) + bit4(0x4dd9dc) + bit6(0x4dd9dc) + 
bit0(0x4dd9dd) + bit2(0x4dd9dd) + bit4(0x4dd9dd) + bit6(0x4dd9dd) + 
bit0(0x4dd9de) + bit2(0x4dd9de) + bit4(0x4dd9de) + bit6(0x4dd9de) + 
bit0(0x4dd9df) + bit2(0x4dd9df) + bit4(0x4dd9df) + bit6(0x4dd9df) + 
bit0(0x4dd9e0) + bit2(0x4dd9e0) + bit4(0x4dd9e0) + bit6(0x4dd9e0) + 
bit0(0x4dd9e1) + bit2(0x4dd9e1) + bit4(0x4dd9e1) + bit6(0x4dd9e1) + 
bit0(0x4dd9e2) + bit2(0x4dd9e2) + bit4(0x4dd9e2) + bit6(0x4dd9e2) + 
bit0(0x4dd9e3) + bit2(0x4dd9e3) + bit4(0x4dd9e3) + bit6(0x4dd9e3) + 
bit0(0x4dd9e4) + bit2(0x4dd9e4) + bit4(0x4dd9e4) + bit6(0x4dd9e4) + 
bit0(0x4dd9e5) + bit2(0x4dd9e5) + bit4(0x4dd9e5) + bit6(0x4dd9e5) + 
bit0(0x4dd9e6) + bit2(0x4dd9e6) + bit4(0x4dd9e6) + bit6(0x4dd9e6) + 
bit0(0x4dd9e7) + bit2(0x4dd9e7) + bit4(0x4dd9e7) + bit6(0x4dd9e7) + 
bit0(0x4dd9e8) + bit2(0x4dd9e8) + bit4(0x4dd9e8) + bit6(0x4dd9e8) + 
bit0(0x4dd9e9) + bit2(0x4dd9e9) + bit4(0x4dd9e9) + bit6(0x4dd9e9) + 
bit0(0x4dd9ea) + bit2(0x4dd9ea) + bit4(0x4dd9ea) + bit6(0x4dd9ea) + 
bit0(0x4dd9eb) + bit2(0x4dd9eb)
FishCollectionDogz = 
bit0(0x4ddb5a) + bit2(0x4ddb5a) + bit4(0x4ddb5a) + bit6(0x4ddb5a) + 
bit0(0x4ddb5b) + bit2(0x4ddb5b) + bit4(0x4ddb5b) + bit6(0x4ddb5b) + 
bit0(0x4ddb5c) + bit2(0x4ddb5c) + bit4(0x4ddb5c) + bit6(0x4ddb5c) + 
bit0(0x4ddb5d) + bit2(0x4ddb5d) + bit4(0x4ddb5d) + bit6(0x4ddb5d) + 
bit0(0x4ddb5e) + bit2(0x4ddb5e) + bit4(0x4ddb5e) + bit6(0x4ddb5e) + 
bit0(0x4ddb5f) + bit2(0x4ddb5f) + bit4(0x4ddb5f) + bit6(0x4ddb5f) + 
bit0(0x4ddb60) + bit2(0x4ddb60) + bit4(0x4ddb60) + bit6(0x4ddb60) + 
bit0(0x4ddb61) + bit2(0x4ddb61) + bit4(0x4ddb61) + bit6(0x4ddb61) + 
bit0(0x4ddb62) + bit2(0x4ddb62) + bit4(0x4ddb62) + bit6(0x4ddb62) + 
bit0(0x4ddb63) + bit2(0x4ddb63) + bit4(0x4ddb63) + bit6(0x4ddb63) + 
bit0(0x4ddb64) + bit2(0x4ddb64) + bit4(0x4ddb64) + bit6(0x4ddb64) + 
bit0(0x4ddb65) + bit2(0x4ddb65) + bit4(0x4ddb65) + bit6(0x4ddb65) + 
bit0(0x4ddb66) + bit2(0x4ddb66) + bit4(0x4ddb66) + bit6(0x4ddb66) + 
bit0(0x4ddb67) + bit2(0x4ddb67) + bit4(0x4ddb67) + bit6(0x4ddb67) + 
bit0(0x4ddb68) + bit2(0x4ddb68) + bit4(0x4ddb68) + bit6(0x4ddb68) + 
bit0(0x4ddb69) + bit2(0x4ddb69) + bit4(0x4ddb69) + bit6(0x4ddb69) + 
bit0(0x4ddb6a) + bit2(0x4ddb6a) + bit4(0x4ddb6a) + bit6(0x4ddb6a) + 
bit0(0x4ddb6b) + bit2(0x4ddb6b)

InsectCollectionCatz = 
bit4(0x4dd9eb) + bit6(0x4dd9eb) + 
bit0(0x4dd9ec) + bit2(0x4dd9ec) + bit4(0x4dd9ec) + bit6(0x4dd9ec) + 
bit0(0x4dd9ed) + bit2(0x4dd9ed) + bit4(0x4dd9ed) + bit6(0x4dd9ed) + 
bit0(0x4dd9ee) + bit2(0x4dd9ee) + bit4(0x4dd9ee) + bit6(0x4dd9ee) + 
bit0(0x4dd9ef) + bit2(0x4dd9ef) + bit4(0x4dd9ef) + bit6(0x4dd9ef) + 
bit0(0x4dd9f0) + bit2(0x4dd9f0) + bit4(0x4dd9f0) + bit6(0x4dd9f0) +
bit0(0x4dd9f1) + bit2(0x4dd9f1) + bit4(0x4dd9f1) + bit6(0x4dd9f1) + 
bit0(0x4dd9f2) + bit2(0x4dd9f2) + bit4(0x4dd9f2) + bit6(0x4dd9f2) + 
bit0(0x4dd9f3) + bit2(0x4dd9f3) + bit4(0x4dd9f3) + bit6(0x4dd9f3) + 
bit0(0x4dd9f4)
InsectCollectionDogz = 
bit4(0x4ddb6b) + bit6(0x4ddb6b) + 
bit0(0x4ddb6c) + bit2(0x4ddb6c) + bit4(0x4ddb6c) + bit6(0x4ddb6c) + 
bit0(0x4ddb6d) + bit2(0x4ddb6d) + bit4(0x4ddb6d) + bit6(0x4ddb6d) + 
bit0(0x4ddb6e) + bit2(0x4ddb6e) + bit4(0x4ddb6e) + bit6(0x4ddb6e) + 
bit0(0x4ddb6f) + bit2(0x4ddb6f) + bit4(0x4ddb6f) + bit6(0x4ddb6f) + 
bit0(0x4ddb70) + bit2(0x4ddb70) + bit4(0x4ddb70) + bit6(0x4ddb70) + 
bit0(0x4ddb71) + bit2(0x4ddb71) + bit4(0x4ddb71) + bit6(0x4ddb71) + 
bit0(0x4ddb72) + bit2(0x4ddb72) + bit4(0x4ddb72) + bit6(0x4ddb72) + 
bit0(0x4ddb73) + bit2(0x4ddb73) + bit4(0x4ddb73) + bit6(0x4ddb73) + 
bit0(0x4ddb74)

FruitVegCollectionCatz = 
bit0(0x4dd9ca) + bit2(0x4dd9ca) + bit4(0x4dd9ca) + bit6(0x4dd9ca) + 
bit0(0x4dd9cb) + bit2(0x4dd9cb) + bit4(0x4dd9cb) + bit6(0x4dd9cb) + 
bit0(0x4dd9cc) + bit2(0x4dd9cc) + bit4(0x4dd9cc) + bit6(0x4dd9cc) + 
bit0(0x4dd9cd) + bit2(0x4dd9cd) + bit4(0x4dd9cd) + bit6(0x4dd9cd) + 
bit0(0x4dd9ce) + bit2(0x4dd9ce) + bit4(0x4dd9ce) + bit6(0x4dd9ce) + 
bit0(0x4dd9cf) + bit2(0x4dd9cf) + bit4(0x4dd9cf) + bit6(0x4dd9cf) + 
bit0(0x4dd9d0) + bit2(0x4dd9d0) + bit4(0x4dd9d0) + bit6(0x4dd9d0) + 
bit0(0x4dd9d1) + bit2(0x4dd9d1) + bit4(0x4dd9d1) + bit6(0x4dd9d1) + 
bit0(0x4dd9d2) + bit2(0x4dd9d2) + bit4(0x4dd9d2) + bit6(0x4dd9d2) + 
bit0(0x4dd9d3) + bit2(0x4dd9d3) + bit4(0x4dd9d3) + bit6(0x4dd9d3) + 
bit0(0x4dd9d4)
FruitVegCollectionDogz = 
bit0(0x4ddb4a) + bit2(0x4ddb4a) + bit4(0x4ddb4a) + bit6(0x4ddb4a) + 
bit0(0x4ddb4b) + bit2(0x4ddb4b) + bit4(0x4ddb4b) + bit6(0x4ddb4b) + 
bit0(0x4ddb4c) + bit2(0x4ddb4c) + bit4(0x4ddb4c) + bit6(0x4ddb4c) + 
bit0(0x4ddb4d) + bit2(0x4ddb4d) + bit4(0x4ddb4d) + bit6(0x4ddb4d) + 
bit0(0x4ddb4e) + bit2(0x4ddb4e) + bit4(0x4ddb4e) + bit6(0x4ddb4e) + 
bit0(0x4ddb4f) + bit2(0x4ddb4f) + bit4(0x4ddb4f) + bit6(0x4ddb4f) + 
bit0(0x4ddb50) + bit2(0x4ddb50) + bit4(0x4ddb50) + bit6(0x4ddb50) + 
bit0(0x4ddb51) + bit2(0x4ddb51) + bit4(0x4ddb51) + bit6(0x4ddb51) + 
bit0(0x4ddb52) + bit2(0x4ddb52) + bit4(0x4ddb52) + bit6(0x4ddb52) + 
bit0(0x4ddb53) + bit2(0x4ddb53) + bit4(0x4ddb53) + bit6(0x4ddb53) + 
bit0(0x4ddb54)

FlowersCollectionCatz = 
bit2(0x4dd9d4) + bit4(0x4dd9d4) + bit6(0x4dd9d4) + 
bit0(0x4dd9d5) + bit2(0x4dd9d5) + bit4(0x4dd9d5) + bit6(0x4dd9d5) + 
bit0(0x4dd9d6) + bit2(0x4dd9d6) + bit4(0x4dd9d6) + bit6(0x4dd9d6) + 
bit0(0x4dd9d7) + bit2(0x4dd9d7) + bit4(0x4dd9d7) + bit6(0x4dd9d7) + 
bit0(0x4dd9d8) + bit2(0x4dd9d8) + bit4(0x4dd9d8) + bit6(0x4dd9d8) + 
bit0(0x4dd9d9) + bit2(0x4dd9d9) + bit4(0x4dd9d9)
FlowersCollectionDogz = 
bit2(0x4ddb54) + bit4(0x4ddb54) + bit6(0x4ddb54) + 
bit0(0x4ddb55) + bit2(0x4ddb55) + bit4(0x4ddb55) + bit6(0x4ddb55) + 
bit0(0x4ddb56) + bit2(0x4ddb56) + bit4(0x4ddb56) + bit6(0x4ddb56) + 
bit0(0x4ddb57) + bit2(0x4ddb57) + bit4(0x4ddb57) + bit6(0x4ddb57) + 
bit0(0x4ddb58) + bit2(0x4ddb58) + bit4(0x4ddb58) + bit6(0x4ddb58) + 
bit0(0x4ddb59) + bit2(0x4ddb59) + bit4(0x4ddb59)

function EncyclopediaCollection(achTitle, achDesc, points, catzCollectionAddr, dogzCollectionAddr, collectionAmount)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            (
                IsCatzAndInGame() && 
                measured(catzCollectionAddr >= collectionAmount) &&
                prev(catzCollectionAddr) < collectionAmount
            ) 
            ||
            (
                IsDogzAndInGame() && 
                measured(dogzCollectionAddr == collectionAmount) &&
                prev(dogzCollectionAddr) == collectionAmount
            )
        )
    )
}

EncyclopediaCollection("Fishy Business", "Complete 50% of the fish collection (unlocks when you save)", 10, FishCollectionCatz, FishCollectionDogz, 45)
EncyclopediaCollection("Master Angler", "Complete 100% of the fish collection (unlocks when you save)", 25, FishCollectionCatz, FishCollectionDogz, 70)
EncyclopediaCollection("Insect Inspector", "Complete 50% of the insect collection (unlocks when you save)", 10, InsectCollectionCatz, InsectCollectionDogz, 17)
EncyclopediaCollection("Bugged Out", "Complete 100% of the insect collection (unlocks when you save)", 10, InsectCollectionCatz, InsectCollectionDogz, 35)
EncyclopediaCollection("Keeping Healthy", "Complete 50% of the fruit & vegetables collection (unlocks when you save)", 10, FruitVegCollectionCatz, FruitVegCollectionDogz, 20)
EncyclopediaCollection("A Fruity Collection", "Complete 100% of the fruit & vegetables collection (unlocks when you save)", 10, FruitVegCollectionCatz, FruitVegCollectionDogz, 41)
EncyclopediaCollection("Finding Flowers", "Complete 50% of the flowers collection (unlocks when you save)", 10, FlowersCollectionCatz, FlowersCollectionDogz, 11)
EncyclopediaCollection("Flourishing in Flowers", "Complete 100% of the flowers collection (unlocks when you save)", 10, FlowersCollectionCatz, FlowersCollectionDogz, 22)

function ClothingUnlocks(achTitle, achDesc, points, catzAddr, dogzAddr, count)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            (
                IsCatzAndInGame() && 
                catzAddr == count &&
                prev(catzAddr) == count - 1
            ) 
            ||
            (
                IsDogzAndInGame() && 
                dogzAddr == count &&
                prev(dogzAddr) == count - 1
            )
        )
    )
}

ClothingUnlocks("Looking Smart", "Open the secret chest in Crystal Caverns", 2, bit4(0x050049a), bit4(0x0050061a), 1)
ClothingUnlocks("Ready to Put out Fires", "Open the secret chest in Bubble Cave", 2, bit2(0x05004c1), bit2(0x00500641), 1)
ClothingUnlocks("Arrrr Me Eye", "Open the secret chest in Inferno Cave", 2, bit5(0x0500548), bit5(0x005006c8), 1)
ClothingUnlocks("A Cheery Unlock", "Open the secret chest in Sky Heights", 2, bit7(0x0500761), bit7(0x005008e1), 1)
ClothingUnlocks("Rocking the Ribbon", "Open the secret chest in Polar Fields", 2, bit5(0x0500768), bit5(0x005008e8), 1)
ClothingUnlocks("Dressed To Impress", "Open both secret chests in Gongoro Peak", 2, bit2(0x0500695) + bit4(0x50070e), bit2(0x00500815) + bit4(0x0050088e), 2)

// Clothing for playing 5 games with each animal in zoo
ClothingUnlocks("Plundering an Accessory", "Unlock the unique accessory from the vulture in the zoo by playing their minigame 5 times", 5, bit4(0x0050047a), bit4(0x005005fa), 1)
ClothingUnlocks("Where's The Beach?", "Unlock the unique accessory from the buffalo in the zoo by playing their minigame 5 times", 5, bit2(0x005007b5), bit2(0x00500935), 1)
ClothingUnlocks("Noble Accessory", "Unlock the unique accessory from the lion in the zoo by playing their minigame 5 times", 5, bit0(0x005005dc), bit0(0x0050075c), 1)
ClothingUnlocks("Pretty Hat", "Unlock the unique accessory from the giraffe in the zoo by playing their minigame 5 times", 5, bit0(0x005004c8), bit0(0x00500648), 1)
ClothingUnlocks("Ready to Set Sail", "Unlock the unique accessory from the panda in the zoo by playing their minigame 5 times", 5, bit2(0x00500655), bit2(0x005007d5), 1)
ClothingUnlocks("Parrrrty!", "Unlock the unique accessory from the gorilla in the zoo by playing their minigame 5 times", 5, bit2(0x00500535), bit2(0x005006b5), 1)
ClothingUnlocks("Winging It", "Unlock the unique accessory from the penguin in the zoo by playing their minigame 5 times", 5, bit2(0x00500735), bit2(0x005008b5), 1)
ClothingUnlocks("Sombrero", "Unlock the unique accessory from the elephant in the zoo by playing their minigame 5 times", 5, bit7(0x0050048d), bit7(0x0050060d), 1)
ClothingUnlocks("Postman Pat", "Unlock the unique accessory from the kiwi in the zoo by playing their minigame 5 times", 5, bit2(0x00500401), bit2(0x00500581), 1)
ClothingUnlocks("Another Cool Hat", "Unlock the unique accessory from the monkey in the zoo by playing their minigame 5 times", 5, bit0(0x00500488), bit0(0x00500608), 1)
ClothingUnlocks("Stars in Your Eyes", "Unlock the unique accessory from the boar in the zoo by playing their minigame 5 times", 5, bit0(0x0050053c), bit0(0x005006bc), 1)

// Clothing for unique items from catching animals
CatzAnimalItemsCaught = 
byte(0x4dde67) + byte(0x4dde6d) + byte(0x4dde73) + byte(0x4dde8f) + byte(0x4dde95) + 
byte(0x4ddea7) + byte(0x4ddea9) + byte(0x4ddec5) + byte(0x4ddec7) + byte(0x4dded5) + 
byte(0x4ddf1b) + byte(0x4ddf2d) + byte(0x4ddf2f) + byte(0x4ddf67)

DogzAnimalItemsCaught = 
byte(0x4ddfe7) + byte(0x4ddfed) + byte(0x4ddff3) + byte(0x4de00f) + byte(0x4de015) + 
byte(0x4de027) + byte(0x4de029) + byte(0x4de045) + byte(0x4de047) + byte(0x4de055) + 
byte(0x4de09b) + byte(0x4de0ad) + byte(0x4de0af) + byte(0x4de0e7)

function CatchAnimals(achTitle, points, animalAmount)
{
    achievement(
        title = achTitle,
        description = "Catch " + animalAmount + " animals and take their items to Shelia (unlocks when you save)",
        points = points,
        trigger = (
            (
                IsCatzAndInGame() && 
                CatzAnimalItemsCaught >= animalAmount * 0x55 &&
                prev(CatzAnimalItemsCaught) < animalAmount * 0x55
            ) 
            ||
            (
                IsDogzAndInGame() && 
                DogzAnimalItemsCaught >= animalAmount * 0x55 &&
                prev(DogzAnimalItemsCaught) < animalAmount * 0x55
            )
        )
    )
}

CatchAnimals("Filling the Shop", 5, 5)
CatchAnimals("Looking Snazzy", 5, 10)
CatchAnimals("Master Animal Catcher", 10, 14)

// =============== CHALLENGES ===============
// 280 ring toss
// 380 fruit
// 220 treasure hunt

function MinigameTimer(achTitle, achDesc, catzAddr, dogzAddr, amount)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = 10,
        trigger = (
                        (
                IsCatzAndInGame() && 
                catzAddr > amount &&
                prev(catzAddr) < amount
            ) 
            ||
            (
                IsDogzAndInGame() && 
                dogzAddr > amount &&
                prev(dogzAddr) < amount
            )
        )
    )
}

function MinigamePoints(achTitle, achDesc, catzAddr, dogzAddr, amount)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = 10,
        trigger = (
                        (
                IsCatzAndInGame() && 
                catzAddr >= amount &&
                prev(catzAddr) < amount
            ) 
            ||
            (
                IsDogzAndInGame() && 
                dogzAddr >= amount &&
                prev(dogzAddr) < amount
            )
        )
    )
}
MinigameTimer("Flagging Away", "Beat flag race course 1 in under 31 seconds", dword(0x501318), dword(0x501498), 1860)
MinigameTimer("Flag Speedster", "Beat flag race course 2 in under 36 seconds", dword(0x501448), dword(0x5015c4), 2160)
MinigameTimer("Fastest Flag Catcher Around", "Beat flag race course 3 in under 50 seconds", dword(0x501570), dword(0x5016f0), 3000)
MinigameTimer("Strong Animal", "Beat sled pull course 1 in under 25 seconds", dword(0x500e60), dword(0x500fe0), 1500)
MinigameTimer("Terrain Crosser", "Beat sled pull course 2 in under 25 seconds", dword(0x500f8c), dword(0x50110c), 1500)
MinigameTimer("Dodging the Rocks", "Beat sled pull course 3 in under 29 seconds", dword(0x5010b8), dword(0x501238), 1740)
MinigameTimer("Perfect Balance", "Beat barrel ride in under 41 seconds", dword(0x501dc0), dword(0x501f40), 2460)
MinigameTimer("Speedy Flight", "Beat rodeo in under 49 seconds", dword(0x501c90), dword(0x501e10), 2940)

MinigamePoints("Ring Ring Ring", "Reach a score of 280 or more on ring toss", dword(0x501ef0), dword(0x502070), 280)
MinigamePoints("Fruit Ninja", "Reach a score of 380 or more on fruit catch", dword(0x501900), dword(0x501a80), 380)
MinigamePoints("Hunting for Gold", "Reach a score of 220 or more on treasure hunt", dword(0x5016a0), dword(0x501820), 220)