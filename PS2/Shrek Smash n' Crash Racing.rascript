// Shrek: Smash n' Crash Racing
// #ID = 21878

//Race stuff
TrackIdArr = [
    0x00,
    0x01,
    0x02,
    0x03,
    0x04,
    0x05,
    0x06,
    0x07,
    0x08,
    0x09,
    0x0a,
    0x0b,
    0x0c,
    0x0d,
    0x0e,
    0x0f,
    0x10,
    0x11,
    0x12,
    0x13,
    0x14,
    0x15,
    0x16,
    0x17
]

TrackNameArr = [
    "Swamp",
    "Green Forest",
    "Haunted Woods",
    "Suburbs of Far Far Away",
    "Downtown of Far Far Away",
    "Far Far Away Castle",
    "Farmland",
    "Potion Factory Exterior",
    "Potion Factory Interior",
    "Mountain Pass",
    "Dragon's Castle",
    "Dragon's Lair",
    "Mirror Mode: Swamp",
    "Mirror Mode: Green Forest",
    "Mirror Mode: Haunted Woods",
    "Mirror Mode: Suburbs of Far Far Away",
    "Mirror Mode: Downtown of Far Far Away",
    "Mirror Mode: Far Far Away Castle",
    "Mirror Mode: Farmland",
    "Mirror Mode: Potion Factory Exterior",
    "Mirror Mode: Potion Factory Interior",
    "Mirror Mode: Mountain Pass",
    "Mirror Mode: Dragon's Castle",
    "Mirror Mode: Dragon's Lair"
]

BestTimeArr = [
    float(0x4bf120),
    float(0x4bf134),
    float(0x4bf148),
    float(0x4bf15c),
    float(0x4bf170),
    float(0x4bf184),
    float(0x4bf198),
    float(0x4bf1ac),
    float(0x4bf1c0),
    float(0x4bf1d4),
    float(0x4bf1e8),
    float(0x4bf1fc),
    float(0x4bf210),
    float(0x4bf224),
    float(0x4bf238),
    float(0x4bf24c),
    float(0x4bf260),
    float(0x4bf274),
    float(0x4bf288),
    float(0x4bf29c),
    float(0x4bf2b0),
    float(0x4bf2c4),
    float(0x4bf2d8),
    float(0x4bf2ec),
]

TimeTrialTimeArr = [
    131.00,
    104.00,
    113.00,
    133.00,
    140.00,
    137.00,
    182.00,
    163.00,
    149.00,
    244.00,
    238.00,
    254.00
]

TimeTrial2TimeArr = [
    "2:11:00",
    "1:44:00",
    "1:53:00",
    "2:13:00",
    "2:20:00",
    "2:17:00",
    "3:02:00",
    "2:43:00",
    "2:29:00",
    "4:04:00",
    "3:58:00",
    "4:14:00"
]

CurrentTrack = byte(0x01be0c74)
CurrentCharacter = byte(0x004be52d)
PlayerTourneyPoints = byte(0x004be59c)
CurrentMode = byte(0x004be510)
PlayerCupPoints = byte(0x004be570)

function PussInBootsUnlocked() => bit2(0x004be5c4) == 0x01 && prev(bit2(0x004be5c4)) == 0x00
function PrinceCharmingUnlocked() => bit3(0x004be5c4) == 0x01 && prev(bit3(0x004be5c4)) == 0x00
function HumptyDumptyUnlocked() => bit4(0x004be5c4) == 0x01 && prev(bit4(0x004be5c4)) == 0x00
function RedRidingHoodUnlocked() => bit5(0x004be5c4) == 0x01 && prev(bit5(0x004be5c4)) == 0x00
function PinocchioHoodUnlocked() => bit6(0x004be5c4) == 0x01 && prev(bit6(0x004be5c4))  == 0x00
function ThreeLittlePigsUnlocked() => bit7(0x004be5c4) == 0x01 && prev(bit7(0x004be5c4)) == 0x00
function GoldilocksUnlocked() => bit0(0x004be5c5) == 0x01 && prev(bit0(0x004be5c5)) == 0x00
function TheloniousUnlocked() => bit1(0x004be5c5) == 0x01 && prev(bit1(0x004be5c5)) == 0x00

function WonTourney() => PlayerTourneyPoints > byte(0x4be59d) &&
PlayerTourneyPoints > byte(0x4be59e) && PlayerTourneyPoints > byte(0x4be59e) && 
PlayerTourneyPoints > byte(0x4be5a0) && PlayerTourneyPoints > byte(0x4be5a1)

// ===================================
// Character unlocks
// ===================================
function CharacterUnlocks(achName, achDesc, trackId, RacerUnlocked)
{
    achievement(
        title = achName,
        description = achDesc,
        points = 3,
        trigger = (
            CurrentTrack == trackId &&
            RacerUnlocked
        )
    )
}

