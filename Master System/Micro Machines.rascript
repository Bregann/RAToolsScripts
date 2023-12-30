// Micro Machines
// #ID = 13231

RaceMode = byte(0x17b4)
ChallengeRaceNumber = byte(0x1bd8)
CurrentCharacter = byte(0x1bd4)

//Progression achievements
function Progression(achTitle, achDesc, points, round) {
    achievement (
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            RaceMode == 0x00 &&
            ChallengeRaceNumber == round &&
            prev(ChallengeRaceNumber) == round - 1
        )
    )   
}

Progression("Getting Started", "Win the qualifying race on challenge mode", 2, 1)
Progression("First Out", "Knock out the first person on challenge mode (win race 2)", 5, 3)
Progression("Player Wipeout", "Knock out the 2nd person on challenge mode (win race 5)", 5, 6)
Progression("Taking Out the Competition", "Knock out the 3rd person on challenge mode (win race 8)", 10, 8)
Progression("Another One Bites the Dust", "Knock out the 4th person on challenge mode (win race 11)", 10, 13)
Progression("Knocking Out the Racers", "Knock out the 5th person on challenge mode (win race 14)", 10, 16)
Progression("Track Champion", "Knock out the 6th person on challenge mode (win race 17)", 10, 20)
Progression("Competition Crusher", "Knock out the 7th person on challenge mode (win race 20)", 25, 24)
Progression("Champion of Champions", "Become the challenge champion", 25, 26)

//Head to head wins
function HeadToHeadWin(charName, charId) {
    achievement (
        title = "Head to Head Winner: " + charName,
        description = "Win a head to head race as " + charName,
        points = 3,
        trigger = (
            RaceMode == 0x01 &&
            trigger_when(ChallengeRaceNumber > prev(ChallengeRaceNumber)) &&
            CurrentCharacter == charId
        )
    )
}

HeadToHeadWin("Chen", 0x00)
HeadToHeadWin("Spider", 0x08)
HeadToHeadWin("Walter", 0x10)
HeadToHeadWin("Dwayne", 0x18)
HeadToHeadWin("Joel", 0x20)
HeadToHeadWin("Bonnie", 0x28)
HeadToHeadWin("Mike", 0x30)
HeadToHeadWin("Emilio", 0x38)
HeadToHeadWin("Jethro", 0x40)
HeadToHeadWin("Annie", 0x48)
HeadToHeadWin("Cherry", 0x50)
