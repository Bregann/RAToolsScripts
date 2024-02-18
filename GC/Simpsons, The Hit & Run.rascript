// Simpsons, The: Hit & Run
// #ID = 2199

// Game stuff
FollowDmgMissionDataPointer = dword_be(0x00476878) & 0x1fffffff
VoicelinePointer = dword_be(0x0093354c) & 0x1fffffff

LevelID = byte(0x69d82b)
MissionNum = byte(0x69d82f)
GameState = byte(0x7f5c77)
HitAndRunMeter = float_be(0x006bce2c)
CheatsActive = bit0(0x00476605) + bit2(0x00476605) + bit3(0x00476605) + bit4(0x00476605) + 
bit5(0x00476605) + bit6(0x00476605) + bit7(0x00476605) + bit0(0x00476606) + 
bit1(0x00476606) +  bit3(0x00476606) + bit5(0x00476607) + bit7 (0x00476607)

CheatsActiveNo100CarCheat = bit0(0x00476605) + bit2(0x00476605) + bit3(0x00476605) + bit4(0x00476605) + 
bit5(0x00476605) + bit6(0x00476605) + bit7(0x00476605) + bit0(0x00476606) + 
bit1(0x00476606) +  bit3(0x00476606) + bit7 (0x00476607)

function InGame(levelId) => GameState >= 0x09 && levelId == LevelID
function CheatCheck() => CheatsActive == 0x00


// ========= Progression =========
Level1MissionsComplete = byte(0x69c7dc) + byte(0x69c7fc) + byte(0x69c81c) + byte(0x69c83c) + byte(0x69c85c) + byte(0x69c87c) + byte(0x69c89c)
Level2MissionsComplete = byte(0x69ca28) + byte(0x69ca48) + byte(0x69ca68) + byte(0x69ca88) + byte(0x69caa8) + byte(0x69cac8) + byte(0x69cae8)
Level3MissionsComplete = byte(0x69cc94) + byte(0x69ccb4) + byte(0x69ccd4) + byte(0x69ccf4) + byte(0x69cd14) + byte(0x69cd34) + byte(0x69cd54)
Level4MissionsComplete = byte(0x69cf00) + byte(0x69cf20) + byte(0x69cf40) + byte(0x69cf60) + byte(0x69cf80) + byte(0x69cfa0) + byte(0x69cfc0)
Level5MissionsComplete = byte(0x69d16c) + byte(0x69d18c) + byte(0x69d1ac) + byte(0x69d1cc) + byte(0x69d1ec) + byte(0x69d20c) + byte(0x69d22c)
Level6MissionsComplete = byte(0x69d3d8) + byte(0x69d3f8) + byte(0x69d418) + byte(0x69d438) + byte(0x69d458) + byte(0x69d478) + byte(0x69d498)
Level7MissionsComplete = byte(0x69d644) + byte(0x69d664) + byte(0x69d684) + byte(0x69d6a4) + byte(0x69d6c4) + byte(0x69d6e4) + byte(0x69d704)

achievement (
    title = "A Simple Task",
    description = "Complete the tutorial mission",
    points = 2,
    type = "Progression",
    trigger = (
        CheatCheck() &&
        InGame(0) &&
        byte(0x69c7bc) == 0x01 &&
        prev(byte(0x69c7bc)) == 0x00
    )
)

function LevelComplete(achName, achDesc, points, levelMissions, levelId, type)
{
    achievement (
        title = achName,
        description = achDesc,
        points = points,
        type = type,
        trigger = (
            CheatCheck() &&
            InGame(levelId) &&
            measured(levelMissions == 0x07) &&
            prev(levelMissions) == 0x06
        )
    )
}

LevelComplete("The Truth of Mr Burns", "Complete all main missions in level 1", 10, Level1MissionsComplete, 0x00, "Progression")
LevelComplete("Abducted", "Complete all main missions in level 2", 10, Level2MissionsComplete, 0x01, "Progression")
LevelComplete("Lisa on the Hunt", "Complete all main missions in level 3", 10, Level3MissionsComplete, 0x02, "Progression")
LevelComplete("Crop Circles!", "Complete all main missions in level 4", 10, Level4MissionsComplete, 0x03, "Progression")
LevelComplete("Apu Adventure", "Complete all main missions in level 5", 10, Level5MissionsComplete, 0x04, "Progression")
LevelComplete("Springfield is Doomed!", "Complete all main missions in level 6", 10, Level6MissionsComplete, 0x05, "Progression")
LevelComplete("I Smell Toast", "Complete all main missions in level 7", 25, Level7MissionsComplete, 0x06, "Win_condition")

