// Wall-E
// #ID = 20617

// $A1DC40: [16bit] Chapter ID
//          0xD001=BnL Tune-Up
//          0xD101=Sandstorm Sprint
//          0xD201=Home Sweet Home
//          0xD301=Work Day
//          0xD401=Hidden Treasure
//          0xD501=Truck Sweet Truck
//          0xD601=Shipyard
//          0xD701=Tanker Playground
//          0xD801=Taking Flight
//          0xD901=Surprise Departure
//          0xDA01=Stowaway to Space
//          0xDB01=Eve Pursuit
//          0xDC01=Clean Getaway
//          0xDD01=Life on the Axiom
//          0xDE01=Robot Rescue
//          0xDF01=Repair-Ward Playground
//          0xE001=Human Highway
//          0xE101=Pod Blaster
//          0xE201=Cosmic Speedway
//          0xE301=Rogue Robots
//          0xE401=Trash Shoot
//          0xE501=Fixing Eve
//          0xE601=Holo-Detector Dash
//          0xE701=A Robot's Last Stand
//          0xE801=Home Coming
//          0xE901=Epilogue
//          0xEA01=Lido-Deck Dash
function ChapterId() => word(0xA1DC40)

// $B9DFD9: [8bit] BnL Tune-Up - Chapter Completed
//          0x00=False
//          0x01=True
function BnlTuneUpChapterCompleted() => byte(0xB9DFD9)

// $B9E441: [8bit] Sandstrom Sprint - Chapter Completed
//          0x00=False
//          0x01=True
function SandstromSprintChapterCompleted() => byte(0xB9E441)

// $B9E5B1: [8bit] Sandstorm Sprint - All BnL Crates Destroyed
//          0x00=False
//          0x01=True
function SandstormSprintAllBnlCratesDestroyed() => byte(0xB9E5B1)

// $B9E729: [8bit] Work Day - Chapter Completed
//          0x00=False
//          0x01=True
function WorkDayChapterCompleted() => byte(0xB9E729)

// $B9EC31: [8bit] Work Day - All BnL Crates Destroyed
//          0x00=False
//          0x01=True
function WorkDayAllBnlCratesDestroyed() => byte(0xB9EC31)

// $B9FC21: [8bit] Hidden Treasure - All BnL Crates Destroyed
//          0x00=False
//          0x01=True
function HiddenTreasureAllBnlCratesDestroyed() => byte(0xB9FC21)

// $BA0299: [8bit] Hidden Treasure - Chapter Completed
//          0x00=False
//          0x01=True
function HiddenTreasureChapterCompleted() => byte(0xBA0299)

// $BA0871: [8bit] Surprise Departure - Chapter Completed
//          0x00=False
//          0x01=True
function SurpriseDepartureChapterCompleted() => byte(0xBA0871)

// $BA09E1: [8bit] Surprise Departure - All BnL Crates Destroyed
//          0x00=False
//          0x01=True
function SurpriseDepartureAllBnlCratesDestroyed() => byte(0xBA09E1)

// $BA0C21: [8bit] Stowaway To Space - Chapter Completed
//          0x00=False
//          0x01=True
function StowawayToSpaceChapterCompleted() => byte(0xBA0C21)

// $BA0CD9: [8bit] Stowaway To Space - All BnL Crates Destroyed
//          0x00=False
//          0x01=True
function StowawayToSpaceAllBnlCratesDestroyed() => byte(0xBA0CD9)

// $BA1079: [8bit] Eve Pursuit - Chapter Completed
//          0x00=False
//          0x01=True
function EvePursuitChapterCompleted() => byte(0xBA1079)

// $BA1411: [8bit] Eve Pursuit - All BnL Crates Destroyed
//          0x00=False
//          0x01=True
function EvePursuitAllBnlCratesDestroyed() => byte(0xBA1411)

// $BA1561: [8bit] Home Sweet Home - Chapter Completed
//          0x00=False
//          0x01=True
function HomeSweetHomeChapterCompleted() => byte(0xBA1561)

// $BA1619: [8bit] Truck Sweet Truck - Chapter Completed
//          0x00=False
//          0x01=True
function TruckSweetTruckChapterCompleted() => byte(0xBA1619)

