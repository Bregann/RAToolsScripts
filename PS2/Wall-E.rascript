// Wall-E
// #ID = 20617
// first script, decided mid way through to try out rascript so had some ids and badges in the progression as they were in unoffical

//Misc bits

Timer = float(dword(dword(dword(dword(0x006e4384) + 0xA8) + 0x00) + 0x278) + 0xA0)


PlaygroundBoxesDestroyed= byte(dword(0x00a33b24) + 0xFFFFD550)
CurrentScreen = byte(0x01ff85dc)
PuzzleAmountSolved = byte(dword(0x01fff910) + 0x3C0)
BonusPoints = dword(0x00a1d9a0)
GamePaused = byte(0x008e7780)
BasePointer = dword(0x8b8600)

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

BnlTuneUpChapterCompleted = byte(BasePointer + 0xFFFFFB99)
SandstormSprintChapterCompleted = byte(BasePointer + 0x01)
HomeSweetHomeChapterCompleted = byte(BasePointer + 0x3121)
WorkDayChapterCompleted = byte(BasePointer + 0x02E9)
HiddenTreasureChapterCompleted = byte(BasePointer + 0x1E59)
TruckSweetTruckChapterCompleted = byte(BasePointer + 0x31D9)
ShipyardChapterCompleted = byte(BasePointer + 0x48E1)
TankerPlaygroundChapterCompleted = byte(BasePointer + 0xAE91)
TakingFlightChapterCompleted = byte(BasePointer + 0xC4A9)
SurpriseDepartureChapterCompleted = byte(BasePointer + 0x2431)
StowawayToSpaceChapterCompleted = byte(BasePointer + 0x27E1)
EvePursuitChapterCompleted = byte(BasePointer + 0x2C39)
CleanGetawayChapterCompleted = byte(BasePointer + 0x4EB1)
LifeOnTheAxiomChapterCompleted = byte(BasePointer + 0x7C31)
RobotRescueChapterCompleted = byte(BasePointer + 0x9281)
RepairWardPlaygroundChapterCompleted = byte(BasePointer + 0x7531)
HumanHighwayChapterCompleted = byte(BasePointer + 0x53D9)
PodBlasterChapterCompleted = byte(BasePointer + 0x5F69)
CosmicSpeedwayChapterCompleted = byte(BasePointer + 0xB2E9)
RogueRobotsChapterCompleted = byte(BasePointer + 0x5031)
TrashShootChapterCompleted = byte(BasePointer + 0x7231)
FixingEveChapterCompleted = byte(BasePointer + 0x61A1)
HoloDetectorDashChapterCompleted = byte(BasePointer + 0xD6E9)
ARobotsLastStandChapterCompleted = byte(BasePointer + 0x73B1)
HomeComingChapterCompleted = byte(BasePointer + 0x7A51)
EpilogueChapterCompleted = byte(BasePointer + 0x39C1)
LidoDeckDashChapterCompleted = byte(BasePointer + 0xDD71)

//All crates destroyed
//0x00 = false
//0x01 = true

WorkDayAllBnlCratesDestroyed = byte(BasePointer + 0x07F1)
HiddenTreasureAllBnlCratesDestroyed = byte(BasePointer + 0x17E1)
SandstormSprintAllBnlCratesDestroyed = byte(BasePointer + 0x0171)
SurpriseDepartureAllBnlCratesDestroyed = byte(BasePointer + 0x25A1)
StowawayToSpaceAllBnlCratesDestroyed = byte(BasePointer + 0x2899)
EvePursuitAllBnlCratesDestroyed = byte(BasePointer + 0x2FD1)
HomeSweetHomeAllBnlCratesDestroyed = byte(BasePointer + 0x3291)
ShipyardAllBnlCratesDestroyed = byte(BasePointer + 0x4999)
CleanGetawayAllBnlCratesDestroyed = byte(BasePointer + 0x4F69)
RogueRobotsAllBnlCratesDestroyed = byte(BasePointer + 0x50E9)
HumanHighwayAllBnlCratesDestroyed = byte(BasePointer + 0x5BC1)
FixingEveAllBnlCratesDestroyed = byte(BasePointer + 0x6BB1)
TrashShootAllBnlCratesDestroyed = byte(BasePointer + 0x72E9)
ARobotSLastStandAllBnlCratesDestroyed = byte(BasePointer + 0x7469)
HomeComingAllBnlCratesDestroyed = byte(BasePointer + 0x7B09)
LifeOnTheAxiomAllBnlCratesDestroyed = byte(BasePointer + 0x7DA1)
RobotRescueAllBnlCratesDestroyed = byte(BasePointer + 0xAA39)
CosmicSpeedwayAllBnlCratesDestroyed = byte(BasePointer + 0xB5C9)
TakingFlightAllBnlCratesDestroyed = byte(BasePointer + 0xC561)
HoloDetectorDashAllBnlCratesDestroyed = byte(BasePointer + 0xD911)
LidoDeckDashAllBnlCratesDestroyed = byte(BasePointer + 0xDE29)

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
CheatIntergalacticUnlocked = byte(BasePointer + 0xf005)
CheatSoapbubblesUnlocked = byte(BasePointer + 0xf0c5)
CheatRatjukeboxUnlocked = byte(BasePointer + 0xf135)
CheatIncrejukeboxUnlocked = byte(BasePointer + 0xf1a5)
CheatBagpackUnlocked = byte(BasePointer + 0x164f5)
CheatSkateboarderUnlocked = byte(BasePointer + 0x16565)
CheatHeavyweaponUnlocked = byte(BasePointer + 0x165d5)