// ========= Bonus Missions =========
function MissionComplete(achName, missionName, missionCompleteValue, levelId)
{
        achievement (
        title = achName,
        description = "Complete bonus mission " + missionName,
        points = 3,
        trigger = (
            CheatCheck() &&
            InGame(levelId) &&
            missionCompleteValue == 0x01 &&
            prev(missionCompleteValue) == 0x00
        )
    )
}

MissionComplete("This Old Shanty", "this old shanty", byte(0x69c91c), 0)
MissionComplete("Dial B For Blood", "dial b for blood", byte(0x69cb88), 1)
MissionComplete("Princi-pal", "princi-pal", byte(0x69cdf4), 2)
MissionComplete("Beached Love", "beached love", byte(0x69d060), 3)
MissionComplete("Kinky Frinky", "kinky frinky", byte(0x69d2cc), 4)
MissionComplete("Milking the Pigs", "milking the pigs", byte(0x69d538), 5)
MissionComplete("Flaming Tires", "flaming tires", byte(0x69d7a4), 6)

// ========= Races =========
Level1RacesComplete = byte(0x69c8bc) + byte(0x69c8dc) + byte(0x69c8fc)
Level2RacesComplete = byte(0x69cb28) + byte(0x69cb48) + byte(0x69cb68)
Level3RacesComplete = byte(0x69cd94) + byte(0x69cdb4) + byte(0x69cdd4)
Level4RacesComplete = byte(0x69d000) + byte(0x69d020) + byte(0x69d040)
Level5RacesComplete = byte(0x69d26c) + byte(0x69d28c) + byte(0x69d2ac)
Level6RacesComplete = byte(0x69d4d8) + byte(0x69d4f8) + byte(0x69d518)
Level7RacesComplete = byte(0x69d744) + byte(0x69d764) + byte(0x69d784)

function LevelEndMissionCompleteOrSkipped(completeMem, skippedMem)  => byte(completeMem) + byte(skippedMem) == 0x00

function RaceComplete(achName, achDesc, points, raceMissions, levelId, endMissionCompleted)
{
    achievement (
        title = achName,
        description = achDesc,
        points = points,
        type = "Missable",
        trigger = (
            CheatCheck() &&
            InGame(levelId) &&
            trigger_when(
            raceMissions == 0x03 &&
            prev(raceMissions) == 0x02 &&
            endMissionCompleted)
        )
    )
}

RaceComplete("Funny Pink Car Master", "Win all 3 street races in level 1 before reaching level 2", 10, Level1RacesComplete, 0x00, LevelEndMissionCompleteOrSkipped(0x0069c89c, 0x0069c8a4))
RaceComplete("Rolling Around in the Roller", "Win all 3 street races in level 2 before reaching level 3", 10, Level2RacesComplete, 0x01, LevelEndMissionCompleteOrSkipped(0x0069cae8, 0x0069caf0))
RaceComplete("Doll Car Dash", "Win all 3 street races in level 3 before reaching level 4", 10, Level3RacesComplete, 0x02, LevelEndMissionCompleteOrSkipped(0x0069cd54, 0x0069cd5c))
RaceComplete("Look at the Canyonero Go!", "Win all 3 street races in level 4 before reaching level 5", 10, Level4RacesComplete, 0x03, LevelEndMissionCompleteOrSkipped(0x0069cfc0, 0x0069cfc8))
RaceComplete("Apu Approved", "Win all 3 street races in level 5 before reaching level 6", 10, Level5RacesComplete, 0x04, LevelEndMissionCompleteOrSkipped(0x0069d22c, 0x0069d234))
RaceComplete("Ferrari Speedster", "Win all 3 street races in level 6 before reaching level 7", 10, Level6RacesComplete, 0x05, LevelEndMissionCompleteOrSkipped(0x0069d498, 0x0069d4a0))

achievement (
    title = "Dead Close",
    description = "Win all 3 street races in level 7",
    points = 5,
    trigger = (
        CheatCheck() &&
        InGame(0x06) &&
        Level7RacesComplete == 0x03 &&
        prev(Level7RacesComplete) == 0x02
    )
)