// $BA16D1: [8bit] Home Sweet Home - All BnL Crates Destroyed
//          0x00=False
//          0x01=True
function HomeSweetHomeAllBnlCratesDestroyed() => byte(0xBA16D1)

// $BA1E01: [8bit] Epilogue - Chapter Completed
//          0x00=False
//          0x01=True
function EpilogueChapterCompleted() => byte(0xBA1E01)

// $BA2D21: [8bit] Shipyard - Chapter Completed
//          0x00=False
//          0x01=True
function ShipyardChapterCompleted() => byte(0xBA2D21)

// $BA2DD9: [8bit] Shipyard - All BnL Crates Destroyed
//          0x00=False
//          0x01=True
function ShipyardAllBnlCratesDestroyed() => byte(0xBA2DD9)

// $BA32F1: [8bit] Clean Getaway - Chapter Completed
//          0x00=False
//          0x01=True
function CleanGetawayChapterCompleted() => byte(0xBA32F1)

// $BA33A9: [8bit] Clean Getaway - All BnL Crates Destroyed
//          0x00=False
//          0x01=True
function CleanGetawayAllBnlCratesDestroyed() => byte(0xBA33A9)

// $BA3471: [8bit] Rogue Robots  - Chapter Completed
//          0x00=False
//          0x01=True
function RogueRobotsChapterCompleted() => byte(0xBA3471)

// $BA3529: [8bit] Rogue Robots - All BnL Crates Destroyed
//          0x00=False
//          0x01=True
function RogueRobotsAllBnlCratesDestroyed() => byte(0xBA3529)

// $BA3819: [8bit] Human Highway - Chapter Completed
//          0x00=False
//          0x01=True
function HumanHighwayChapterCompleted() => byte(0xBA3819)

// $BA4001: [8bit] Human Highway - All BnL Crates Destroyed
//          0x00=False
//          0x01=True
function HumanHighwayAllBnlCratesDestroyed() => byte(0xBA4001)

// $BA43A9: [8bit] Pod Blaster - Chapter Completed
//          0x00=False
//          0x01=True
function PodBlasterChapterCompleted() => byte(0xBA43A9)

// $BA45E1: [8bit] Fixing Eve - Chapter Complete
//          0x00=False
//          0x01=True
function FixingEveChapterComplete() => byte(0xBA45E1)

// $BA4FF1: [8bit] Fixing Eve - All BnL Crates Destroyed
//          0x00=False
//          0x01=True
function FixingEveAllBnlCratesDestroyed() => byte(0xBA4FF1)

// $BA5671: [8bit] Trash Shoot - Chapter Completed
//          0x00=False
//          0x01=True
function TrashShootChapterCompleted() => byte(0xBA5671)

// $BA5729: [8bit] Trash Shoot - All BnL Crates Destroyed
//          0x00=False
//          0x01=True
function TrashShootAllBnlCratesDestroyed() => byte(0xBA5729)

// $BA57F0: [8bit] A Robot's Last Stand - Chapter Unlocked
//          0x00=False
//          0x01=True
function ARobotSLastStandChapterUnlocked() => byte(0xBA57F0)

// $BA58A9: [8bit] A Robot's Last Stand - All BnL Crates Destroyed
//          0x00=False
//          0x01=True
function ARobotSLastStandAllBnlCratesDestroyed() => byte(0xBA58A9)

// $BA5971: [8bit] Repair-Ward Playground - Chapter Completed
//          0x00=False
//          0x01=True
//          
//          0x00ba5a29 also has to be 0x01 (?)
function RepairWardPlaygroundChapterCompleted() => byte(0xBA5971)

// $BA5E91: [8bit] Home Coming - Chapter Completed
//          0x00=False
//          0x01=True
function HomeComingChapterCompleted() => byte(0xBA5E91)

// $BA5F49: [8bit] Home Coming - All BnL Crates Destroyed
//          0x00=False
//          0x01=True
function HomeComingAllBnlCratesDestroyed() => byte(0xBA5F49)

