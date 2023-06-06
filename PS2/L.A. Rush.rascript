// L.A. Rush
// #ID = 20732

//Pointers
PoliceStars = byte(dword(0x003e71b4) + 0x408)
RacePosition = byte(dword(0x004bfde4) + 0x33)
CurrentLap = byte(dword(0x004bfde4) + 0x34)
RaceCompleted = byte(dword(0x004bfde4) + 0x40)

//Races
CurrentRace = byte(0x003ffee4)
function RaceComplete() => RaceCompleted == 0x72 && prev(RaceCompleted) == 0x70
RaceTimer = float(0x00418c0c)
IngameTimer = float(0x00417e14)
function NoCheats() => byte(0x0037b2a4) == 0x00 && byte(0x0037b35c) == 0x00 && byte(0x004000dd) == 0x00
GameDiff = byte(0x003fff40)
function InStunt() => dword(0x003dffed) != 0x00
NitroBoosts = byte(0x01f181bc)

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
        description = "Come 1st place on " + raceName + " on normal difficulty or higher",
        points = points,
        trigger = (
            raceId == CurrentRace &&
            RaceComplete() &&
            NoCheats() &&
            GameDiff >= 0x01 &&
            RacePosition == 0x01
        )
    )
}

function CreateRaceKOWinAchievement(raceId, raceName, points)
{
    achievement(
        title = raceName + " Winner",
        description = "Come 1st place on " + raceName + " on normal difficulty or higher",
        points = points,
        trigger = (
            raceId == CurrentRace &&
            RaceComplete() &&
            NoCheats() &&
            GameDiff >= 0x01 &&
            RacePosition == 0x01 &&
            prior(CurrentLap) == 0x02
        )
    )
}

for key in RaceDict{
    if(key == 0x69 || key == 0x6a || key == 0x6d || key == 0x71 || key == 0x72 ||
        key == 0x74 || key == 0x7a || key == 0x7b || key == 0x7d || key == 0x84 ||
        key == 0x85 || key == 0x87 || key == 0x8f || key == 0x90 || key == 0x92)
    {
        CreateRaceWinAchievement(key, RaceDict[key], 3)
    }
    else if(key == 0x9c)
    {
        CreateRaceWinAchievement(key, RaceDict[key], 10)
    }
    else if(key == 0x70 || key == 0x78 || key == 0x81 || key == 0x8b || key == 0x96)
    {
        CreateRaceKOWinAchievement(key, RaceDict[key], 5)
    }
    else
    {
        CreateRaceWinAchievement(key, RaceDict[key], 5)
    }
}


// ===================================
// SPEEDRUN ACHIEVEMENTS
// ===================================
function RaceSpeedrun(raceId, raceName, points, timerFloat, timerDesc)
{
    achievement(
        title = raceName + " Speedrunner",
        description = "Reach a time of " + timerDesc + " or lower on " + raceName,
        points = points,
        trigger = (
            raceId == CurrentRace &&
            RaceComplete() &&
            NoCheats() &&
            RaceTimer <= timerFloat
        )
    )
}

function RaceSpeedrunKO(raceId, raceName, points, timerFloat, timerDesc)
{
    achievement(
        title = raceName + " Speedrunner",
        description = "Reach a time of " + timerDesc + " or lower on " + raceName,
        points = points,
        trigger = (
            raceId == CurrentRace &&
            RaceComplete() &&
            NoCheats() &&
            RaceTimer <= timerFloat &&
            prior(CurrentLap) == 0x02
        )
    )
}

