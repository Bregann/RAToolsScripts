// Petz: Catz 2 | Petz: Dogz 2
// #ID = 21954

function IsCatzAndInGame() => ascii_string_equals(0x0048c77d, "CATZ/BAS") && (byte(dword(dword(0x004af598) + 0x628) + 0xac) != 0x00)
function IsDogzAndInGame() => ascii_string_equals(0x0048c89d, "DOGZ/BAS") && (byte(dword(dword(0x004af718) + 0x628) + 0xac) != 0x00)

// =============== PROGRESSION ===============
function ProgressionAchievement(achTitle, achDesc, points, achType, catzAddr, dogzAddr, prevValue)
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

ProgressionAchievement("Fun and Games!", "Complete the activities with Victor and exit Dolphin Coast", 2, "PROGRESSION", 0x01e4177c, 0x01e47d7c, 0x00)
ProgressionAchievement("Ivlet Has Escaped", "Visit the jail and take the hat to Ivlet", 2, "PROGRESSION", 0x01e41790, 0x01e47d90, 0x00)
ProgressionAchievement("Drug Store Repaired", "Repair Gertrude's drug store", 2, "PROGRESSION", 0x01e4179d, 0x01e47d9d, 0x03)
ProgressionAchievement("Tom Back in Business", "Hand the herb oil to Tom to help him re-open his shop", 2, "PROGRESSION", 0x01e417a1, 0x01e47da1, 0x03)

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

ProgressionAchievement("Saul Saviour", "Rescue Saul in Whisker Woods", 2, "PROGRESSION", 0x01e417a4, 0x01e47da4, 0x34)
ProgressionAchievement("Flower Power", "Repair the flower bed", 2, "PROGRESSION", 0x01e417a9, 0x01e47da9, 0x03)
ProgressionAchievement("Bling Buyer", "Repair Sheila's fashion house", 2, "PROGRESSION", 0x1e417b3, 0x01e47daf, 0x03)
ProgressionAchievement("Fishy Fixer", "Repair the aquarium", 2, "PROGRESSION", 0x01e417b4, 0x01e47db4, 0x34)
ProgressionAchievement("Stanley Speed Boost", "Help Godfrey by speeding up Stanley with a new friend", 3, "PROGRESSION", 0x01e417bb, 0x01e47dbb, 0x34)
ProgressionAchievement("The Animal Whisperer", "Learn \"Call\" from Saul", 2, "PROGRESSION", 0x01e417bd, 0x01e47dbd, 0x34)
ProgressionAchievement("Icebreaker", "Melt the frozen river", 2, "PROGRESSION", 0x01e417c1, 0x01e47dc1, 0x03)
ProgressionAchievement("A Zoo Without Animals", "Repair the zoo", 3, "PROGRESSION", 0x01e417ca, 0x01e47dca, 0x03)
ProgressionAchievement("A Rocky Unlock", "Learn \"Pick Up and Throw\"", 2, "PROGRESSION", 0x01e417d4, 0x01e47dd4, 0x03)
ProgressionAchievement("Rain Rain Go Away!", "Clear the rain from Pawville", 3, "PROGRESSION", 0x01e417d8, 0x01e47dd8, 0x03)
ProgressionAchievement("Hero Healer", "Deliver the cough medicine to Toby & Daisy", 3, "PROGRESSION", 0x01e417dd, 0x01e47ddd, 0x03)
ProgressionAchievement("Begone Bramble", "Remove the bramble from the windmill", 3, "PROGRESSION", 0x01e417e1, 0x01e47de1, 0x03)
ProgressionAchievement("A Wise Wizard", "Meet Theophilus", 2, "PROGRESSION", 0x01e417e4, 0x01e47de4, 0x03)
ProgressionAchievement("Lightning up the Way", "Repair the lighthouse and depart off to Monolith Isle", 3, "PROGRESSION", 0x01e417e9, 0x01e47de9, 0x03)
ProgressionAchievement("Bubble Cave Adventure", "Find the Water crystal", 4, "PROGRESSION", 0x01e417f4, 0x01e47df4, 0x03)
ProgressionAchievement("A Hot Hot Hot Journey", "Find the Earth crystal", 4, "PROGRESSION", 0x01e417fd, 0x01e47dfd, 0x03)
ProgressionAchievement("Polar Expedition", "Find the Ice crystal", 4, "PROGRESSION", 0x01e41805, 0x01e47e05, 0x03)
ProgressionAchievement("Storm Chaser", "Clear the tornados", 4, "PROGRESSION", 0x01e41810, 0x01e47e10, 0x34)
ProgressionAchievement("Big Bad Wolf Down", "Defeat Ivlet", 10, "WIN_CONDITION", 0x01e41820, 0x01e47e20, 0x03)