//Total unlocked extra materials
TotalUnlockedMats = 
byte(BasePointer + 0xe1b5) + byte(BasePointer + 0xe225) + byte(BasePointer + 0x16af5) + 
byte(BasePointer + 0xe315) + byte(BasePointer + 0xe385) + byte(BasePointer + 0xe3f5) + 
byte(BasePointer + 0xe465) + byte(BasePointer + 0xe4d5) + byte(BasePointer + 0xe545) + 
byte(BasePointer + 0xe5b5) + byte(BasePointer + 0xe295) + byte(BasePointer + 0xe6c5) + 
byte(BasePointer + 0xe735) + byte(BasePointer + 0xe7a5) + byte(BasePointer + 0xe815) + 
byte(BasePointer + 0xe885) + byte(BasePointer + 0xe8f5) + byte(BasePointer + 0xe965) + 
byte(BasePointer + 0xe625) + byte(BasePointer + 0xea95) + byte(BasePointer + 0xeb05) + 
byte(BasePointer + 0xeb75) + byte(BasePointer + 0x1a625) + byte(BasePointer + 0x1a695) + 
byte(BasePointer + 0x1a705) + byte(BasePointer + 0x1a775) + byte(BasePointer + 0xe9d5) + 
byte(BasePointer + 0x1a8c5) + byte(BasePointer + 0x1a935) + byte(BasePointer + 0x1a9a5) + 
byte(BasePointer + 0x1aa15) + byte(BasePointer + 0x1aa85) + byte(BasePointer + 0x1aaf5) + 
byte(BasePointer + 0x1ab65) + byte(BasePointer + 0x1a7e5) + byte(BasePointer + 0x1a855) + 
byte(BasePointer + 0x1acd5) + byte(BasePointer + 0x1ad45) + byte(BasePointer + 0x1adb5) + 
byte(BasePointer + 0x1ae25)

// Cheat protection
CheatActivatedIntergalactic = byte(BasePointer + 0xf060)
CheatActivatedSoapbubbles = byte(BasePointer + 0xf120)
CheatActivatedRatjukebox = byte(BasePointer + 0xf190)
CheatActivatedIncrejukebox = byte(BasePointer + 0xf200)
CheatActivatedBagpack = byte(BasePointer + 0x16550)
CheatActivatedSkateboarder = byte(BasePointer + 0x165c0)
CheatActivatedHeavyweapon = byte(BasePointer + 0x16630)
CheatActivatedBotofwarSecretCode1 = byte(BasePointer + 0x166a0)
CheatActivatedStealtharmorSecretCode2 = byte(BasePointer + 0x16710)
CheatActivatedRainbowlaserSecretCode3 = byte(BasePointer + 0x167d0)
CheatActivatedExplosiveworldSecretCode4 = byte(BasePointer + 0x16840)
CheatActivatedGlowinthedarkSecretCode5 = byte(BasePointer + 0x168b0)
CheatActivatedBotofmysterySecretCode6 = byte(BasePointer + 0x16920)
CheatActivatedGoldentracksSecretCode7 = byte(BasePointer + 0x16990)

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

function LevelCompleted(achId, achBadge, levelName, levelId, levelCompleteFlag, type)
{
    achievement(
        id = achId,
        badge = achBadge,
        title = levelName,
        description = "Complete level " + "\"" + levelName + "\"" + " with no cheats enabled",
        points = 5,
        type = type,
        trigger = (
            ChapterId == levelId &&
            levelCompleteFlag == 1 &&
            prev(levelCompleteFlag) == 0 &&
            NoCheatsEnabled()
    	)
    )
}