WagerRaceLevel1 = dword_be(0x0069c948)
WagerRaceLevel2 = dword_be(0x0069cbb4)
WagerRaceLevel3 = dword_be(0x0069ce20)
WagerRaceLevel4 = dword_be(0x0069d08c)
WagerRaceLevel5 = dword_be(0x0069d2f8)
WagerRaceLevel6 = dword_be(0x0069d564)
WagerRaceLevel7 = dword_be(0x0069d7d0)

achievement(
    title = "Wagering a Win",
    description = "Beat the best time on every wager race",
    points = 5,
    trigger = (
        CheatCheck() &&
        GameState >= 0x09 &&
        WagerRaceLevel1 < 195 &&
        WagerRaceLevel2 < 120 &&
        WagerRaceLevel3 < 140 &&
        WagerRaceLevel4 < 150 &&
        WagerRaceLevel5 < 125 &&
        WagerRaceLevel6 < 115 &&
        WagerRaceLevel7 < 90 &&
        (
            prev(WagerRaceLevel1) >= 195 ||
            prev(WagerRaceLevel2) >= 120 ||
            prev(WagerRaceLevel3) >= 140 ||
            prev(WagerRaceLevel4) >= 150 ||
            prev(WagerRaceLevel5) >= 125 ||
            prev(WagerRaceLevel6) >= 115 ||
            prev(WagerRaceLevel7) >= 90
        )
    )
)

BonusRaceLevelId = byte(0x006bcf9b)

function BonusRaceAchievements(achTitle, achDesc, bonusRaceId)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = 2,
        trigger = (
            CheatCheck() &&
            GameState == 0x07 &&
            BonusRaceLevelId == bonusRaceId &&
            byte(0x00c59533) > prev(byte(0x00c59533))
        )
    )
}

BonusRaceAchievements("Bonus Race 1", "Win the Level 1 race in the bonus game mode", 0x08)
BonusRaceAchievements("Bonus Race 2", "Win the Level 2 race in the bonus game mode", 0x09)
BonusRaceAchievements("Bonus Race 3", "Win the Level 3 race in the bonus game mode", 0x0a)
BonusRaceAchievements("Bonus Race 4", "Win the Level 4 race in the bonus game mode", 0x0b)
BonusRaceAchievements("Bonus Race 5", "Win the Level 5 race in the bonus game mode", 0x0c)
BonusRaceAchievements("Bonus Race 6", "Win the Level 6 race in the bonus game mode", 0x0d)
BonusRaceAchievements("Bonus Race 7", "Win the Level 7 race in the bonus game mode", 0x0e)

// ========= Collectibles =========
function Collectible(achTitle, levelId, achDesc, collectibleAmount, collectibleAddr)
{
    achievement (
        title = achTitle,
        description = achDesc + " " + levelId + 1,
        points = 10,
        trigger = (
            CheatCheck() &&
            InGame(levelId) &&
            measured(collectibleAddr == collectibleAmount) &&
            prev(collectibleAddr) < collectibleAmount
        )
    )
}

//Wasps
Collectible("Destroying the Footage", 0x00, "Destroy every wasp in level", 20, byte(0x0069c95b))
Collectible("Bart the Vandal", 0x01, "Destroy every wasp in level", 20, byte(0x0069cbc7))
Collectible("Seaside Wasp Killer", 0x02, "Destroy every wasp in level", 20, byte(0x0069ce33))
Collectible("Marge the Real Wasp Murderer", 0x03, "Destroy every wasp in level", 20, byte(0x0069d09f))
Collectible("Downtown Destroyer", 0x04, "Destroy every wasp in level", 20, byte(0x0069d30b))
Collectible("Night Time Wasp Wrecker", 0x05, "Destroy every wasp in level", 20, byte(0x0069d577))
Collectible("Undead Wasp Killer", 0x06, "Destroy every wasp in level", 20, byte(0x0069d7e3))

//Cola crates & vending machines
Level1ColaStuff = bit0(0x0069ddf4) + bit1(0x0069ddf4) + bit0(0x0069de04) + bit1(0x0069de04) +
bit0(0x0069de24) + bit1(0x0069de24) + bit0(0x0069de35) + bit0(0x0069de44) + bit1(0x0069de44) +
bit2(0x0069de44) + bit3(0x0069de44) + bit4(0x0069de44) + bit0(0x0069de54) + bit1(0x0069de54) +
bit2(0x0069de54) + bit3(0x0069de54) + bit4(0x0069de54) + bit5(0x0069de54) + bit0(0x0069de64) +
bit3(0x0069de64) + bit4(0x0069de64) + bit5(0x0069de64) + bit0(0x0069de74) + bit1(0x0069de74) +
bit2(0x0069de74) + bit3(0x0069de74) + bit4(0x0069de74) + bit1(0x0069de94) + bit2(0x0069de94) +
bit0(0x0069dea4)