// $BA6071: [8bit] Life On The Axiom - Chapter Completed
//          0x00=False
//          0x01=True
function LifeOnTheAxiomChapterCompleted() => byte(0xBA6071)

// $BA61E1: [8bit] Life on the Axiom - All BnL Crates Destroyed
//          0x00=False
//          0x01=True
function LifeOnTheAxiomAllBnlCratesDestroyed() => byte(0xBA61E1)

// $BA76C1: [8bit] Robot Rescue - Chapter Completed
//          0x00=False
//          0x01=True
function RobotRescueChapterCompleted() => byte(0xBA76C1)

// $BA8E79: [8bit] Robot Rescue- All BnL Crates Destroyed
//          0x00=False
//          0x01=True
function RobotRescueAllBnlCratesDestroyed() => byte(0xBA8E79)

// $BA9389: [8bit] Tanker Playground - Chapter Completed
//          0x00=False
//          0x01=True
//          
//          also 0x00ba92d1 has to be 0x01
function TankerPlaygroundChapterCompleted() => byte(0xBA9389)

// $BA9729: [8bit] Cosmic Speedway - Chapter Completed
//          0x00=False
//          0x01=True
function CosmicSpeedwayChapterCompleted() => byte(0xBA9729)

// $BA9A09: [8bit] Cosmic Speedway - All BnL Crates Destroyed
//          0x00=False
//          0x01=True
function CosmicSpeedwayAllBnlCratesDestroyed() => byte(0xBA9A09)

// $BAA8E9: [8bit] Taking Flight - Chapter Completed
//          0x00=False
//          0x01=True
function TakingFlightChapterCompleted() => byte(0xBAA8E9)

// $BAA9A1: [8bit] Taking Flight - All BnL Crates Destroyed
//          0x00=False
//          0x01=True
function TakingFlightAllBnlCratesDestroyed() => byte(0xBAA9A1)

// $BABB29: [8bit] Holo-Detector Dash - Chapter Completed
//          0x00=False
//          0x01=True
function HoloDetectorDashChapterCompleted() => byte(0xBABB29)

// $BABD51: [8bit] Holo-Detector Dash - All BnL Crates Destroyed
//          0x00=False
//          0x01=True
function HoloDetectorDashAllBnlCratesDestroyed() => byte(0xBABD51)

// $BAC1B1: [8bit] Lido-Deck Dash - Chapter Completed
//          0x00=False
//          0x01=True
function LidoDeckDashChapterCompleted() => byte(0xBAC1B1)

// $BAC269: [8bit] Lido-Deck Dash - All BnL Crates Destroyed
//          0x00=False
//          0x01=True
function LidoDeckDashAllBnlCratesDestroyed() => byte(0xBAC269)

// $BAD4A0: [8bit] Cheat Activated - INTERGALACTIC
//          0x00=False
//          0x01=True
function CheatActivatedIntergalactic() => byte(0xBAD4A0)

// $BAD560: [8bit] Cheat Activated - SOAPBUBBLES
//          0x00=False
//          0x01=True
function CheatActivatedSoapbubbles() => byte(0xBAD560)

// $BAD5D0: [8bit] Cheat Activated - RATJUKEBOX
//          0x00=False
//          0x01=True
function CheatActivatedRatjukebox() => byte(0xBAD5D0)

// $BAD640: [8bit] Cheat Activated - INCREJUKEBOX
//          0x00=False
//          0x01=True
function CheatActivatedIncrejukebox() => byte(0xBAD640)

// $BB4990: [8bit] Cheat Activated - BAGPACK
//          0x00=False
//          0x01=True
function CheatActivatedBagpack() => byte(0xBB4990)

// $BB4A00: [8bit] Cheat Activated - SKATEBOARDER
//          0x00=False
//          0x01=True
function CheatActivatedSkateboarder() => byte(0xBB4A00)

// $BB4A70: [8bit] Cheat Activated - HEAVYWEAPON
//          0x00=False
//          0x01=True
function CheatActivatedHeavyweapon() => byte(0xBB4A70)

// $BB4AE0: [8bit] Cheat Activated - BOTOFWAR (Secret Code 1)
//          0x00=False
//          0x01=True
function CheatActivatedBotofwarSecretCode1() => byte(0xBB4AE0)

