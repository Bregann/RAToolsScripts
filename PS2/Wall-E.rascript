// Wall-E
// #ID = 20617
// first script, decided mid way through to try out rascript so had some ids and badges in the progression as they were in unoffical

//Misc bits
Timer = float(0x00b891d0)
PlaygroundBoxesDestroyed= byte(dword(0x00a33b24) + 0xFFFFD550)
CurrentScreen = byte(0x01ff85dc)
PuzzleAmountSolved = byte(dword(0x01fff910) + 0x3C0)
BonusPoints = dword(0x00a1d9a0)
GamePaused = byte(0x008e7780)

// Chapter data
ChapterId = word(0xA1DC40)
MusicId = byte(0x00a1dc3d)

ChapterNames = [
"BnL Tune-Up",
"Sandstorm Sprint",
"Home Sweet Home",
"Work Day",
"Hidden Treasure",
"Truck Sweet Truck",
"Shipyard",
"Tanker Playground",
"Taking Flight",
"Surprise Departure",
"Stowaway to Space",
"Eve Pursuit",
"Clean Getaway",
"Life on the Axiom",
"Robot Rescue",
"Repair-Ward Playground",
"Human Highway",
"Pod Blaster",
"Cosmic Speedway",
"Rogue Robots",
"Trash Shoot",
"Fixing Eve",
"Holo-Detector Dash",
"A Robot's Last Stand",
"Home Coming",
"Epilogue",
"Lido-Deck Dash"
]

BnlTuneUp = 0xD001
SandstormSprint = 0xD101
HomeSweetHome = 0xD201
WorkDay = 0xD301
HiddenTreasure = 0xD401
TruckSweetTruck = 0xD501
Shipyard = 0xD601
TankerPlayground = 0xD701
TakingFlight = 0xD801
SurpriseDeparture = 0xD901
StowawayToSpace = 0xDA01
EvePursuit = 0xDB01
CleanGetaway = 0xDC01
LifeOnTheAxiom = 0xDD01
RobotRescue = 0xDE01
RepairWardPlayground = 0xDF01
HumanHighway = 0xE001
PodBlaster = 0xE101
CosmicSpeedway = 0xE201
RogueRobots = 0xE301
TrashShoot = 0xE401
FixingEve = 0xE501
HoloDetectorDash = 0xE601
ARobotsLastStand = 0xE701
HomeComing = 0xE801
Epilogue = 0xE901
LidoDeckDash = 0xEA01

//Chapter complete flags
//0x00 = false
//0x01 = true

BnlTuneUpChapterCompleted = byte(0xB9DFD9)
SandstormSprintChapterCompleted = byte(0xB9E441)
HomeSweetHomeChapterCompleted = byte(0xBA1561)
WorkDayChapterCompleted = byte(0xB9E729)
HiddenTreasureChapterCompleted = byte(0xBA0299)
TruckSweetTruckChapterCompleted = byte(0xBA1619)
ShipyardChapterCompleted = byte(0xBA2D21)
TankerPlaygroundChapterCompleted = byte(0xBA9389)
TakingFlightChapterCompleted = byte(0xBAA8E9)
SurpriseDepartureChapterCompleted = byte(0xBA0871)
StowawayToSpaceChapterCompleted = byte(0xBA0C21)
EvePursuitChapterCompleted = byte(0xBA1079)
CleanGetawayChapterCompleted = byte(0xBA32F1)
LifeOnTheAxiomChapterCompleted = byte(0xBA6071)
RobotRescueChapterCompleted = byte(0xBA76C1)
RepairWardPlaygroundChapterCompleted = byte(0xBA5971)
HumanHighwayChapterCompleted = byte(0xBA3819)
PodBlasterChapterCompleted = byte(0xBA43A9)
CosmicSpeedwayChapterCompleted = byte(0xBA9729)
RogueRobotsChapterCompleted = byte(0xBA3471)
TrashShootChapterCompleted = byte(0xBA5671)
FixingEveChapterCompleted = byte(0xBA45E1)
HoloDetectorDashChapterCompleted = byte(0xBABB29)
ARobotsLastStandChapterCompleted = byte(0xBA57f1)
HomeComingChapterCompleted = byte(0xBA5E91)
EpilogueChapterCompleted = byte(0xBA1E01)
LidoDeckDashChapterCompleted = byte(0xBAC1B1)

//All crates destroyed
//0x00 = false
//0x01 = true