Level2ColaStuff = bit0(0x0069deb4) + bit1(0x0069deb4) + bit0(0x0069dec4) + bit1(0x0069dec4) +
bit0(0x0069dee4) + bit1(0x0069dee4) + bit1(0x0069def4) + bit2(0x0069def4) + bit3(0x0069def4) + 
bit4(0x0069def4) + bit5(0x0069def4) + bit7(0x0069def4) + bit2(0x0069df04) + bit3(0x0069df04) +
bit4(0x0069df04) + bit5(0x0069df04) + bit0(0x0069df14) + bit2(0x0069df14) + bit1(0x0069df25) + 
bit2(0x0069df25) + bit3(0x0069df25) + bit4(0x0069df25) + bit5(0x0069df25)

Level3ColaStuff = bit2(0x0069df34) + bit0(0x0069df54) + bit1(0x0069df54) + bit2(0x0069df54) +
bit0(0x0069df74) + bit0(0x0069df84) + bit1(0x0069df84) + bit2(0x0069df84) + bit3(0x0069df84) +
bit0(0x0069df94) + bit3(0x0069dfa4) + bit4(0x0069dfa4) + bit4(0x0069dfb4) + bit5(0x0069dfb4) +
bit6(0x0069dfb4) + bit7(0x0069dfb4) + bit0(0x0069dfb5) + bit1(0x0069dfb5) + bit2(0x0069dfb5) +
bit3(0x0069dfb5) + bit4(0x0069dfb5) + bit5(0x0069dfb5) + bit0(0x0069dfc4) + bit1(0x0069dfc4) +
bit2(0x0069dfc4)

Level4ColaStuff = bit0(0x0069dfe4) + bit1(0x0069dfe4) + bit0(0x0069dff4) + bit1(0x0069dff4) +
bit2(0x0069dff4) + bit3(0x0069dff4) + bit0(0x0069e014) + bit0(0x0069e024) + bit2(0x0069e034) +
bit3(0x0069e034) + bit4(0x0069e034) + bit0(0x0069e044) + bit1(0x0069e044) + bit2(0x0069e044) +
bit3(0x0069e044) + bit4(0x0069e044) + bit5(0x0069e044) + bit0(0x0069e054) + bit1(0x0069e054) +
bit2(0x0069e054) + bit3(0x0069e054) + bit0(0x0069e064) + bit1(0x0069e064) + bit2(0x0069e064) +
bit3(0x0069e064) + bit4(0x0069e064) + bit1(0x0069e084) + bit2(0x0069e084)

Level5ColaStuff = bit0(0x0069e0a4) + bit1(0x0069e0a4) + bit0(0x0069e0b4) + bit1(0x0069e0b4) +
bit0(0x0069e0d4) + bit1(0x0069e0d4) + bit0(0x0069e0e4) + bit1(0x0069e0e4) + bit2(0x0069e0e4) +
bit3(0x0069e0e4) + bit4(0x0069e0e4) + bit5(0x0069e0e4) + bit6(0x0069e0e4) + bit3(0x0069e0f4) +
bit4(0x0069e0f4) + bit5(0x0069e0f4) + bit6(0x0069e0f4) + bit0(0x0069e104) + bit6(0x0069e104) + 
bit0(0x0069e114) + bit1(0x0069e114) + bit2(0x0069e114) + bit3(0x0069e114) + bit4(0x0069e114) +
bit5(0x0069e114)

Level6ColaStuff = bit2(0x0069e124) + bit0(0x0069e134) + bit1(0x0069e134) + bit1(0x0069e144) +
bit2(0x0069e144) + bit3(0x0069e144) + bit0(0x0069e164) + bit0(0x0069e174) + bit1(0x0069e174) +
bit2(0x0069e174) + bit3(0x0069e174) + bit0(0x0069e194) + bit1(0x0069e194) + bit0(0x0069e1a4) +
bit1(0x0069e1a4) + bit2(0x0069e1a4) + bit7(0x0069e1a4) + bit0(0x0069e1a5) + bit1(0x0069e1a5) +
bit2(0x0069e1a5) + bit3(0x0069e1a5) + bit4(0x0069e1a5) + bit5(0x0069e1a5) + bit0(0x0069e1b4) +
bit1(0x0069e1b4) + bit2(0x0069e1b4)