// $BB4B50: [8bit] Cheat Activated - STEALTHARMOR (Secret Code 2)
//          0x00=False
//          0x01=True
function CheatActivatedStealtharmorSecretCode2() => byte(0xBB4B50)

// $BB4C10: [8bit] Cheat Activated - RAINBOWLASER (Secret Code 3)
//          0x00=False
//          0x01=True
function CheatActivatedRainbowlaserSecretCode3() => byte(0xBB4C10)

// $BB4C80: [8bit] Cheat Activated EXPLOSIVEWORLD (Secret Code 4)
//          0x00=False
//          0x01=True
function CheatActivatedExplosiveworldSecretCode4() => byte(0xBB4C80)

// $BB4CF0: [8bit] Cheat Activated GLOWINTHEDARK (Secret Code 5)
//          0x00=False
//          0x01=True
function CheatActivatedGlowinthedarkSecretCode5() => byte(0xBB4CF0)

// $BB4D60: [8bit] Cheat Activated BOTOFMYSTERY (Secret Code 6)
//          0x00=False
//          0x01=True
function CheatActivatedBotofmysterySecretCode6() => byte(0xBB4D60)

// $BB4DD0: [8bit] Cheat Activated GOLDENTRACKS (Secret Code 7)
//          0x00=False
//          0x01=True
function CheatActivatedGoldentracksSecretCode7() => byte(0xBB4DD0)


// Cheat protection
function NoCheatsEnabled() => CheatActivatedIntergalactic() == 0 && 
CheatActivatedSoapbubbles() == 0 && 
CheatActivatedRatjukebox() == 0 && 
CheatActivatedIncrejukebox() == 0 && 
CheatActivatedBagpack() == 0 && 
CheatActivatedSkateboarder()== 0 && 
CheatActivatedHeavyweapon() == 0 && 
CheatActivatedBotofwarSecretCode1() == 0 && 
CheatActivatedStealtharmorSecretCode2() == 0 && 
CheatActivatedRainbowlaserSecretCode3() == 0 && 
CheatActivatedExplosiveworldSecretCode4() == 0 && 
CheatActivatedGlowinthedarkSecretCode5() == 0 && 
CheatActivatedBotofmysterySecretCode6() == 0 && 
CheatActivatedGoldentracksSecretCode7() == 0

achievement(
    title = "Trash Shoot - Box Destroyer",
    description = "Destroy all the boxes on Trash Shoot",
    points = 10,
    id = 306382, 
    badge = "339186",
    trigger = (
        ChapterId() == 58369 && 
        TrashShootAllBnlCratesDestroyed() == 1 &&
        prev(TrashShootAllBnlCratesDestroyed()) == 0 && 
        NoCheatsEnabled()
    )
)

