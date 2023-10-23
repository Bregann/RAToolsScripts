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
            byte(0x0479) == 0x00 &&
            byte(0x0128) == 0x80 &&
            prev(byte(0x0128)) != 0x80
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
            byte(0x06a8) == 0x00 &&
            byte(0x06aa) >= diff &&
            CurrentRound == 4 &&
            byte(0x0128) == 0x80 &&
            prev(byte(0x0128)) != 0x80
        )
    )
}
//todo: update this to win instead of complete
WinRound("Round Champ", "Correctly answer the puzzle on round 1 on any difficulty", 2, 1, 0)
WinRound("Puzzle Perfectionist", "Correctly answer the puzzle on round 2 on any difficulty", 3, 1, 1)
WinRound("Wheel Whiz", "Correctly answer the puzzle on round 3 on any difficulty", 3, 1, 2)
WinRound("Puzzle Prodigy", "Correctly answer the puzzle on round 4 on any difficulty", 4, 1, 3)
WinBonus("Bonus Bonus Bonus", "Win the bonus round on any difficulty", 10, 1)

WinRound("Riddle Master", "Correctly answer the puzzle on round 1 on hard difficulty", 3, 2, 0)
WinRound("Puzzle Maestro", "Correctly answer the puzzle on round 2 on hard difficulty", 4, 2, 1)
WinRound("Riddle Reveler", "Correctly answer the puzzle on round 3 on hard difficulty", 4, 2, 2)
WinRound("Smartest Tool in the Shed", "Correctly answer the puzzle on round 4 on hard difficulty", 5, 2, 3)
WinBonus("A Well Deserved Prize", "Win the bonus round on hard difficulty", 10, 2)

function SolvePuzzle(achTitle, achDesc, puzzleType) 
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
            byte(0x0477) >= 0x03 &&
            ((CurrentRound == 0x00 && byte(0x0369) == puzzleType) || 
            (CurrentRound == 0x01 && byte(0x036a) == puzzleType) || 
            (CurrentRound == 0x02 && byte(0x036b) == puzzleType) || 
            (CurrentRound == 0x03 && byte(0x036c) == puzzleType) ||
            (CurrentRound == 0x04 && byte(0x036d) == puzzleType))
        )
    )
}

SolvePuzzle("Chlorophyll", "Correctly solve a 'Thing' puzzle", 0x00)
SolvePuzzle("Mandalay", "Correctly solve a 'Place' puzzle", 0x01)
SolvePuzzle("Denver Pyle", "Correctly solve a 'Fictional Character' puzzle", 0x02)
SolvePuzzle("A Litter of Puppies", "Correctly solve a 'Things' puzzle", 0x03)
SolvePuzzle("Investment Bankers", "Correctly solve a 'Phrase' puzzle", 0x04)
SolvePuzzle("Alexander's Ragtime Band", "Correctly solve a 'Title' puzzle", 0x05)
SolvePuzzle("Emmy Awards Night", "Correctly solve a 'People' puzzle", 0x06)
SolvePuzzle("A Prime Suspect", "Correctly solve a 'Event' puzzle", 0x07)
SolvePuzzle("Martin Van Buren", "Correctly solve a 'Person' puzzle", 0x08)
SolvePuzzle("Hot Dog Stand By Me", "Correctly solve a 'Before and After' puzzle", 0x09)
SolvePuzzle("Nancy & Trini Lopez", "Correctly solve a 'Same Name' puzzle", 0x0a)

achievement(
    title = "I Don't Need \"U\"",
    description = "Solve a puzzle correctly without ever buying a vowel",
    points = 5,
    trigger = (
        InSPGame() &&
        trigger_when(byte(0x0128) == 0x80 && byte(0x0479) == 0x00) &&
        prev(byte(0x0128)) != 0x00 &&
        once(ascii_string_equals(0x0564, "  0")) &&
        never(prev(byte(0x0128)) == 0x80 || (byte(0x0477) == 0x03 && byte(0x0479) == 0x00))
    )
)