Level7ColaStuff = bit0(0x0069e1d4) + bit1(0x0069e1d4) + bit4(0x0069e224) + bit5(0x0069e224) +
bit0(0x0069e225) + bit0(0x0069e234) + bit1(0x0069e234) + bit2(0x0069e234) + bit3(0x0069e234) +
bit4(0x0069e234) + bit5(0x0069e234) + bit2(0x0069e244) + bit3(0x0069e244) + bit4(0x0069e244) +
bit7(0x0069e244) + bit0(0x0069e245) + bit1(0x0069e245) + bit0(0x0069e254) + bit1(0x0069e254) +
bit2(0x0069e254) + bit3(0x0069e254) + bit6(0x0069e254) + bit0(0x0069e274) + bit1(0x0069e274) +
bit2(0x0069e274) + bit3(0x0069e274) + bit4(0x0069e274) + bit5(0x0069e274)

Collectible("Homer's Box Destroying Day", 0x00, "Destroy every cola crate and vending machine on level", 30, Level1ColaStuff)
Collectible("No Box Left Destroyed", 0x01, "Destroy every cola crate and vending machine on level", 23,  Level2ColaStuff)
Collectible("Lisa the Breaker of Vending Machine", 0x02, "Destroy every cola crate and vending machine on level", 25,  Level3ColaStuff)
Collectible("Marge Destroying Evil Cola", 0x03, "Destroy every cola crate and vending machine on level", 28,  Level4ColaStuff)
Collectible("Breaking the Kwik-E-Mart Stock", 0x04, "Destroy every cola crate and vending machine on level", 25,  Level5ColaStuff)
Collectible("Attempting to Stop the Cola", 0x05, "Destroy every cola crate and vending machine on level", 26,  Level6ColaStuff)
Collectible("Spooky Vending Machines", 0x06, "Destroy every cola crate and vending machine on level", 28,  Level7ColaStuff)

//Cards
Collectible("Homer the Great", 0x00, "Collect every collector card on level", 7, byte(0x0069c65b))
Collectible("The Telltale Head", 0x01, "Collect every collector card on level", 7,  byte(0x0069c67b))
Collectible("I Love Lisa", 0x02, "Collect every collector card on level", 7,  byte(0x0069c69b))
Collectible("The Springfield Connection", 0x03, "Collect every collector card on level", 7,  byte(0x0069c6bb))
Collectible("Homer and Apu", 0x04, "Collect every collector card on level", 7,  byte(0x0069c6db))
Collectible("Itchy and Scratchy Land", 0x05, "Collect every collector card on level", 7,  byte(0x0069c6fb))
Collectible("Hungry are the Damned", 0x06, "Collect every collector card on level", 7,  byte(0x0069c71b))

//Clothing
Collectible("Casual Homer Chilling", 0x00, "Purchase every outfit on level", 3, byte(0x0069c957))
Collectible("Sneaky Ninja Bart", 0x01, "Purchase every outfit on level", 3, byte(0x0069cbc3))
Collectible("Floreda", 0x02, "Purchase every outfit on level", 3, byte(0x0069ce2f))
Collectible("You're Under Arrest!", 0x03, "Purchase every outfit on level", 3, byte(0x0069d09b))
Collectible("Apu the Singer", 0x04, "Purchase every outfit on level", 3, byte(0x0069d307))
Collectible("Bart's Brother!", 0x05, "Purchase every outfit on level", 3, byte(0x0069d573))
Collectible("Donut Homer Blocking the View!", 0x06, "Purchase every outfit on level", 3, byte(0x0069d7df))

//Vehicles
Level1Vehicles = Level1RacesComplete + byte(0x69c91c) + byte(0x0069c953)
Level2Vehicles = Level2RacesComplete + byte(0x69cb88) + byte(0x0069cbbf)
Level3Vehicles = Level3RacesComplete + byte(0x69cdf4) + byte(0x0069ce2b)
Level4Vehicles = Level4RacesComplete + byte(0x69d060) + byte(0x0069d097)
Level5Vehicles = Level5RacesComplete + byte(0x69d2cc) + byte(0x0069d303)
Level6Vehicles = Level6RacesComplete + byte(0x69d538) + byte(0x0069d56f)
Level7Vehicles = Level7RacesComplete + byte(0x69d7a4) + byte(0x0069d7db)