WorkDayAllBnlCratesDestroyed = byte(0xB9EC31)
HiddenTreasureAllBnlCratesDestroyed = byte(0xB9FC21)
SandstormSprintAllBnlCratesDestroyed = byte(0xB9E5B1)
SurpriseDepartureAllBnlCratesDestroyed = byte(0xBA09E1)
StowawayToSpaceAllBnlCratesDestroyed = byte(0xBA0CD9)
EvePursuitAllBnlCratesDestroyed = byte(0xBA1411)
HomeSweetHomeAllBnlCratesDestroyed = byte(0xBA16D1)
ShipyardAllBnlCratesDestroyed = byte(0xBA2DD9)
CleanGetawayAllBnlCratesDestroyed = byte(0xBA33A9)
RogueRobotsAllBnlCratesDestroyed = byte(0xBA3529)
HumanHighwayAllBnlCratesDestroyed = byte(0xBA4001)
FixingEveAllBnlCratesDestroyed = byte(0xBA4FF1)
TrashShootAllBnlCratesDestroyed = byte(0xBA5729)
ARobotSLastStandAllBnlCratesDestroyed = byte(0xBA58A9)
HomeComingAllBnlCratesDestroyed = byte(0xBA5F49)
LifeOnTheAxiomAllBnlCratesDestroyed = byte(0xBA61E1)
RobotRescueAllBnlCratesDestroyed = byte(0xBA8E79)
CosmicSpeedwayAllBnlCratesDestroyed = byte(0xBA9A09)
TakingFlightAllBnlCratesDestroyed = byte(0xBAA9A1)
HoloDetectorDashAllBnlCratesDestroyed = byte(0xBABD51)
LidoDeckDashAllBnlCratesDestroyed = byte(0xBAC269)

//Artifacts
//0x00 = false
//0x01 = true

BinocularsArtifactFound = byte(0x00a1d95f)
DollArtifactFound = byte(0x00a1d960)
FireworkArtifactFound = byte(0x00a1d961)
RingArtifactFound = byte(0x00a1d962)
PaintTubeArtifactFound = byte(0x00a1d963)
PlungerArtifactFound = byte(0x00a1d964)
MegaphoneArtifactFound = byte(0x00a1d965)
UmbrellaArtifactFound = byte(0x00a1d966)
TrafficConeArtifactFound = byte(0x00a1d967)
TelescopeArtifactFound = byte(0x00a1d968)
SpatulaArtifactFound = byte(0x00a1d969)
BoomerangArtifactFound = byte(0x00a1d96a)
HammerArtifactFound = byte(0x00a1d96b)
RubberDuckArtifactFound = byte(0x00a1d96c)
ToyDogArtifactFound = byte(0x00a1d96d)
DroopingEyesArtifactFound = byte(0x00a1d96e)
RexArtifactFound = byte(0x00a1d96f)
AccordionArtifactFound = byte(0x00a1d970)
PaddleBallArtifactFound = byte(0x00a1d971)
BeachBallArtifactFound = byte(0x00a1d972)
SkiGogglesArtifactFound = byte(0x00a1d973)

//Unlocked cheats
CheatIntergalacticUnlocked = byte(0x00bad445)
CheatSoapbubblesUnlocked = byte(0x00bad505)
CheatRatjukeboxUnlocked = byte(0x00bad575)
CheatIncrejukeboxUnlocked = byte(0x00bad5e5)
CheatBagpackUnlocked = byte(0x00bb4935)
CheatSkateboarderUnlocked = byte(0x00bb49a5)
CheatHeavyweaponUnlocked = byte(0x00bb4a15)

//Total unlocked extra materials
TotalUnlockedMats = 
byte(0x00bac5f5) + byte(0x00bac665) + byte(0x00bac6d5) + byte(0x00bac755) + byte(0x00bac7c5) +
byte(0x00bac835) + byte(0x00bac8a5) + byte(0x00bac915) + byte(0x00bac985) + byte(0x00bac9f5) +
byte(0x00baca65) + byte(0x00bacb05) + byte(0x00bacb75) + byte(0x00bacbe5) + byte(0x00bacc55) +
byte(0x00baccc5) + byte(0x00bacd35) + byte(0x00bacda5) + byte(0x00bace15) + byte(0x00baced5) +
byte(0x00bacf45) + byte(0x00bacfb5) + byte(0x00bb4f35) + byte(0x00bb8a65) + byte(0x00bb8ad5) +
byte(0x00bb8b45) + byte(0x00bb8bb5) + byte(0x00bb8c25) + byte(0x00bb8c95) + byte(0x00bb8d05) +
byte(0x00bb8d75) + byte(0x00bb8de5) + byte(0x00bb8e55) + byte(0x00bb8ec5) + byte(0x00bb8f35) +
byte(0x00bb8fa5) + byte(0x00bb9115) + byte(0x00bb9185) + byte(0x00bb91f5) + byte(0x00bb9265)