LevelCompleted(306346,"339150",ChapterNames[0],BnlTuneUp,BnlTuneUpChapterCompleted, "PROGRESSION")
LevelCompleted(306347,"339151",ChapterNames[1],SandstormSprint,SandstormSprintChapterCompleted, "PROGRESSION")
LevelCompleted(306349,"339153",ChapterNames[2],HomeSweetHome,HomeSweetHomeChapterCompleted, "PROGRESSION")
LevelCompleted(306351,"339155",ChapterNames[3],WorkDay,WorkDayChapterCompleted, "PROGRESSION")
LevelCompleted(306353,"339157",ChapterNames[4],HiddenTreasure,HiddenTreasureChapterCompleted, "PROGRESSION")
LevelCompleted(306355,"339159",ChapterNames[5],TruckSweetTruck,TruckSweetTruckChapterCompleted, "PROGRESSION")
LevelCompleted(306356,"339160",ChapterNames[6],Shipyard,ShipyardChapterCompleted, "PROGRESSION")
LevelCompleted(306358,"339162",ChapterNames[7],TankerPlayground,TankerPlaygroundChapterCompleted, "")
LevelCompleted(306359,"339163",ChapterNames[8],TakingFlight,TakingFlightChapterCompleted, "PROGRESSION")
LevelCompleted(306361,"339165",ChapterNames[9],SurpriseDeparture,SurpriseDepartureChapterCompleted, "PROGRESSION")
LevelCompleted(306363,"339167",ChapterNames[10],StowawayToSpace,StowawayToSpaceChapterCompleted, "PROGRESSION")
LevelCompleted(306365,"339169",ChapterNames[11],EvePursuit,EvePursuitChapterCompleted, "PROGRESSION")
LevelCompleted(306367,"339171",ChapterNames[12],CleanGetaway,CleanGetawayChapterCompleted, "PROGRESSION")
LevelCompleted(306369,"339173",ChapterNames[13],LifeOnTheAxiom,LifeOnTheAxiomChapterCompleted, "PROGRESSION")
LevelCompleted(306371,"339175",ChapterNames[14],RobotRescue,RobotRescueChapterCompleted, "PROGRESSION")
LevelCompleted(306373,"339177",ChapterNames[15],RepairWardPlayground,RepairWardPlaygroundChapterCompleted, "")
LevelCompleted(306374,"339178",ChapterNames[16],HumanHighway,HumanHighwayChapterCompleted, "PROGRESSION")
LevelCompleted(306376,"339180",ChapterNames[17],PodBlaster,PodBlasterChapterCompleted, "PROGRESSION")
LevelCompleted(306377,"339181",ChapterNames[18],CosmicSpeedway,CosmicSpeedwayChapterCompleted, "PROGRESSION")
LevelCompleted(306379,"339183",ChapterNames[19],RogueRobots,RogueRobotsChapterCompleted, "PROGRESSION")
LevelCompleted(306381,"339185",ChapterNames[20],TrashShoot,TrashShootChapterCompleted, "PROGRESSION")
LevelCompleted(306383,"339187",ChapterNames[21],FixingEve,FixingEveChapterCompleted, "PROGRESSION")
LevelCompleted(306385,"339189",ChapterNames[22],HoloDetectorDash,HoloDetectorDashChapterCompleted, "PROGRESSION")
LevelCompleted(306387,"339191",ChapterNames[23],ARobotsLastStand,ARobotsLastStandChapterCompleted, "PROGRESSION")
LevelCompleted(306389,"339193",ChapterNames[24],HomeComing,HomeComingChapterCompleted, "WIN_CONDITION")
LevelCompleted(306391,"339195",ChapterNames[25],Epilogue,EpilogueChapterCompleted, "")
LevelCompleted(306392,"339196",ChapterNames[26],LidoDeckDash,LidoDeckDashChapterCompleted, "")

// ===================================
// CRATE BROKEN ACHIEVEMENTS
// ===================================