Collectible("Electaurus", 0x00, "Unlock every vehicle on level", 5, Level1Vehicles)
Collectible("Now My Story Begins in Nineteen Dickety Two", 0x01, "Unlock every vehicle on level", 5, Level2Vehicles)
Collectible("Nerdddddd!", 0x02, "Unlock every vehicle on level", 5, Level3Vehicles)
Collectible("It's Willies Time", 0x03, "Unlock every vehicle on level", 5, Level4Vehicles)
Collectible("Sound of the Police", 0x04, "Unlock every vehicle on level", 5, Level5Vehicles)
Collectible("The Ultimate Villain Car", 0x05, "Unlock every vehicle on level", 5, Level6Vehicles)
Collectible("Brains! Brains!", 0x06, "Unlock every vehicle on level", 5, Level7Vehicles)

//Gags
Collectible("Silent Alarm Activated", 0x00, "Activate every gag on level", 15, byte(0x0069c96f))
Collectible("Flying Cat", 0x01, "Activate every gag on level", 11,  byte(0x0069cbdb))
Collectible("Teleporting Monkey", 0x02, "Activate every gag on level", 11,  byte(0x0069ce47))
Collectible("A Secret in the Mansion", 0x03, "Activate every gag on level", 15,  byte(0x0069d0b3))
Collectible("A Flaming Moe", 0x04, "Activate every gag on level", 6,  byte(0x0069d31f))
Collectible("Kamp Krusty", 0x05, "Activate every gag on level", 11,  byte(0x0069d58b))
Collectible("The Spook-E-Mart", 0x06, "Activate every gag on level", 15,  byte(0x0069d7f7))

//The movie
achievement(
    title = "Off to the Movies!",
    description = "Unlock the bonus movie",
    points = 2,
    trigger = (
        InGame(0x02) &&
        byte(0x0069ce24) == 0x01 &&
        prev(byte(0x0069ce24)) == 0x00
    )
)

// ========= Challenges =========
MissionState = dword_be(0x006b0f88)


function PhoneboxCarSelected(carName) => ascii_string_equals(0x003c8c20, carName)
CurrentCar = byte(0x006bce87)

// Dunno how to name these, Loaded is started the mission
// SelectedLevel is for checking if they cancelled the mission and it's just sitting as the active mission but free roam
function HasAttemptedSkip() => byte(FollowDmgMissionDataPointer + 0x1C9B) == 0x02 && prev(byte(FollowDmgMissionDataPointer + 0x1C9B)) != 0x00

function IsInFatAndFuriousLoaded() => ascii_string_equals(0x006b0fa0, "el01\\m7l")
function IsInFatAndFuriousSelectedLevel() => ascii_string_equals(0x006b0fa0, "el01\\m7s")

function IsMonkeyLoaded() => ascii_string_equals(0x006b0fa0, "el02\\m6l")

function IsCelloutsLoaded() => ascii_string_equals(0x006b0fa0, "el02\\m7l")
function IsCelloutsSelectedLevel() => ascii_string_equals(0x006b0fa0, "el02\\m7s")

function IsFromOuterSpaceLoaded() => ascii_string_equals(0x006b0fa0, "el04\\m7l")
function IsFromOuterSpaceSelectedLevel() => ascii_string_equals(0x006b0fa0, "el04\\m7s")

function IsLabCoatCaperLoaded() => ascii_string_equals(0x006b0fa0, "el06\\m3l")
function IsLabCoatCaperSelectedLevel() => ascii_string_equals(0x006b0fa0, "el06\\m3s")
function IsLabCoatCaperCompleted() => ascii_string_equals(0x006b0fa0, "el06\\m4s")

function IsLabCoatCaperLoaded() => ascii_string_equals(0x006b0fa0, "el06\\m3l")
function IsLabCoatCaperSelectedLevel() => ascii_string_equals(0x006b0fa0, "el06\\m3s")
function IsLabCoatCaperCompleted() => ascii_string_equals(0x006b0fa0, "el06\\m4s")

function IsAlienPart1Loaded() => ascii_string_equals(0x006b0fa0, "el07\\m5l")
function IsAlienPart1SelectedLevel() => ascii_string_equals(0x006b0fa0, "el07\\m5s")
function IsAlienPart1Completed() => ascii_string_equals(0x006b0fa0, "el07\\m6s")