// Cheat protection
CheatActivatedIntergalactic = byte(0xBAD4A0)
CheatActivatedSoapbubbles = byte(0xBAD560)
CheatActivatedRatjukebox = byte(0xBAD5D0)
CheatActivatedIncrejukebox = byte(0xBAD640)
CheatActivatedBagpack = byte(0xBB4990)
CheatActivatedSkateboarder = byte(0xBB4A00)
CheatActivatedHeavyweapon = byte(0xBB4A70)
CheatActivatedBotofwarSecretCode1 = byte(0xBB4AE0)
CheatActivatedStealtharmorSecretCode2 = byte(0xBB4B50)
CheatActivatedRainbowlaserSecretCode3 = byte(0xBB4C10)
CheatActivatedExplosiveworldSecretCode4 = byte(0xBB4C80)
CheatActivatedGlowinthedarkSecretCode5 = byte(0xBB4CF0)
CheatActivatedBotofmysterySecretCode6 = byte(0xBB4D60)
CheatActivatedGoldentracksSecretCode7 = byte(0xBB4DD0)

function NoCheatsEnabled() => 
CheatActivatedIntergalactic == 0 && 
CheatActivatedSoapbubbles == 0 &&
CheatActivatedRatjukebox == 0 && 
CheatActivatedIncrejukebox == 0 && 
CheatActivatedBagpack == 0 && 
CheatActivatedSkateboarder== 0 && 
CheatActivatedHeavyweapon == 0 && 
CheatActivatedBotofwarSecretCode1 == 0 && 
CheatActivatedStealtharmorSecretCode2 == 0 && 
CheatActivatedRainbowlaserSecretCode3 == 0 && 
CheatActivatedExplosiveworldSecretCode4 == 0 && 
CheatActivatedGlowinthedarkSecretCode5 == 0 && 
CheatActivatedBotofmysterySecretCode6 == 0 && 
CheatActivatedGoldentracksSecretCode7 == 0

// ===================================
// PROGRESSION ACHIEVEMENTS
// ===================================

function LevelCompleted(achId, achBadge, levelName, levelId, levelCompleteFlag)
{
    achievement(
        id = achId,
        badge = achBadge,
        title = levelName,
        description = "Complete level " + levelName + " with no cheats enabled",
        points = 5,
        trigger = (
            ChapterId == levelId &&
            levelCompleteFlag == 1 &&
            prev(levelCompleteFlag) == 0 &&
            NoCheatsEnabled()
    	)
    )
}

LevelCompleted(306346,"339150",ChapterNames[0],BnlTuneUp,BnlTuneUpChapterCompleted)
LevelCompleted(306347,"339151",ChapterNames[1],SandstormSprint,SandstormSprintChapterCompleted)
LevelCompleted(306349,"339153",ChapterNames[2],HomeSweetHome,HomeSweetHomeChapterCompleted)
LevelCompleted(306351,"339155",ChapterNames[3],WorkDay,WorkDayChapterCompleted)
LevelCompleted(306353,"339157",ChapterNames[4],HiddenTreasure,HiddenTreasureChapterCompleted)
LevelCompleted(306355,"339159",ChapterNames[5],TruckSweetTruck,TruckSweetTruckChapterCompleted)
LevelCompleted(306356,"339160",ChapterNames[6],Shipyard,ShipyardChapterCompleted)
LevelCompleted(306358,"339162",ChapterNames[7],TankerPlayground,TankerPlaygroundChapterCompleted)
LevelCompleted(306359,"339163",ChapterNames[8],TakingFlight,TakingFlightChapterCompleted)
LevelCompleted(306361,"339165",ChapterNames[9],SurpriseDeparture,SurpriseDepartureChapterCompleted)
LevelCompleted(306363,"339167",ChapterNames[10],StowawayToSpace,StowawayToSpaceChapterCompleted)
LevelCompleted(306365,"339169",ChapterNames[11],EvePursuit,EvePursuitChapterCompleted)
LevelCompleted(306367,"339171",ChapterNames[12],CleanGetaway,CleanGetawayChapterCompleted)
LevelCompleted(306369,"339173",ChapterNames[13],LifeOnTheAxiom,LifeOnTheAxiomChapterCompleted)
LevelCompleted(306371,"339175",ChapterNames[14],RobotRescue,RobotRescueChapterCompleted)
LevelCompleted(306373,"339177",ChapterNames[15],RepairWardPlayground,RepairWardPlaygroundChapterCompleted)
LevelCompleted(306374,"339178",ChapterNames[16],HumanHighway,HumanHighwayChapterCompleted)
LevelCompleted(306376,"339180",ChapterNames[17],PodBlaster,PodBlasterChapterCompleted)
LevelCompleted(306377,"339181",ChapterNames[18],CosmicSpeedway,CosmicSpeedwayChapterCompleted)
LevelCompleted(306379,"339183",ChapterNames[19],RogueRobots,RogueRobotsChapterCompleted)
LevelCompleted(306381,"339185",ChapterNames[20],TrashShoot,TrashShootChapterCompleted)
LevelCompleted(306383,"339187",ChapterNames[21],FixingEve,FixingEveChapterCompleted)
LevelCompleted(306385,"339189",ChapterNames[22],HoloDetectorDash,HoloDetectorDashChapterCompleted)
LevelCompleted(306387,"339191",ChapterNames[23],ARobotsLastStand,ARobotsLastStandChapterCompleted)
LevelCompleted(306389,"339193",ChapterNames[24],HomeComing,HomeComingChapterCompleted)
LevelCompleted(306391,"339195",ChapterNames[25],Epilogue,EpilogueChapterCompleted)
LevelCompleted(306392,"339196",ChapterNames[26],LidoDeckDash,LidoDeckDashChapterCompleted)