CharacterUnlocks("The Purrfect Racer", "Unlock Puss in Boots from the swamp cup", 0x02, PussInBootsUnlocked())
CharacterUnlocks("A Charming Unlock", "Unlock Prince Charming from the far far away cup", 0x05, PrinceCharmingUnlocked())
CharacterUnlocks("Don't Crash into a Wall!", "Unlock Humpty Dumpty from the factory cup", 0x08, HumptyDumptyUnlocked())
CharacterUnlocks("The Big Bad Wolf", "Unlock Red Riding Hood from the dragon cup", 0x0b, RedRidingHoodUnlocked())
CharacterUnlocks("Why the Long Nose?", "Unlock Pinocchio from the mirror mode swamp cup", 0x0e, PinocchioHoodUnlocked())
CharacterUnlocks("Piggy Power Unleashed", "Unlock Three Little Pigs from the mirror mode far far away cup", 0x11, ThreeLittlePigsUnlocked())
CharacterUnlocks("Beary Good Teamwork", "Unlock Goldilocks from the mirror mode factory cup", 0x14, GoldilocksUnlocked())
CharacterUnlocks("The Mirror Smasher", "Unlock Thelonious from the mirror mode dragon cup", 0x17, TheloniousUnlocked())

// ===================================
// Tourney wins
// ===================================
function WinTourneyCharacter(achTitle, charName, charId)
{
    achievement(
        title = achTitle,
        description = "Win conventional tournament mode with the most points playing as " + charName + " (cannot be a tie)",
        points = 10,
        trigger = (
            CurrentTrack == 0x0b &&
            CurrentCharacter == charId &&
            CurrentMode == 0x00 &&
            PlayerTourneyPoints > prev(PlayerTourneyPoints) &&
            PlayerCupPoints != 0x00 &&
            WonTourney()
        )
    )
}

WinTourneyCharacter("The Champion of the Swamp", "Shrek", 0x00)
WinTourneyCharacter("Flying to Victory", "Donkey", 0x01)
WinTourneyCharacter("Chariot Champion", "Princess Fiona", 0x02)
WinTourneyCharacter("Sweet Victory", "Gingy", 0x03)
WinTourneyCharacter("Paws on the Podium", "Puss in Boots", 0x04)
WinTourneyCharacter("A Noble Victory", "Prince Charming", 0x05)
WinTourneyCharacter("An Eggcellent Race", "Humpty Dumpty", 0x06)
WinTourneyCharacter("The Woods' Fastest Rider", "Red Riding Hood", 0x07)
WinTourneyCharacter("Puppet Power", "Pinocchio", 0x08)
WinTourneyCharacter("A Ham-tastic Win", "Three Little Pigs", 0x09)
WinTourneyCharacter("A Bearilliant Victory", "Goldilocks", 0x0a)
WinTourneyCharacter("Executed The Competition", "Thelonious", 0x0b)

achievement(
    title = "A Confusing Race",
    description = "Win mirrored tournament mode with the most points (cannot be a tie)",
    points = 5,
    trigger = (
        CurrentTrack == 0x17 &&
        CurrentMode == 0x00 &&
        PlayerTourneyPoints > prev(PlayerTourneyPoints) &&
        PlayerCupPoints != 0x00 &&
        WonTourney()
    )
)

// ===================================
// Time trials
// ===================================
function TimeTrialAchievements(trackName, trackId, speedrunTimer, timeToBeat, descTimeToBeat)
{
    achievement(
        title = trackName + " Speedrunner",
        description = "Beat " + trackName + " in " + descTimeToBeat + " or lower in time trial mode",
        points = 10,
        trigger = (
            CurrentTrack == trackId &&
            CurrentMode == 0x03 &&
            (prev(speedrunTimer) == 0.00 || prev(speedrunTimer) > timeToBeat) &&
            speedrunTimer < timeToBeat &&
            speedrunTimer != 0.00
        )
    )
}

for i in range(0, 11)
{
    TimeTrialAchievements(TrackNameArr[i], TrackIdArr[i], BestTimeArr[i], TimeTrialTimeArr[i], TimeTrial2TimeArr[i])
}




// ===================================
// Leaderboards
// ===================================
function RaceLeaderboard(trackName, trackId, bestTime)
{
    leaderboard(
        title = trackName,
        description = "Get the fastest time on " + trackName + " (submits the 1st place record on save file)",
        start = (
            CurrentTrack == trackId &&
            byte(0x01b4143f) == 0x00 &&
            (float(0x01be0d40) <= 1.00 && float(0x01be0d40) != 0.00)
        ),
        cancel = (
            CurrentTrack != trackId
        ),
        submit = (
            bestTime != 0.00 &&
            byte(0x01b4143f) == 0x01
        ),
        value = bestTime,
        format = "SECS",
        lower_is_better = true
    )
}

for i in range(0, 23)
{
    RaceLeaderboard(TrackNameArr[i], TrackIdArr[i], BestTimeArr[i])
}