achievement(
    title = "Plow King Round 2",
    description = "Complete The Fat and Furious with the Plow King",
    points = 5,
    trigger = (
        CheatCheck() &&
        once(MissionState == 0x02 && IsInFatAndFuriousLoaded()) &&
        never(IsInFatAndFuriousSelectedLevel() || !PhoneboxCarSelected("plowk_v") || CurrentCar != 0x3a || GameState == 0x02 || HasAttemptedSkip()) &&
        trigger_when(LevelID == 0x01 && prev(LevelID) == 0x00)
    )
)

function AllMonkeysCollected() => trigger_when(ascii_string_equals(0x00d031c1, "3") && ascii_string_equals(0x00d031c3, "0") && prev(byte(0x00d031c1)) == 0x32 && prev(byte(0x00d031c3)) == 0x39)

// Checks if its 3 mins on the minutes timer or 2 mins and 50, 40, 30 or 20 secs left
// I cannot find the actual timer in game so we use ASCII
function BelowTimer() => ascii_string_equals(0x00cfe389, "3") || ascii_string_equals(0x00cfe389, "4") || 
(ascii_string_equals(0x00cfe389, "2") && 
    (ascii_string_equals(0x00cfe38d, "5") || 
    ascii_string_equals(0x00cfe38d, "4") || 
    ascii_string_equals(0x00cfe38d, "3") || 
    ascii_string_equals(0x00cfe38d, "2")))

achievement(
    title = "Speedy Monkey Collector",
    description = "Collect all 30 monkeys with 2:20 or more left on the clock in mission Monkey See Monkey D'oh",
    points = 10,
    trigger = (
        CheatCheck() &&
        IsMonkeyLoaded() &&
        AllMonkeysCollected() &&
        BelowTimer()
    )
)

achievement(
    title = "Delicate Destruction",
    description = "Complete cellouts without the hit and run meter reaching higher than 5% (cancel mission to retry)",
    points = 10,
    trigger = (
        CheatCheck() &&
        once(MissionState == 0x02 && IsCelloutsLoaded()) &&
        never(IsCelloutsSelectedLevel() || HitAndRunMeter > 5.0 || GameState == 0x02 || HasAttemptedSkip()) &&
        trigger_when(LevelID == 0x02 && prev(LevelID) == 0x01)
    )
)

achievement(
    title = "War on the Cola Trucks!",
    description = "Complete From Outer Space using the WWII Vehicle",
    points = 5,
    trigger = (
        CheatCheck() &&
        once(MissionState == 0x02 && IsFromOuterSpaceLoaded()) &&
        never(IsFromOuterSpaceSelectedLevel() || !PhoneboxCarSelected("gramp_v") || CurrentCar != 0x05 || GameState == 0x02 || HasAttemptedSkip()) &&
        trigger_when(LevelID == 0x03 && prev(LevelID) == 0x04)
    )
)

FollowDistance = float_be(FollowDmgMissionDataPointer + 0x350)

achievement(
    title = "The Curious Curator",
    description = "Keep the follow bar above 60% in Lab Coat caper only driving the curator",
    points = 10,
    trigger = (
        CheatCheck() &&
        once(MissionState == 0x02 && IsLabCoatCaperLoaded()) &&
        never(
            (IsLabCoatCaperSelectedLevel() || !PhoneboxCarSelected("cCurator") || CurrentCar != 0x29 || GameState == 0x02 || HasAttemptedSkip()) ||
            (prev(FollowDistance) >= 0.60 && FollowDistance < 0.60)
        ) &&
        trigger_when(IsLabCoatCaperCompleted())
    )
)

achievement(
    title = "Duff Delivery Service",
    description = "Complete Alien Autotopsy Part I only driving the duff truck",
    points = 10,
    trigger = (
        CheatCheck() &&
        once(MissionState == 0x02 && IsAlienPart1Loaded()) &&
        never(IsAlienPart1SelectedLevel() || (!PhoneboxCarSelected("cDuff") || CurrentCar != 0x41) || GameState == 0x02 || HasAttemptedSkip()) &&
        trigger_when(IsAlienPart1Completed())
    )
)

//The doorbells
LardLadVoicelines = [
    0x80948658,
    0x8094866c,
    0x809485a4,
    0x809485b8,
    0x809485cc,
    0x809485e0,
    0x80948608,
    0x80948644,
    0x80948630,
    0x8094861c,
    0x809485f4
]

SkinnerVoicelines = [
    0x809466b4,
    0x80946678,
    0x8094668c,
    0x809466a0
]

QuimbyVoicelines = [
    0x80945480,
    0x80945494,
    0x809454a8,
    0x80945458,
    0x8094546c
]