// ===================================
// CRATE BROKEN ACHIEVEMENTS
// ===================================

function BoxesDestroyed(achId, achBadge, levelName, levelId, boxDestroyedFlag)
{
    achievement(
        id = achId,
        badge = achBadge,
        title = levelName + " Box Destroyer",
        description = "Destroy all the boxes in " + levelName,
        points = 5,
        trigger = (
            ChapterId == levelId &&
            boxDestroyedFlag == 1 &&
            prev(boxDestroyedFlag) == 0 &&
            NoCheatsEnabled()
        )
    )
}

BoxesDestroyed(306348,"339152",ChapterNames[1],SandstormSprint,SandstormSprintAllBnlCratesDestroyed)
BoxesDestroyed(306350,"339154",ChapterNames[2],HomeSweetHome,HomeSweetHomeAllBnlCratesDestroyed)
BoxesDestroyed(306352,"339156",ChapterNames[3],WorkDay,WorkDayAllBnlCratesDestroyed)
BoxesDestroyed(306354,"339158",ChapterNames[4],HiddenTreasure,HiddenTreasureAllBnlCratesDestroyed)
BoxesDestroyed(306357,"339161",ChapterNames[6],Shipyard,ShipyardAllBnlCratesDestroyed)
BoxesDestroyed(306360,"339164",ChapterNames[8],TakingFlight,TakingFlightAllBnlCratesDestroyed)
BoxesDestroyed(306362,"339166",ChapterNames[9],SurpriseDeparture,SurpriseDepartureAllBnlCratesDestroyed)
BoxesDestroyed(306364,"339168",ChapterNames[10],StowawayToSpace,StowawayToSpaceAllBnlCratesDestroyed)
BoxesDestroyed(306366,"339170",ChapterNames[11],EvePursuit,EvePursuitAllBnlCratesDestroyed)
BoxesDestroyed(306368,"339172",ChapterNames[12],CleanGetaway,CleanGetawayAllBnlCratesDestroyed)
BoxesDestroyed(306370,"339174",ChapterNames[13],LifeOnTheAxiom,LifeOnTheAxiomAllBnlCratesDestroyed)
BoxesDestroyed(306372,"339176",ChapterNames[14],RobotRescue,RobotRescueAllBnlCratesDestroyed)
BoxesDestroyed(306375,"339179",ChapterNames[16],HumanHighway,HumanHighwayAllBnlCratesDestroyed)
BoxesDestroyed(306378,"339182",ChapterNames[18],CosmicSpeedway,CosmicSpeedwayAllBnlCratesDestroyed)
BoxesDestroyed(306380,"339184",ChapterNames[19],RogueRobots,RogueRobotsAllBnlCratesDestroyed)
BoxesDestroyed(306382,"339186",ChapterNames[20],TrashShoot,TrashShootAllBnlCratesDestroyed)
BoxesDestroyed(306384,"339188",ChapterNames[21],FixingEve,FixingEveAllBnlCratesDestroyed)
BoxesDestroyed(306386,"339190",ChapterNames[22],HoloDetectorDash,HoloDetectorDashAllBnlCratesDestroyed)
BoxesDestroyed(306388,"339192",ChapterNames[23],ARobotsLastStand,ARobotSLastStandAllBnlCratesDestroyed)
BoxesDestroyed(306390,"339194",ChapterNames[24],HomeComing,HomeComingAllBnlCratesDestroyed)
BoxesDestroyed(306393,"339197",ChapterNames[26],LidoDeckDash,LidoDeckDashAllBnlCratesDestroyed)

