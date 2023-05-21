// L.A. Rush
// #ID = 20732


//achievement for under 10% damage

//Races
CurrentRace = byte(0x003ffee4)
RacePosition = byte(0x01f17f83)
function RaceComplete() => byte(0x01f17f84) == 0xfe && (prev(byte(0x01f17f84)) == 0x01 || prev(byte(0x01f17f84)) == 0x00)

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

HollywoodAcquire1 = 0x1e
HollywoodAcquire2 = 0x1f
HollywoodAcquire3 = 0x20
HollywoodAcquire4 = 0x21
SantaMonicaAcquire1 = 0x22
SantaMonicaAcquire2 = 0x23
SantaMonicaAcquire3 = 0x24
SantaMonicaAcquire4 = 0x25
SantaMonicaAcquire5 = 0x26
SouthCentralAcquire1 = 0x27
SouthCentralAcquire2 = 0x28
SouthCentralAcquire3 = 0x2a
SouthCentralAcquire4 = 0x2b
SouthCentralAcquire5 = 0x2c
SouthCentralAcquire6 = 0x2d
SouthBayAcquire1 = 0x2e
SouthBayAcquire2 = 0x2f
SouthBayAcquire3 = 0x30
SouthBayAcquire4 = 0x31
SouthBayAcquire5 = 0x32
SouthBayAcquire6 = 0x33
SouthBayAcquire7 = 0x34
DowntownAcquire1 = 0x35
DowntownAcquire2 = 0x36
DowntownAcquire3 = 0x37
DowntownAcquire4 = 0x38
DowntownAcquire5 = 0x39
DowntownAcquire6 = 0x3a
DowntownAcquire7 = 0x3b
DowntownAcquire8 = 0x3c

//Retribution
RetributionSignsDestroyed = byte(0x00447884)
HollywoodRetributionId = 0x29
SantaMonicaRetributionId = 0x3d
SouthCentralRetributionId = 0x3e
SouthBayRetributionId = 0x3f
DowntownRetributionId = 0x40
// ===================================
// RACE WIN ACHIEVEMENTS
// ===================================

function CreateRaceWinAchievement(raceId, raceName, points)
{
    achievement(
        title = raceName + " Winner",
        description = "Come 1st place on " + raceName,
        points = points,
        trigger = (
            raceId == CurrentRace &&
            RaceComplete() &&
            RacePosition == 0x01
        )
    )
}

for key in RaceDict{
    if(key == 0x69 || key == 0x6a || key == 0x6d || key == 0x71 || key == 0x72 ||
        key == 0x74 || key == 0x7a || key == 0x7b || key == 0x7d || key == 0x84 ||
        key == 0x85 || key == 0x87 || key == 0x8f || key == 0x90 || key == 0x92
    )
    {
        CreateRaceWinAchievement(key, RaceDict[key], 5)
    }
    else if(key == 0x9c)
    {
        CreateRaceWinAchievement(key, RaceDict[key], 25)
    }
    else{
        CreateRaceWinAchievement(key, RaceDict[key], 10)
    }
}

// ===================================
// CAR UNLOCK ACHIEVEMENTS
// ===================================

function AcquireUnlocks(carName, raceId, carUnlock)
{
    achievement(
        title = carName + " Acquired",
        description = "Unlock the " + carName + " from the acquire mission",
        points = 5,
        trigger = (
            raceId == CurrentRace &&
            carUnlock == 0x02 &&
            prev(carUnlock) == 0x01
        )
    )
}

AcquireUnlocks("Chevrolet Impala SS 84", HollywoodAcquire1, Chevrolet84ImpalaSSUnlocked)
AcquireUnlocks("Chevrolet Impala SS 00", HollywoodAcquire2, Chevrolet00ImpalaSSUnlocked)
AcquireUnlocks("Nissan Frontier", HollywoodAcquire3, NissanFrontierUnlocked)
AcquireUnlocks("Nissan Titan", HollywoodAcquire4, NissanTitanUnlocked)
AcquireUnlocks("Chevrolet Monte Carlo", SantaMonicaAcquire1, ChevroletMonteCarloUnlocked)
AcquireUnlocks("Chevrolet Camaro", SantaMonicaAcquire2, ChevroletCamaroUnlocked)
AcquireUnlocks("Dodge Ram Rumble Bee", SantaMonicaAcquire3, DodgeRamRumbleBeeUnlocked)
AcquireUnlocks("Nissan SentraSE- R Spec V", SouthCentralAcquire1, NissanSentraSERSpecVUnlocked)
AcquireUnlocks("Infiniti FX 45", SouthCentralAcquire2, InfinitiFX45Unlocked)
AcquireUnlocks("Pontiac Solstice", SouthCentralAcquire3, PontiacSolsticeUnlocked)



AcquireUnlocks("Dodge Magnum RT", SouthBayAcquire1, DodgeMagnumRTUnlocked)
// ===================================
// RETRIBUTION ACHIEVEMENTS
// ===================================
function RetributionCompleted(achName, achDesc, raceId, missionMem)
{
    achievement(
        title = achName,
        description = achDesc,
        points = 5,
        trigger = (
            raceId == CurrentRace &&
            missionMem == 0x05 &&
            prev(missionMem) == 0x02
        )
    )
}

RetributionCompleted("Taking Back Hollywood", "Complete the Hollywood retribution mission", HollywoodRetributionId, byte(0x003fc1b8))
RetributionCompleted("Taking Back Santa Monica", "Complete the Santa Monica retribution mission", SantaMonicaRetributionId, byte(0x003fc208))
RetributionCompleted("Taking Back South Central", "Complete the South Central retribution mission", SouthCentralRetributionId, byte(0x003fc20c))
RetributionCompleted("Taking Back South Bay", "Complete the South Bay retribution mission", SouthBayRetributionId, byte(0x003fc210))
RetributionCompleted("Taking Back Downtown", "Complete the Downtown retribution mission", DowntownRetributionId, byte(0x003fc210))