SocialClubVoicelines = [
    0x809430a4,
    0x809430b8,
    0x809430cc,
    0x8094307c,
    0x80943090
]

KrustyVoicelines = [
    0x80941434,
    0x80941448,
    0x8094145c,
    0x80941470,
    0x80941484
]

MoeVoicelines = [
    0x809449a4,
    0x809449b8,
    0x80944940,
    0x80944954,
    0x80944968,
    0x8094497c,
    0x80944990
]

NelsonVoiceline = [
    0x80944c60,
    0x809359e0,
    0x80944c74,
    0x80944c88,
    0x80944c38,
    0x80944c4c
]

FlandersVoiceline = [
    0x8093e84c,
    0x8093e860,
    0x8093e874,
    0x8093e838
]

DrNickVoicelines = [
    0x8093e61c,
    0x8093e5e0,
    0x8093e5f4,
    0x8093e608
]

RalphVoiceLines = [
    0x80945610,
    0x809455e8,
    0x809455fc
]

CletusVoiceLines = [
    0x80939900,
    0x80939914,
    0x80939928,
    0x8093993c,
    0x80939950,
    0x80939964,
    0x80939978
]

WillieVoiceLines = [
    0x80948a7c,
    0x80948a90,
    0x80948a40,
    0x80948a54,
    0x80948a68
]

CurrentVoiceline = dword_be(VoicelinePointer + 0x44) 

function CheckVoicelineArray()
{
    for voiceline in LardLadVoicelines 
    { 
        return once(CurrentVoiceline == voiceline)
    }
}

function LardLadDoorbellRang() => LevelID == 0x00 && any_of(LardLadVoicelines, vl => vl == CurrentVoiceline)
function SkinnerDoorbellRang() => LevelID == 0x00 && any_of(SkinnerVoicelines, vl => vl == CurrentVoiceline)
function QuimbyDoorbellRang(levelId) => LevelID == levelId && any_of(QuimbyVoicelines, vl => vl == CurrentVoiceline)
function SocialClubDoorbellRang(levelId) => LevelID == levelId && any_of(SocialClubVoicelines, vl => vl == CurrentVoiceline)
function KrustyDoorbellRang() => LevelID == 0x02 && any_of(KrustyVoicelines, vl => vl == CurrentVoiceline)
function MoeDoorbellRang() => LevelID == 0x03 && any_of(MoeVoicelines, vl => vl == CurrentVoiceline)
function NelsonDoorbellRang(levelId) => LevelID == levelId && any_of(NelsonVoiceline, vl => vl == CurrentVoiceline)
function FlandersDoorbellRang() => LevelID == 0x03 && any_of(FlandersVoiceline, vl => vl == CurrentVoiceline)
function DrNickDoorbellRang() => LevelID == 0x04 && any_of(DrNickVoicelines, vl => vl == CurrentVoiceline)
function RalphDoorbellRang() => LevelID == 0x06 && any_of(RalphVoiceLines, vl => vl == CurrentVoiceline)
function CletusDoorbellRang() => LevelID == 0x06 && any_of(CletusVoiceLines, vl => vl == CurrentVoiceline)
function WillieDoorbellRang() => LevelID == 0x06 && any_of(WillieVoiceLines, vl => vl == CurrentVoiceline)

achievement(
    title = "Ding Dong Ditch Speedrunner",
    description = "Starting at Lard Lad in Level 1, ring every doorbell in under xx:xx",
    points = 25,
    trigger = (
        CheatCheck() &&
        once(LardLadDoorbellRang()) &&
        trigger_when(
            once(SkinnerDoorbellRang()) &&
            once(QuimbyDoorbellRang(0x00)) &&
            once(SocialClubDoorbellRang(0x01)) &&
            once(KrustyDoorbellRang()) &&
            once(MoeDoorbellRang()) &&
            once(NelsonDoorbellRang(0x03)) &&
            once(QuimbyDoorbellRang(0x03)) &&
            once(FlandersDoorbellRang()) &&
            once(SocialClubDoorbellRang(0x04)) &&
            once(DrNickDoorbellRang()) &&
            once(NelsonDoorbellRang(0x06)) &&
            once(RalphDoorbellRang()) &&
            once(CletusDoorbellRang()) &&
            once(WillieDoorbellRang())
            ) &&
        never(GameState <= 0x07) &&
        disable_when(
            tally(600, GameState >= 0x09 && once(LardLadDoorbellRang())
            ), never(GameState == 0x02))
    )
)