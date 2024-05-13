// Petz: Catz 2 | Petz: Dogz 2
// #ID = 21954

function IsCatzAndInGame() => ascii_string_equals(0x0048c77d, "CATZ/BAS") && (byte(dword(dword(0x004af598) + 0x628) + 0xac) != 0x00)
function IsDogzAndInGame() => ascii_string_equals(0x0048c89d, "DOGZ/BAS") && (byte(dword(dword(0x004af718) + 0x628) + 0xac) != 0x00)

// =============== PROGRESSION ===============
function ProgressionAchievement(achTitle, achDesc, points, achType, addr, prevValue)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        type = achType,
        trigger = (
            (
                IsCatzAndInGame() && 
                byte(addr) == 0x44 &&
                prev(byte(addr)) == prevValue
            ) 
            ||
            (
                IsDogzAndInGame() && 
                byte(addr + 0x6600) == 0x44 &&
                prev(byte(addr + 0x6600)) == prevValue
            )
        )
    )
}

ProgressionAchievement("Fun and Games!", "Complete the activities with Victor and exit Dolphin Coast", 2, "PROGRESSION", 0x01e4177c, 0x00)
ProgressionAchievement("Ivlet Has Escaped", "Visit the jail and take the hat to Ivlet", 2, "PROGRESSION", 0x01e41793, 0x00)
ProgressionAchievement("Drug Store Repaired", "Repair Gertrude's drug store", 2, "PROGRESSION", 0x01e4179d, 0x03)
ProgressionAchievement("Tom Back in Business", "Hand the herb oil to Tom to help him re-open his shop", 2, "PROGRESSION", 0x01e417a1, 0x03)

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

ProgressionAchievement("Saul Saviour", "Rescue Saul in Whisker Woods", 2, "PROGRESSION", 0x01e417a4, 0x34)
ProgressionAchievement("Flower Power", "Fix the flower bed", 2, "PROGRESSION", 0x01e417a9, 0x03)
ProgressionAchievement("Bling Buyer", "Fix Sheila's fashion house", 2, "PROGRESSION", 0x01e417b3, 0x03)
ProgressionAchievement("Fishy Fixer", "Fix the aquarium", 2, "PROGRESSION", 0x01e417b4, 0x34)