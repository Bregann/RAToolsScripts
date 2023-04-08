// L.A. Rush
// #ID = 20732

//Races
CurrentRace = byte(0x003ffee4)

RaceDict = {
    0x69: "Hollywood Race 1",
    0x6a: "Hollywood Race 2",
    0x6b: "Hollywood Race 3",
    0x6c: "Hollywood Race 4",
    0x6d: "Hollywood Race 5",
    0x6e: "Hollywood Race 6",
    0x6f: "Hollywood Race 7",
    0x70: "Hollywood Race 8",
    0x71: "Santa Monica Race 1",
    0x72: "Santa Monica Race 2",
    0x73: "Santa Monica Race 3",
    0x74: "Santa Monica Race 4",
    0x75: "Santa Monica Race 5",
    0x76: "Santa Monica Race 6",
    0x77: "Santa Monica Race 7",
    0x78: "Santa Monica Race 8",
    0x79: "Santa Monica Race 9",
    0x7a: "South Central Race 1",
    0x7b: "South Central Race 2",
    0x7c: "South Central Race 3",
    0x7d: "South Central Race 4",
    0x7e: "South Central Race 5",
    0x7f: "South Central Race 6",
    0x80: "South Central Race 7",
    0x81: "South Central Race 8",
    0x82: "South Central Race 9",
    0x83: "South Central Race 10",
    0x84: "South Bay Race 1",
    0x85: "South Bay Race 2",
    0x86: "South Bay Race 3",
    0x87: "South Bay Race 4",
    0x88: "South Bay Race 5",
    0x89: "South Bay Race 6",
    0x8a: "South Bay Race 7",
    0x8b: "South Bay Race 8",
    0x8c: "South Bay Race 9",
    0x8d: "South Bay Race 10",
    0x8e: "South Bay Race 11",
    0x8f: "Downtown Race 1",
    0x90: "Downtown Race 2",
    0x91: "Downtown Race 3",
    0x92: "Downtown Race 4",
    0x93: "Downtown Race 5",
    0x94: "Downtown Race 6",
    0x95: "Downtown Race 7",
    0x96: "Downtown Race 8",
    0x97: "Downtown Race 9",
    0x98: "Downtown Race 10",
    0x99: "Downtown Race 11",
    0x9a: "Downtown Race 12",
    0x9b: "Downtown Race 13",
    0x9c: "Hollywood Endurance Race",
}

//Car unlocks
//0x01 = no
//0x02 = yes
ChevroletCorvetteZ06Unlocked = byte(0x003fc3e0)
ChevroletChevelleSS454LS6Unlocked = byte(0x003fc3e4)
DodgeHemiChargerRTUnlocked = byte(0x003fc3e8)
ChevroletCorvetteStingrayUnlocked = byte(0x003fc3ec)
H2HummerUnlocked = byte(0x003fc3f0)
NissanSkylineGTRR34Unlocked = byte(0x003fc3f4)
ChevroletCamaroUnlocked = byte(0x003fc3f8)
CadillacEscaladeUnlocked = byte(0x003fc3fc)
Chevrolet84ImpalaSSUnlocked = byte(0x003fc400)
LotusExigeUnlocked = byte(0x003fc404)
MitsubishiEclipseSpyderUnlocked = byte(0x003fc408)
MitsubishiLancerEVO8Unlocked = byte(0x003fc40c)
Nissan350ZUnlocked = byte(0x003fc410)
Pontiac66GTOUnlocked = byte(0x003fc414)
LotusElise111Unlocked = byte(0x003fc418)
DodgeViperSRT10Unlocked = byte(0x003fc41c)
Nissan240SXUnlocked = byte(0x003fc420)
DodgeRamRumbleBeeUnlocked = byte(0x003fc424)
DodgeChargerUnlocked = byte(0x003fc428)
ChevroletSSRUnlocked = byte(0x003fc42c)
SaleenS7Unlocked = byte(0x003fc430)
NissanSentraSERSpecVUnlocked = byte(0x003fc434)
Pontiac05GTOUnlocked = byte(0x003fc438)
InfinitiFX45Unlocked = byte(0x003fc43c)
DodgeMagnumRTUnlocked = byte(0x003fc440)
DodgeNeonSRT4Unlocked = byte(0x003fc444)
NissanFrontierUnlocked = byte(0x003fc448)
OldsmobileCutlassSupremeUnlocked = byte(0x003fc44c)
BuickGNXUnlocked = byte(0x003fc450)
ChevroletMonteCarloUnlocked = byte(0x003fc454)
CadillacEldoradoUnlocked = byte(0x003fc458)
ChevroletImpalaUnlocked = byte(0x003fc45c)
NissanTitanUnlocked = byte(0x003fc460)
Chevrolet00ImpalaSSUnlocked = byte(0x003fc464)
PontiacSolsticeUnlocked = byte(0x003fc468)
SubaruImprezaWRXSTIUnlocked = byte(0x003fc46c)
MidwayConcept01Unlocked = byte(0x003fc470)
MidwayConcept02Unlocked = byte(0x003fc474)
MidwayConcept03Unlocked = byte(0x003fc478)
MidwayConcept04Unlocked = byte(0x003fc47c)
MidwayConcept05Unlocked = byte(0x003fc480)
MidwayConcept06Unlocked = byte(0x003fc484)
MidwayConcept07Unlocked = byte(0x003fc488)
MidwayConcept08Unlocked = byte(0x003fc48c)
MidwayConcept09Unlocked = byte(0x003fc490)
MidwayConcept10Unlocked = byte(0x003fc494)
MidwayConcept11Unlocked = byte(0x003fc498)
MidwayConcept12Unlocked = byte(0x003fc49c)
MidwayConcept13Unlocked = byte(0x003fc4a0)
MidwayConcept14Unlocked = byte(0x003fc4a4)
MidwayConcept15Unlocked = byte(0x003fc4a8)
MidwayConcept16Unlocked = byte(0x003fc4ac)
MidwayConcept17Unlocked = byte(0x003fc4b0)
MidwayConcept18Unlocked = byte(0x003fc4b4)
MidwayConcept19Unlocked = byte(0x003fc4b8)
MidwayConcept20Unlocked = byte(0x003fc4bc)

// ===================================
// RACE WIN ACHIEVEMENTS
// ===================================

function CreateRaceWinAchievement(raceId, raceName)
{
    achievement(
        title = raceName + " Winner",
        description = "Come 1st place on " + raceName,
        points = 5,
        trigger = (
            raceId == CurrentRace //todo: the logic
        )
    )
}

for key in RaceDict{
    CreateRaceWinAchievement(key, RaceDict[key])
}

