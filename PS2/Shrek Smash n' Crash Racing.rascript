// Shrek: Smash n' Crash Racing
// #ID = 21878

//Race stuff
TrackDict = {
    0x00: "Swamp",
    0x01: "Green Forest",
    0x02: "Haunted Woods",
    0x03: "Suburbs of Far Far Away",
    0x04: "Downtown of Far Far Away",
    0x05: "Far Far Away Castle",
    0x06: "Farmland",
    0x07: "Potion Factory Exterior",
    0x08: "Potion Factory Interior",
    0x09: "Mountain Pass",
    0x0a: "Dragon's Castle",
    0x0b: "Dragon's Lair",
    0x0c: "Mirror Mode: Swamp",
    0x0d: "Mirror Mode: Green Forest",
    0x0e: "Mirror Mode: Haunted Woods",
    0x0f: "Mirror Mode: Suburbs of Far Far Away",
    0x10: "Mirror Mode: Downtown of Far Far Away",
    0x11: "Mirror Mode: Far Far Away Castle",
    0x12: "Mirror Mode: Farmland",
    0x13: "Mirror Mode: Potion Factory Exterior",
    0x14: "Mirror Mode: Potion Factory Interior",
    0x15: "Mirror Mode: Mountain Pass",
    0x16: "Mirror Mode: Dragon's Castle",
    0x17: "Mirror Mode: Dragon's Lair"
}

CurrentTrack = byte(0x01be0c74)
PlayerTourneyPoints = byte(0x004be59c)

function PussInBootsUnlocked() => bit2(0x004be5c4) == 0x01 && prev(bit2(0x004be5c4)) == 0x00
function PrinceCharmingUnlocked() => bit3(0x004be5c4) == 0x01 && prev(bit3(0x004be5c4)) == 0x00
function HumptyDumptyUnlocked() => bit4(0x004be5c4) == 0x01 && prev(bit4(0x004be5c4)) == 0x00
function RedRidingHoodUnlocked() => bit5(0x004be5c4) == 0x01 && prev(bit5(0x004be5c4)) == 0x00
function PinocchioHoodUnlocked() => bit6(0x004be5c4) == 0x01 && prev(bit6(0x004be5c4))  == 0x00
function ThreeLittlePigsUnlocked() => bit7(0x004be5c4) == 0x01 && prev(bit7(0x004be5c4)) == 0x00
function GoldilocksUnlocked() => bit0(0x004be5c5) == 0x01 && prev(bit0(0x004be5c5)) == 0x00
function TheloniousUnlocked() => bit1(0x004be5c5) == 0x01 && prev(bit1(0x004be5c5)) == 0x00

function WonTourney() => PlayerTourneyPoints >= byte(0x4be59d) &&
PlayerTourneyPoints >= byte(0x4be59e) && PlayerTourneyPoints >= byte(0x4be59e) && 
PlayerTourneyPoints >= byte(0x4be5a0) && PlayerTourneyPoints >= byte(0x4be5a1)

// ===================================
// Character unlocks
// ===================================
function CharacterUnlocks(achName, achDesc, trackId, RacerUnlocked)
{
    achievement(
        title = achName,
        description = achDesc,
        points = 5,
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
CharacterUnlocks("Beary Good Teamwork", "Unlock Golilocks from the mirror mode factory cup", 0x14, GoldilocksUnlocked())
CharacterUnlocks("The Mirror Smasher", "Unlock Thelonious from the mirror mode dragon cup", 0x17, TheloniousUnlocked())

// ===================================
// Tourney wins
// ===================================