RaceSpeedrun(0x6b, "Hollywood Race 3", 5, 82.0, "1:22:00")
RaceSpeedrun(0x6c, "Hollywood Race 4", 5, 87.0, "1:27:00")
RaceSpeedrun(0x6e, "Hollywood Race 6", 5, 112.0, "1:52:00")
RaceSpeedrun(0x6f, "Hollywood Race 7", 10, 120.0, "2:00:00")
RaceSpeedrunKO(0x70, "Hollywood Race 8", 10, 195.0, "3:15:00")
RaceSpeedrun(0x73, "Santa Monica Race 3", 5, 163.0, "2:43:00")
RaceSpeedrun(0x75, "Santa Monica Race 5", 5, 141.0, "2:21:00")
RaceSpeedrun(0x76, "Santa Monica Race 6", 5, 121.0, "2:01:00")
RaceSpeedrun(0x77, "Santa Monica Race 7", 10, 180.0, "3:00:00")
RaceSpeedrunKO(0x78, "Santa Monica Race 8", 5, 198.0, "3:18:00")
RaceSpeedrun(0x79, "Santa Monica Race 9", 5, 148.0, "2:28:00")
RaceSpeedrun(0x7c, "South Central Race 3", 5, 142.0, "2:22:00")
RaceSpeedrun(0x7e, "South Central Race 5", 5, 126.0, "2:06:00")
RaceSpeedrun(0x7f, "South Central Race 6", 5, 160.0, "2:40:00")
RaceSpeedrun(0x80, "South Central Race 7", 5, 162.0, "2:42:00")
RaceSpeedrunKO(0x81, "South Central Race 8", 10, 241.0, "4:01:00")
RaceSpeedrun(0x82, "South Central Race 9", 5, 161.0, "2:41:00")
RaceSpeedrun(0x83, "South Central Race 10", 5, 120.0, "2:00:00")
RaceSpeedrun(0x86, "South Bay Race 3", 5, 156.0, "2:36:00")
RaceSpeedrun(0x88, "South Bay Race 5", 5, 99.0, "1:39:00")
RaceSpeedrun(0x89, "South Bay Race 6", 5, 147.0, "2:27:00")
RaceSpeedrun(0x8a, "South Bay Race 7", 5, 166.0, "2:46:00")
RaceSpeedrunKO(0x8b, "South Bay Race 8", 10, 260.0, "4:20:00")
RaceSpeedrun(0x8c, "South Bay Race 9", 10, 200.0, "3:20:00")
RaceSpeedrun(0x8d, "South Bay Race 10", 10, 188.0, "3:08:00")
RaceSpeedrun(0x8e, "South Bay Race 11", 5, 134.0, "2:14:00")
RaceSpeedrun(0x91, "Downtown Race 3", 5, 135.0, "2:15:00")
RaceSpeedrun(0x93, "Downtown Race 5", 5, 177.0, "2:57:00")
RaceSpeedrun(0x94, "Downtown Race 6", 5, 150.0, "2:30:00")
RaceSpeedrun(0x95, "Downtown Race 7", 5, 161.0, "2:41:00")
RaceSpeedrunKO(0x96, "Downtown Race 8", 5, 158.0, "2:38:00")
RaceSpeedrun(0x97, "Downtown Race 9", 10, 190.0, "3:10:00")
RaceSpeedrun(0x98, "Downtown Race 10", 10, 208.0, "3:28:00")
RaceSpeedrun(0x99, "Downtown Race 11", 10, 213.0, "3:33:00")
RaceSpeedrun(0x9a, "Downtown Race 12", 10, 190.0, "3:10:00")
RaceSpeedrun(0x9b, "Downtown Race 13", 25, 315.0, "5:15:00")
RaceSpeedrun(0x9c, "Hollywood Endurance Race", 25, 575.0,"9:35:00")

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
AcquireUnlocks("Nissan Sentra SE-R Spec V", SouthCentralAcquire1, NissanSentraSERSpecVUnlocked)
AcquireUnlocks("Infiniti FX 45", SouthCentralAcquire2, InfinitiFX45Unlocked)
AcquireUnlocks("Pontiac Solstice", SouthCentralAcquire3, PontiacSolsticeUnlocked)
AcquireUnlocks("Chevrolet Chevelle SS-454 LS6", SouthCentralAcquire4, ChevroletChevelleSS454LS6Unlocked)
AcquireUnlocks("Mitsubishi Eclipse Spyder", SouthCentralAcquire5, MitsubishiEclipseSpyderUnlocked)
AcquireUnlocks("Dodge Hemi Charger R/T", SouthCentralAcquire6, DodgeHemiChargerRTUnlocked)
AcquireUnlocks("Dodge Magnum RT", SouthBayAcquire1, DodgeMagnumRTUnlocked)
AcquireUnlocks("Buick GNX", SouthBayAcquire2, BuickGNXUnlocked)
AcquireUnlocks("Dodge Neon SRT-4", SouthBayAcquire3, DodgeNeonSRT4Unlocked)
AcquireUnlocks("Lotus Elise 111", SouthBayAcquire4, LotusElise111Unlocked)
AcquireUnlocks("Dodge Charger", SouthBayAcquire5, DodgeChargerUnlocked)
AcquireUnlocks("Chevrolet Corvette Stingray", SouthBayAcquire6, ChevroletCorvetteStingrayUnlocked)
AcquireUnlocks("Nissan Skyline GTR R34", SouthBayAcquire7, NissanSkylineGTRR34Unlocked)
AcquireUnlocks("Nissan 350Z", DowntownAcquire1, Nissan350ZUnlocked)
AcquireUnlocks("Pontiac 05 GTO", DowntownAcquire2, Pontiac05GTOUnlocked)
AcquireUnlocks("Subaru Impreza WRX STI", DowntownAcquire3, SubaruImprezaWRXSTIUnlocked)
AcquireUnlocks("Lotus Exige", DowntownAcquire4, LotusExigeUnlocked)
AcquireUnlocks("Mitsubishi Lancer EVO 8", DowntownAcquire5, MitsubishiLancerEVO8Unlocked)
AcquireUnlocks("Chevrolet Corvette Z06", DowntownAcquire6, ChevroletCorvetteZ06Unlocked)
AcquireUnlocks("Dodge Viper SRT-10", DowntownAcquire7, DodgeViperSRT10Unlocked)
AcquireUnlocks("Saleen S7", DowntownAcquire8, SaleenS7Unlocked)

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
RetributionCompleted("Taking Back Downtown", "Complete the Downtown retribution mission", DowntownRetributionId, byte(0x003fc214))