achievement(
    title = "Robot Rescue",
    description = "Complete level Robot Rescue with no cheats enabled",
    points = 5,
    id = 306371,
    badge = "339175",
    trigger = ChapterId() == 56833 && RobotRescueChapterCompleted() == 1 && prev(RobotRescueChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Robot Rescue - Box Destroyer",
    points = 10,
    description = "Destroy all the boxes on Robot Rescue",
    id = 306372,
    badge = "339176",
    trigger = ChapterId() == 56833 && RobotRescueAllBnlCratesDestroyed() == 1 && prev(RobotRescueAllBnlCratesDestroyed()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Repair-Ward Playground",
    points = 4,
    description = "Complete level Repair-Ward Playground with no cheats enabled",
    id = 306373,
    badge = "339177",
    trigger = ChapterId() == 57089 && RepairWardPlaygroundChapterCompleted() == 1 && prev(RepairWardPlaygroundChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Human Highway",
    points = 4,
    description = "Complete level Human Highway with no cheats enabled",
    id = 306374,
    badge = "339178",
    trigger = ChapterId() == 57345 && HumanHighwayChapterCompleted() == 1 && prev(HumanHighwayChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Human Highway - Box Destroyer",
    points = 10,
    description = "Destroy all the boxes on Human Highway",
    id = 306375,
    badge = "339179",
    trigger = ChapterId() == 57345 && HumanHighwayAllBnlCratesDestroyed() == 1 && prev(HumanHighwayAllBnlCratesDestroyed()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Pod Blaster",
    points = 4,
    description = "Complete level Pod Blaster with no cheats enabled",
    id = 306376,
    badge = "339180",
    trigger = ChapterId() == 57601 && PodBlasterChapterCompleted() == 1 && prev(PodBlasterChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Cosmic Speedway",
    points = 4,
    description = "Complete level Cosmic Speedway with no cheats enabled",
    id = 306377,
    badge = "339181",
    trigger = ChapterId() == 57857 && CosmicSpeedwayChapterCompleted() == 1 && prev(CosmicSpeedwayChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Cosmic Speedway - Box Destroyer",
    points = 10,
    description = "Destroy all the boxes on Cosmic Speedway",
    id = 306378,
    badge = "339182",
    trigger = ChapterId() == 57857 && CosmicSpeedwayAllBnlCratesDestroyed() == 1 && prev(CosmicSpeedwayAllBnlCratesDestroyed()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Rogue Robots",
    points = 4,
    description = "Complete level Rogue Robots with no cheats enabled",
    id = 306379,
    badge = "339183",
    trigger = ChapterId() == 58113 && RogueRobotsChapterCompleted() == 1 && prev(RogueRobotsChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Rogue Robots - Box Destroyer",
    points = 10,
    description = "Destroy all the boxes on Rogue Robots",
    id = 306380,
    badge = "339184",
    trigger = ChapterId() == 58113 && RogueRobotsAllBnlCratesDestroyed() == 1 && prev(RogueRobotsAllBnlCratesDestroyed()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Trash Shoot", points = 4,
    description = "Complete level Trash Shoot with no cheats enabled",
    id = 306381, badge = "339185",
    trigger = ChapterId() == 58369 && TrashShootChapterCompleted() == 1 && prev(TrashShootChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Life on the Axiom - Box Destroyer", points = 10,
    description = "Destroy all the boxes on Life on the Axiom",
    id = 306370, badge = "339174",
    trigger = ChapterId() == 56577 && LifeOnTheAxiomAllBnlCratesDestroyed() == 1 && prev(LifeOnTheAxiomAllBnlCratesDestroyed()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Fixing EVE", points = 4,
    description = "Complete level Fixing EVE with no cheats enabled",
    id = 306383, badge = "339187",
    trigger = ChapterId() == 58625 && FixingEveChapterComplete() == 1 && prev(FixingEveChapterComplete()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Fixing EVE - Box Destroyer", points = 10,
    description = "Destroy all the boxes on Fixing EVE",
    id = 306384, badge = "339188",
    trigger = ChapterId() == 58625 && FixingEveAllBnlCratesDestroyed() == 1 && prev(FixingEveAllBnlCratesDestroyed()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Holo-Detector Dash", points = 4,
    description = "Complete level Holo-Detector Dash with no cheats enabled",
    id = 306385, badge = "339189",
    trigger = ChapterId() == 58881 && HoloDetectorDashChapterCompleted() == 1 && prev(HoloDetectorDashChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Holo-Detector Dash - Box Destroyer", points = 10,
    description = "Destroy all the boxes on Holo-Detector Dash",
    id = 306386, badge = "339190",
    trigger = ChapterId() == 58881 && HoloDetectorDashAllBnlCratesDestroyed() == 1 && prev(HoloDetectorDashAllBnlCratesDestroyed()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "A Robot's Last Stand", points = 4,
    description = "Complete level A Robot's Last Stand with no cheats enabled",
    id = 306387, badge = "339191",
    trigger = ChapterId() == 59137 && ARobotSLastStandChapterUnlocked() == 1 && prev(ARobotSLastStandChapterUnlocked()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "A Robot's Last Stand - Box Destroyer", points = 10,
    description = "Destroy all the boxes on A Robot's Last Stand",
    id = 306388, badge = "339192",
    trigger = ChapterId() == 59137 && ARobotSLastStandAllBnlCratesDestroyed() == 1 && prev(ARobotSLastStandAllBnlCratesDestroyed()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Home Coming", points = 4,
    description = "Complete level Home Coming with no cheats enabled",
    id = 306389, badge = "339193",
    trigger = ChapterId() == 59393 && HomeComingChapterCompleted() == 1 && prev(HomeComingChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Home Coming - Box Destroyer", points = 10,
    description = "Destroy all the boxes on Home Coming",
    id = 306390, badge = "339194",
    trigger = ChapterId() == 59393 && HomeComingAllBnlCratesDestroyed() == 1 && prev(HomeComingAllBnlCratesDestroyed()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Epilogue", points = 4,
    description = "Complete level Epilogue with no cheats enabled",
    id = 306391, badge = "339195",
    trigger = ChapterId() == 59649 && EpilogueChapterCompleted() == 1 && prev(EpilogueChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Lido-Deck Dash", points = 4,
    description = "Complete level Lido-Deck Dash with no cheats enabled",
    id = 306392, badge = "339196",
    trigger = ChapterId() == 59905 && LidoDeckDashChapterCompleted() == 1 && prev(LidoDeckDashChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Lido-Deck Dash - Box Destroyer", points = 10,
    description = "Destroy all the boxes on Lido-Deck Dash",
    id = 306393, badge = "339197",
    trigger = ChapterId() == 59905 && LidoDeckDashAllBnlCratesDestroyed() == 1 && prev(LidoDeckDashAllBnlCratesDestroyed()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Tanker Playground", points = 4,
    description = "Complete level Tanker Playground",
    id = 306358, badge = "339162",
    trigger = ChapterId() == 55041 && TankerPlaygroundChapterCompleted() == 1 && prev(TankerPlaygroundChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Sandstorm Sprint", points = 5,
    description = "Complete level Sandstorm Sprint",
    id = 306347, badge = "339151",
    trigger = ChapterId() == 53505 && SandstromSprintChapterCompleted() == 1 && prev(SandstromSprintChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Sandstorm Sprint - Box Destroyer", points = 10,
    description = "Destroy all the boxes on Sandstorm Sprint",
    id = 306348, badge = "339152",
    trigger = ChapterId() == 53505 && SandstormSprintAllBnlCratesDestroyed() == 1 && prev(SandstormSprintAllBnlCratesDestroyed()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Home Sweet Home", points = 4,
    description = "Complete level Home Sweet Home",
    id = 306349, badge = "339153",
    trigger = ChapterId() == 53761 && HomeSweetHomeChapterCompleted() == 1 && prev(HomeSweetHomeChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Home Sweet Home - Box Destroyer", points = 10,
    description = "Destroy all the boxes on Home Sweet Home",
    id = 306350, badge = "339154",
    trigger = ChapterId() == 53761 && HomeSweetHomeAllBnlCratesDestroyed() == 1 && prev(HomeSweetHomeAllBnlCratesDestroyed()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Work Day", points = 4,
    description = "Complete level Work Day",
    id = 306351, badge = "339155",
    trigger = ChapterId() == 54017 && WorkDayChapterCompleted() == 1 && prev(WorkDayChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Work Day - Box Destroyer", points = 10,
    description = "Destroy all the boxes on Work Day",
    id = 306352, badge = "339156",
    trigger = ChapterId() == 54017 && WorkDayAllBnlCratesDestroyed() == 1 && prev(WorkDayAllBnlCratesDestroyed()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Hidden Treasure", points = 4,
    description = "Complete level Hidden Treasure",
    id = 306353, badge = "339157",
    trigger = ChapterId() == 54273 && HiddenTreasureChapterCompleted() == 1 && prev(HiddenTreasureChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Hidden Treasure - Box Destroyer", points = 10,
    description = "Destroy all the boxes on Hidden Treasure",
    id = 306354, badge = "339158",
    trigger = ChapterId() == 54273 && HiddenTreasureAllBnlCratesDestroyed() == 1 && prev(HiddenTreasureAllBnlCratesDestroyed()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Truck Sweet Truck", points = 4,
    description = "Complete level Truck Sweet Truck",
    id = 306355, badge = "339159",
    trigger = ChapterId() == 54529 && TruckSweetTruckChapterCompleted() == 1 && prev(TruckSweetTruckChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Shipyard", points = 4,
    description = "Complete level Shipyard",
    id = 306356, badge = "339160",
    trigger = ChapterId() == 54785 && ShipyardChapterCompleted() == 1 && prev(ShipyardChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Shipyard - Box Destroyer", points = 10,
    description = "Destroy all the boxes on Shipyard",
    id = 306357, badge = "339161",
    trigger = ChapterId() == 54785 && ShipyardAllBnlCratesDestroyed() == 1 && prev(ShipyardAllBnlCratesDestroyed()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "BnL Tune-Up", points = 5,
    description = "Complete level BnL Tune-Up",
    id = 306346, badge = "339150",
    trigger = ChapterId() == 53249 && BnlTuneUpChapterCompleted() == 1 && prev(BnlTuneUpChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Taking Flight", points = 4,
    description = "Complete level Taking Flight",
    id = 306359, badge = "339163",
    trigger = ChapterId() == 55297 && TakingFlightChapterCompleted() == 1 && prev(TakingFlightChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Taking Flight - Box Destroyer", points = 10,
    description = "Destroy all the boxes on Taking Flight",
    id = 306360, badge = "339164",
    trigger = ChapterId() == 55297 && TakingFlightAllBnlCratesDestroyed() == 1 && prev(TakingFlightAllBnlCratesDestroyed()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Surprise Departure", points = 4,
    description = "Complete level Surprise Departure",
    id = 306361, badge = "339165",
    trigger = ChapterId() == 55553 && SurpriseDepartureChapterCompleted() == 1 && prev(SurpriseDepartureChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Surprise Departure - Box Destroyer", points = 10,
    description = "Destroy all the boxes on Surprise Departure",
    id = 306362, badge = "339166",
    trigger = ChapterId() == 55553 && SurpriseDepartureAllBnlCratesDestroyed() == 1 && prev(SurpriseDepartureAllBnlCratesDestroyed()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Stowaway to Space", points = 4,
    description = "Complete level Stowaway to Space",
    id = 306363, badge = "339167",
    trigger = ChapterId() == 55809 && StowawayToSpaceChapterCompleted() == 1 && prev(StowawayToSpaceChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Stowaway to Space - Box Destroyer", points = 10,
    description = "Destroy all the boxes on Stowaway to Space",
    id = 306364, badge = "339168",
    trigger = ChapterId() == 55809 && StowawayToSpaceAllBnlCratesDestroyed() == 1 && prev(StowawayToSpaceAllBnlCratesDestroyed()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "EVE Pursuit", points = 4,
    description = "Complete level EVE Pursuit",
    id = 306365, badge = "339169",
    trigger = ChapterId() == 56065 && EvePursuitChapterCompleted() == 1 && prev(EvePursuitChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "EVE Pursuit - Box Destroyer", points = 10,
    description = "Destroy all the boxes on EVE Pursuit",
    id = 306366, badge = "339170",
    trigger = ChapterId() == 56065 && EvePursuitAllBnlCratesDestroyed() == 1 && prev(EvePursuitAllBnlCratesDestroyed()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Clean Getaway", points = 4,
    description = "Complete level Clean Getaway with no cheats enabled",
    id = 306367, badge = "339171", 
    trigger = ChapterId() == 56321 && CleanGetawayChapterCompleted() == 1 && prev(CleanGetawayChapterCompleted()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Clean Getaway - Box Destroyer", points = 10,
    description = "Destroy all the boxes on Clean Getaway",
    id = 306368, badge = "339172",
    trigger = ChapterId() == 56321 && CleanGetawayAllBnlCratesDestroyed() == 1 && prev(CleanGetawayAllBnlCratesDestroyed()) == 0 && NoCheatsEnabled()
)

achievement(
    title = "Life on the Axiom", points = 4,
    description = "Complete level Life on the Axiom with no cheats enabled",
    id = 306369, badge = "339173",
    trigger = ChapterId() == 56577 && LifeOnTheAxiomChapterCompleted() == 1 && prev(LifeOnTheAxiomChapterCompleted()) == 0 && NoCheatsEnabled()
)