// ===================================
// HIDDEN ARTIFACT ACHIEVEMENTS
// ===================================
function ArtifactFound(achTitle, achDesc, artifactFlag, levelId)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = 3,
        trigger = (
            ChapterId == levelId &&
            artifactFlag == 1 &&
            prev(artifactFlag) == 0 &&
            NoCheatsEnabled()
        )
    )
}

ArtifactFound("What's That over There?", "Unlock the binoculars artifact", BinocularsArtifactFound, HomeSweetHome)
ArtifactFound("Can You Hear Me?", "Unlock the megaphone artifact", MegaphoneArtifactFound, WorkDay)
ArtifactFound("Dancing in the Rain", "Unlock the umbrella artifact", UmbrellaArtifactFound, WorkDay)
ArtifactFound("Budget Dalek Cosplay", "Unlock the plunger artifact", PlungerArtifactFound, WorkDay)
ArtifactFound("Looking out to the Stars", "Unlock the telescope artifact", TelescopeArtifactFound, HiddenTreasure)
ArtifactFound("The Bug Killer", "Unlock the fly swatter artifact", SpatulaArtifactFound, HiddenTreasure)
ArtifactFound("A Perfect Hat for a Statue", "Unlock the traffic cone artifact", TrafficConeArtifactFound, HiddenTreasure)
ArtifactFound("Flying Right Back", "Unlock the boomerang artifact", BoomerangArtifactFound, HiddenTreasure)
ArtifactFound("WALL-E Play Time", "Unlock the doll artifact", DollArtifactFound, Shipyard)
ArtifactFound("Ooh Pretty", "Unlock the flare artifact", FireworkArtifactFound, Shipyard)
ArtifactFound("If You like It Put a Ring on It", "Unlock the ring artifact", RingArtifactFound, Shipyard)
ArtifactFound("A Budding Artist", "Unlock the paint artifact", PaintTubeArtifactFound, Shipyard)
ArtifactFound("Hammer Time!", "Unlock the hammer artifiact", HammerArtifactFound, LifeOnTheAxiom)
ArtifactFound("Woof Woof", "Unlock the dog artifact", ToyDogArtifactFound, RobotRescue)
ArtifactFound("Abosolutely Quackers", "Unlock the rubber duck artifact", RubberDuckArtifactFound, RobotRescue)
ArtifactFound("Eye Can See You", "Unlock the drooping eyes artifact", DroopingEyesArtifactFound, HumanHighway)
ArtifactFound("RAWRRRRR", "Unlock the rex artificat", RexArtifactFound, HumanHighway)
ArtifactFound("Ping Pong", "Unlock the paddle ball artifact", PaddleBallArtifactFound, FixingEve)
ArtifactFound("Play Us a Song You're the Acordion Man", "Unlock the acordion artifact", AccordionArtifactFound, FixingEve)
ArtifactFound("It's Time to Ski", "Unlock the ski goggles artifact", SkiGogglesArtifactFound, HoloDetectorDash)
ArtifactFound("Beachball Anyone?", "Unlock the beach ball artifact", BeachBallArtifactFound, HoloDetectorDash)

// ===================================
// CHEAT UNLOCK ACHIEVEMENTS
// ===================================

function CheatUnlocked(achTitle, achDesc, cheat)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = 3,
        trigger = (
            BonusPoints < prev(BonusPoints) &&
            cheat == 0x00 &&
            prev(cheat) == 0x01
        )
    )
}

