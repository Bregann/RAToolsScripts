// Micro Machines
// #ID = 13231

RaceMode = byte(0x1c3f)
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
Progression("Taking Out the Competition", "Knock out the 3rd person on challenge mode (win race 8)", 10, 9)
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

//Head to head progression
achievement (
    title = "Head to Head Journey Begins",
    description = "Qualify on head to head mode",
    points = 2,
    trigger = (
        RaceMode == 0x01 &&
        ChallengeRaceNumber == 1 &&
        prev(ChallengeRaceNumber) == 0
    )
)

function HeadToHeadProgression(achTitle, points, roundNum, roundEndCheck, diff) {
    achievement (
        title = achTitle,
        description = "Complete race " + roundNum + " on head to head mode",
        points = points,
        trigger = (
            RaceMode == 0x01 &&
            ChallengeRaceNumber == roundEndCheck &&
            prev(ChallengeRaceNumber) == roundEndCheck - diff
        )
    )
}

HeadToHeadProgression("Breakfast Race", 3, 1, 2, 1)
HeadToHeadProgression("Speedy Desktop Race", 3, 2, 3, 1)
HeadToHeadProgression("Alleyway Warriors", 4, 3, 4, 1)
HeadToHeadProgression("A Turbo Day at the Beach", 4, 4, 5, 1)
HeadToHeadProgression("4x4 Oatmeal", 4, 5, 6, 1)
HeadToHeadProgression("F1 Cue-ball Race", 4, 6, 7, 1)
HeadToHeadProgression("Handyman Warriors", 5, 7, 8, 1)
HeadToHeadProgression("Bathtub Speedster", 5, 8, 9, 1)
HeadToHeadProgression("Sahara Racer", 5, 9, 11, 2)
HeadToHeadProgression("Fruit-Juice Follies", 5, 10, 12, 1)
HeadToHeadProgression("Foamy Fjords", 5, 11, 13, 1)
HeadToHeadProgression("Bedroom Tanks", 5, 12, 14, 1)
HeadToHeadProgression("Pitfall Pockets", 10, 13, 15, 1)
HeadToHeadProgression("Pencil Plateaux", 10, 14, 16, 1)
HeadToHeadProgression("The Dare-Devil Dunes", 10, 15, 18, 2)
HeadToHeadProgression("Perilous Pit-Stop", 10, 16, 19, 1)
HeadToHeadProgression("Wide-Awake War-Zone", 10, 17, 20, 1)
HeadToHeadProgression("Crayon Canyons", 10, 18, 21, 1)
HeadToHeadProgression("Soap-Lake City!", 10, 19, 23, 2)
HeadToHeadProgression("Chalk-Dust Chicane", 10, 20, 24, 1)
HeadToHeadProgression("Go For It!", 25, 21, 25, 1)
HeadToHeadProgression("Head to Head Champ", 25, 22, 26, 1)