// ===================================
// STUNT ACHIEVEMENTS
// ===================================
function StuntCompleted(stuntId) => stuntId == 0x06 && prev(stuntId) <= 0x03

function StuntCompletedAch(unlockedItem, stuntId)
{
    achievement(
        title = unlockedItem + " Unlocked",
        description = "Unlock " + unlockedItem + " from hidden stunts",
        points = 10,
        trigger = (
            dword(0x003dffed) != 0x00 &&
            StuntCompleted(stuntId) &&
            NoCheats()
        )
    )
}

StuntCompletedAch("Lowrider High Bounce", dword(0x3fc218))
StuntCompletedAch("Lowrider Standing Tall", dword(0x3fc21c))
StuntCompletedAch("H2 Hummer", dword(0x3fc220))
StuntCompletedAch("59 Chevrolet Impala", dword(0x3fc224))
StuntCompletedAch("Oldsmobile Cutlass Supreme", dword(0x3fc228))
StuntCompletedAch("Cadillac Eldorado", dword(0x3fc22c))
StuntCompletedAch("Cadillac Escalade", dword(0x3fc230))
StuntCompletedAch("Midway Concept 6", dword(0x3fc268))
StuntCompletedAch("Midway Concept 7", dword(0x3fc26c))
StuntCompletedAch("Midway Concept 8", dword(0x3fc270))
StuntCompletedAch("Midway Concept 9", dword(0x3fc274))
StuntCompletedAch("Midway Concept 10", dword(0x3fc278))
StuntCompletedAch("Midway Concept 11", dword(0x3fc234))
StuntCompletedAch("Midway Concept 12", dword(0x3fc238))
StuntCompletedAch("Midway Concept 13", dword(0x3fc23c))
StuntCompletedAch("Midway Concept 14", dword(0x3fc240))
StuntCompletedAch("Midway Concept 15", dword(0x3fc244))
StuntCompletedAch("Midway Concept 16", dword(0x3fc248))
StuntCompletedAch("Midway Concept 17", dword(0x3fc24c))
StuntCompletedAch("Midway Concept 18", dword(0x3fc250))
StuntCompletedAch("Midway Concept 19", dword(0x3fc254))
StuntCompletedAch("Midway Concept 20", dword(0x3fc258))
StuntCompletedAch("Money 1", dword(0x3fc25c))
StuntCompletedAch("Money 2", dword(0x3fc260))
StuntCompletedAch("Money 3", dword(0x3fc264))


// ===================================
// MISC
// ===================================

achievement(
    title = "Chaos Mode Activated",
    description = "Enable the fast cars cheat by pausing the game and entering Up, Down, Left, Right, Square, Right, Circle, Left",
    points = 1,
    trigger = (
        CurrentRace == 0x00 &&
        byte(0x0037b2a4) == 0x01 &&
        prev(byte(0x0037b2a4)) == 0x00
    )
)

achievement(
    title = "No Boosts Needed",
    description = "Win a race on normal difficulty or higher ",
    points = 5,
    trigger = (
        once(IngameTimer <= 1.00 && IngameTimer != 0.00) &&
        never(NitroBoosts < prev(NitroBoosts) || IngameTimer == 0.00 || CurrentRace == 0x00) &&
        RaceComplete() && 
        RacePosition == 0x01 &&
        NoCheats() &&
        GameDiff >= 0x01
    )
)

achievement(
    title = "Sound of the Police",
    description = "Reach 5 stars police in freeroam",
    points = 2,
    trigger = (
        CurrentRace == 0x00 &&
        byte(0x00370fa8) == 0x02 &&
        PoliceStars >= 0x05 &&
        prev(PoliceStars) <= 0x04
    )
)

// ===================================
// LEADERBOARDS
// ===================================
function RaceLeaderboard(raceName, raceId)
{
    leaderboard(
        title = raceName,
        description = "Get the fastest time on race " + raceName,
        start = (
            CurrentRace == raceId &&
            IngameTimer != 0.0 &&
            prev(IngameTimer) == 0.00
        ),
        cancel = (
            IngameTimer == 0.0 &&
            CurrentRace != 0x00
        ),
        submit = (
            RaceTimer != -1.0 &&
            RaceComplete()
        ),
        value = (RaceTimer),
        format = "SECS",
        lower_is_better = true
    )
}

for key in RaceDict {
RaceLeaderboard(RaceDict[key], key)
}