CheatUnlocked("Out of This World", "Unlock the intergalatic cheat", CheatIntergalacticUnlocked)
CheatUnlocked("A Soapy Unlock", "Unlock the soapbubbles cheat", CheatSoapbubblesUnlocked)
CheatUnlocked("Little Chef", "Unlock the ratjukebox cheat", CheatRatjukeboxUnlocked)
CheatUnlocked("An Incredible Song", "Unlock the increjukebox cheat", CheatIncrejukeboxUnlocked)
CheatUnlocked("The Claw", "Unlock the bagpack cheat", CheatBagpackUnlocked)
CheatUnlocked("Basically Tony Hawk", "Unlock the skateboarder cheat", CheatSkateboarderUnlocked)
CheatUnlocked("Fully Charged Laser", "Unlock the heavyweapon cheat", CheatHeavyweaponUnlocked)


// ===================================
// EXTRA MATERIAL UNLOCK ACHIEVEMENTS
// ===================================

function ExtraMatUnlocked(achTitle, achDesc, points, amount, prevAmount){
    achievement(
    title = achTitle,
    description = achDesc,
    points = points,
    trigger = (
        BonusPoints < prev(BonusPoints) &&
        TotalUnlockedMats == amount &&
        prev(TotalUnlockedMats) == prevAmount
        )
    )
}

ExtraMatUnlocked("Image Enthusiast", "Unlock half of the extra materials", 10, 0x14, 0x15)
ExtraMatUnlocked("Art Connoisseur", "Unlock all of the extra matertials", 25, 0x00, 0x01)

// ===================================
// SPEEDRUN ACHIEVEMENTS
// ===================================

function PlaygroundSpeedrun(achTitle, achDesc, levelId, timerSecs)
{
    achievement(
    title = achTitle,
    description = achDesc,
    points = 10,
    trigger = (
        ChapterId == levelId &&
        prev(Timer) >= timerSecs &&
        PlaygroundBoxesDestroyed == 0x0a &&
        prior(PlaygroundBoxesDestroyed) == 0x09
        )
    )
}

PlaygroundSpeedrun("Tanker Playground Speedrunner", "Beat the Tanker Playground box destroying challenge with 60 seconds or more on the clock", TankerPlayground, 60.0)
PlaygroundSpeedrun("Repair-Ward Playground Speedrunner", "Beat the Repair-Ward Playground box destroying challenge with 45 seconds or more on the clock", RepairWardPlayground, 45.0)

function PuzzleSpeedrun(achTitle, achDesc, musicId, timerSecs, timerFloat)
{
    achievement(
    title = achTitle,
    description = achDesc,
    points = 10,
    trigger = (
        timerFloat < timerSecs &&
        timerFloat > 0.0 &&
        (prev(timerFloat) < 0.0 || prev(timerFloat) > timerSecs) &&
        MusicId == musicId
        )
    )
}

PuzzleSpeedrun("Pattern Puzzle Speedrunner", "Complete the pattern puzzle in championship mode in under 24 seconds", 0xB7, 24.0, float(0x00b9e330))
PuzzleSpeedrun("Switch Puzzle Speedrunner", "Complete the switch puzzle in championship mode in under 10 seconds", 0xB9, 10.0, float(0x00b9f9a0))
PuzzleSpeedrun("Memory Puzzle Speedrunner", "Complete the memory puzzle in championship mode in under 19 seconds", 0xBB, 19.0, float(0x00ba0b10))
PuzzleSpeedrun("Colour Match Puzzle Speedrunner", "Complete the colour match puzzle in championship mode in under 17 seconds", 0xBD, 17.0, float(0x00ba0760))

// ===================================
// PUZZLE LEADERBOARDS
// ===================================
function PuzzleLb(lbTitle, lbDesc, musicId, floatTimer)
{
    leaderboard(
        title = lbTitle,
        description = lbDesc,
        start = (
            MusicId == musicId &&
            ChapterId == 0x00 &&
            GamePaused == 0x00
        ),
        cancel = (
            MusicId != musicId &&
            ChapterId == 0x00
        ),
        submit = (
            MusicId == musicId &&
            GamePaused == 0x01 &&
            floatTimer > 0.0
        ),
        value = (floatTimer),
        format = "SECS",
        lower_is_better = true
    )
}

PuzzleLb("Pattern Puzzle", "Get the lowest time on the pattern puzzle in championship mode", 0xB7, float(0x00b9e330))
PuzzleLb("Switch Puzzle ", "Get the lowest time on the switch puzzle in championship mode", 0xB9, float(0x00b9f9a0))
PuzzleLb("Memory Puzzle", "Get the lowest time on the memory puzzle in championship mode", 0xBB, float(0x00ba0b10))
PuzzleLb("Colour Match Puzzle ", "Get the lowest time on the colour match puzzle in championship mode", 0xBD, float(0x00ba0760))