function BoxesDestroyed(achId, achBadge, levelName, levelId, boxDestroyedFlag)
{
    achievement(
        id = achId,
        badge = achBadge,
        title = levelName + " Box Destroyer",
        description = "Destroy all the boxes in " + "\"" + levelName + "\"" + " with no cheats enabled",
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
ArtifactFound("RAWRRRRR", "Unlock the rex artifact", RexArtifactFound, HumanHighway)
ArtifactFound("Ping Pong", "Unlock the paddle ball artifact", PaddleBallArtifactFound, FixingEve)
ArtifactFound("Play Us a Song You're the Accordion Man", "Unlock the accordion artifact", AccordionArtifactFound, FixingEve)
ArtifactFound("It's Time to Ski", "Unlock the ski goggles artifact", SkiGogglesArtifactFound, HoloDetectorDash)
ArtifactFound("Beachball Anyone?", "Unlock the beach ball artifact", BeachBallArtifactFound, HoloDetectorDash)

// ===================================
// CHEAT UNLOCK ACHIEVEMENTS
// ===================================

function CheatUnlocked(achTitle, achDesc, cheat, cheatCost)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = 3,
        trigger = (
            BonusPoints == (prev(BonusPoints) - cheatCost) &&
            cheat == 0x00 &&
            prev(cheat) == 0x01
        )
    )
}

CheatUnlocked("Out of This World", "Unlock the intergalatic cheat", CheatIntergalacticUnlocked, 200)
CheatUnlocked("A Soapy Unlock", "Unlock the soapbubbles cheat", CheatSoapbubblesUnlocked, 200)
CheatUnlocked("Little Chef", "Unlock the ratjukebox cheat", CheatRatjukeboxUnlocked, 200)
CheatUnlocked("An Incredible Song", "Unlock the increjukebox cheat", CheatIncrejukeboxUnlocked, 200)
CheatUnlocked("The Claw", "Unlock the bagpack cheat", CheatBagpackUnlocked, 300)
CheatUnlocked("Basically Tony Hawk", "Unlock the skateboarder cheat", CheatSkateboarderUnlocked, 300)
CheatUnlocked("Fully Charged Laser", "Unlock the heavyweapon cheat", CheatHeavyweaponUnlocked, 800)


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
ExtraMatUnlocked("Art Connoisseur", "Unlock all of the extra materials", 25, 0x00, 0x01)

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

function PuzzleSpeedrun(achTitle, achDesc, musicId, timerSecs, timerFloat, timer2nd, timer3rd)
{
    achievement(
    title = achTitle,
    description = achDesc,
    points = 10,
    trigger = (
        MusicId == musicId &&
        (
          timerFloat < timerSecs &&
          timerFloat > 0.0 &&
          (prev(timerFloat) < 0.0 || prev(timerFloat) > timerSecs)
        ) ||
        (
          timer2nd < timerSecs &&
          timer2nd > 0.0 &&
          (prev(timer2nd) < 0.0 || prev(timer2nd) > timerSecs)
        )||
        (
          timer3rd < timerSecs &&
          timer3rd > 0.0 &&
          (prev(timer3rd) < 0.0 || prev(timer3rd) > timerSecs)
        )
      )
    )
}

PuzzleSpeedrun("Pattern Puzzle Speedrunner", "Complete the Pattern Puzzle in Championship Key Puzzle mode in under 24 seconds", 0xB7, 24.0, float(BasePointer + 0xfffffef0), float(BasePointer + 0xfffffef4), float(BasePointer + 0xfffffef8))
PuzzleSpeedrun("Switch Puzzle Speedrunner", "Complete the Switch Puzzle in Championship Key Puzzle mode in under 10 seconds", 0xB9, 10.0, float(BasePointer + 0x1560), float(BasePointer + 0x1564), float(BasePointer + 0x1568))
PuzzleSpeedrun("Memory Puzzle Speedrunner", "Complete the Memory Puzzle in Championship Key Puzzle mode in under 19 seconds", 0xBB, 19.0, float(BasePointer + 0x26D0), float(BasePointer + 0x26D4), float(BasePointer + 0x26D8))
PuzzleSpeedrun("Colour Match Puzzle Speedrunner", "Complete the Colour Match Puzzle in Championship Key Puzzle mode in under 17 seconds", 0xBD, 17.0, float(BasePointer + 0x2320), float(BasePointer + 0x2324), float(BasePointer + 0x2328))

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

PuzzleLb("Pattern Puzzle", "Get the lowest time on the pattern puzzle in championship mode", 0xB7, float(BasePointer + 0xfffffef0))
PuzzleLb("Switch Puzzle ", "Get the lowest time on the switch puzzle in championship mode", 0xB9, float(0x00b9f9a0))
PuzzleLb("Memory Puzzle", "Get the lowest time on the memory puzzle in championship mode", 0xBB, float(0x00ba0b10))
PuzzleLb("Colour Match Puzzle ", "Get the lowest time on the colour match puzzle in championship mode", 0xBD, float(0x00ba0760))
