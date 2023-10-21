// Wheel of Fortune - Starring Vanna White
// #ID = 2071

function InSPGame() => byte(0x06a8) == 0x00 && byte(0x0698) != 0x07
CurrentRound = byte(0x0478)

function WinRound(achTitle, achDesc, points, diff, round) 
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            InSPGame() &&
            byte(0x06aa) >= diff &&
            CurrentRound == round &&
            prev(CurrentRound) == round - 1
        )
    )
}

function WinBonus(achTitle, achDesc, points, diff) 
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            InSPGame() &&
            byte(0x06aa) >= diff &&
            CurrentRound == 4 &&
            byte(0x0128) == 0x80 &&
            prev(byte(0x0128)) != 0x80
        )
    )
}

WinRound("Round 1", "Complete round 1 on any difficulty", 2, 1, 1)
WinRound("Round 2", "Complete round 2 on any difficulty", 3, 1, 2)
WinRound("Round 3", "Complete round 3 on any difficulty", 3, 1, 3)
WinRound("Round 4", "Complete round 4 on any difficulty", 4, 1, 3)
WinBonus("Bonus Bonus Bonus", "Win the bonus round on any difficulty", 10, 1)

WinRound("Round 1 Hard", "Complete round 1 on hard difficulty", 3, 2, 1)
WinRound("Round 2 Hard", "Complete round 2 on hard difficulty", 4, 2, 2)
WinRound("Round 3 Hard", "Complete round 3 on hard difficulty", 4, 2, 3)
WinRound("Round 4 Hard", "Complete round 4 on hard difficulty", 5, 2, 3)
WinBonus("Bonus Bonus Bonus Hard", "Win the bonus round on hard difficulty", 10, 2)

function SolvePuzzle(achTitle, achDesc, points, puzzleType) 
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = 3,
        trigger = (
            InSPGame() &&
            byte(0x0479) == 0x00 &&
            byte(0x0128) == 0x80 &&
            prev(byte(0x0128)) != 0x00 &&
            ((CurrentRound == 0x00 && byte(0x0369) == puzzleType) || 
            (CurrentRound == 0x01 && byte(0x036a) == puzzleType) || 
            (CurrentRound == 0x02 && byte(0x036b) == puzzleType) || 
            (CurrentRound == 0x03 && byte(0x036c) == puzzleType) ||
            (CurrentRound == 0x04 && byte(0x036d) == puzzleType))
        )
    )
}

SolvePuzzle("Thing", "Correctly solve a 'Thing' puzzle", 0x00)
SolvePuzzle("Place", "Correctly solve a 'Place' puzzle", 0x01)
SolvePuzzle("Fictional Character", "Correctly solve a 'Fictional Character' puzzle", 0x02)
SolvePuzzle("Things", "Correctly solve a 'Things' puzzle", 0x03)
SolvePuzzle("Phrase", "Correctly solve a 'Phrase' puzzle", 0x04)
SolvePuzzle("Title", "Correctly solve a 'Title' puzzle", 0x05)
SolvePuzzle("People", "Correctly solve a 'People' puzzle", 0x06)
SolvePuzzle("Event", "Correctly solve a 'Event' puzzle", 0x07)
SolvePuzzle("Person", "Correctly solve a 'Person' puzzle", 0x08)
SolvePuzzle("Before and After", "Correctly solve a 'Before and After' puzzle", 0x09)
SolvePuzzle("Same Name", "Correctly solve a 'Same Name' puzzle", 0x0a)