// Transformers: The Game
// #ID = 21166

CurrentLevel = byte(0x00503c24)
ChapterCompleteShowing = byte(0x00c29f9c)

function ChapterComplete(achTitle, achDesc, points, achType, levelId, chaptersCompleteId, chaptersComplete)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        type = achType,
        trigger = (
            CurrentLevel == levelId &&
            chaptersCompleteId == chaptersComplete &&
            prev(chaptersCompleteId) == chaptersComplete - 1
        )
    )
}

function FinalLevelComplete(achTitle, achDesc, points, achType, levelId)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        type = achType,
        trigger = (
            CurrentLevel == levelId &&
            ChapterCompleteShowing == 0x01 &&
            prev(ChapterCompleteShowing) == 0x00
        )
    )
}

// Autobot missions
ChapterComplete("The Decepticons Have Arrived", "Complete mission \"Uninvited Guests\"", 5, "PROGRESSION", 0x00, byte(0x00cfaf89), 1)
ChapterComplete("Chasing Down Decepticons", "Complete mission \"Guardian Angel\"", 5, "PROGRESSION", 0x00, byte(0x00cfaf89), 2)
ChapterComplete("Sound of the Police", "Complete mission \"Protect and Serve\"", 5, "PROGRESSION", 0x00, byte(0x00cfaf89), 3)
ChapterComplete("More Decepticons!", "Complete mission \"Air Traffic Control\"", 5, "PROGRESSION", 0x00, byte(0x00cfaf89), 4)

ChapterComplete("Jazz the Distractor", "Complete mission \"Obstruction of Justice\"", 5, "PROGRESSION", 0x01, byte(0x00d021b9), 1)
ChapterComplete("Protecting Jazz", "Complete mission \"A Friend in Need\"", 5, "PROGRESSION", 0x01, byte(0x00d021b9), 2)
ChapterComplete("The Bumblebee Chase", "Complete mission \"Flight of the Bumblebee\"", 5, "PROGRESSION", 0x01, byte(0x00d021b9), 3)
ChapterComplete("Destroying Shockwave", "Complete mission \"Heavy Weapon\"", 5, "PROGRESSION", 0x01, byte(0x00d021b9), 4)

ChapterComplete("I Want to Break Free!", "Complete mission \"Breakout\"", 5, "PROGRESSION", 0x02, byte(0x00d01509), 1)
ChapterComplete("Tunnel Speedster", "Complete mission \"Tunnel Vision\"", 5, "PROGRESSION", 0x02, byte(0x00d01509), 2)
ChapterComplete("Generator Destroyer", "Complete mission \"Power Drain\"", 5, "PROGRESSION", 0x02, byte(0x00d01509), 3)
ChapterComplete("Securing the AllSpark", "Complete mission \"Waking Giant\"", 5, "PROGRESSION", 0x02, byte(0x00d01509), 4)

ChapterComplete("Energon Drones? More Like Energone Drones", "Complete mission \"Exterminator\"", 5, "PROGRESSION", 0x04, byte(0x00cffba9), 1)
ChapterComplete("You're Grounded!", "Complete mission \"Unfriendly Skies\"", 5, "PROGRESSION", 0x04, byte(0x00cffba9), 2)
ChapterComplete("Brawling Brawl", "Complete mission \"For The Fallen\"", 5, "PROGRESSION", 0x04, byte(0x00cffba9), 3)
ChapterComplete("Protecting The AllSpark", "Complete mission \"Keep Away\"", 5, "PROGRESSION", 0x04, byte(0x00cffba9), 4)

FinalLevelComplete("", "Complete level \"The Ultimate Doom\"", 10, "PROGRESSION", 0x05)
FinalLevelComplete("Decepticon Battler", "Complete level \"Cybertron: Autobot\"", 5, "", 0x11)

// Decepticon missions
ChapterComplete("", "Complete mission \"Sand Storm\"", 5, "PROGRESSION", 0x06, byte(0x00cfe249), 1)
ChapterComplete("", "Complete mission \"Communications Breakdown\"", 5, "PROGRESSION", 0x06, byte(0x00cfe249), 2)
ChapterComplete("", "Complete mission \"Seek and Destroy\"", 5, "PROGRESSION", 0x06, byte(0x00cfe249), 3)
ChapterComplete("", "Complete mission \"Fire In The Sky\"", 5, "PROGRESSION", 0x06, byte(0x00cfe249), 4)

ChapterComplete("", "Complete mission \"Rough Justice\"", 5, "PROGRESSION", 0x07, byte(0x00cfbc39), 1)
ChapterComplete("", "Complete mission \"Race For Frenzy\"", 5, "PROGRESSION", 0x07, byte(0x00cfbc39), 2)
ChapterComplete("", "Complete mission \"Pursuit\"", 5, "PROGRESSION", 0x07, byte(0x00cfbc39), 3)
ChapterComplete("", "Complete mission \"Plight of the Bumblebee\"", 5, "PROGRESSION", 0x07, byte(0x00cfbc39), 4)

ChapterComplete("", "Complete mission \"Clearing The Air\"", 5, "PROGRESSION", 0x08, byte(0x00d00859), 1)
ChapterComplete("", "Complete mission \"Sinister Savior\"", 5, "PROGRESSION", 0x08, byte(0x00d00859), 2)
ChapterComplete("", "Complete mission \"Fireworks\"", 5, "PROGRESSION", 0x08, byte(0x00d00859), 3)
ChapterComplete("", "Complete mission \"Warpath\"", 5, "PROGRESSION", 0x08, byte(0x00d00859), 4)

ChapterComplete("", "Complete mission \"Nowhere To Run\"", 5, "PROGRESSION", 0x0a, byte(0x00d03b19), 1)
ChapterComplete("", "Complete mission \"Energon Overload\"", 5, "PROGRESSION", 0x0a, byte(0x00d03b19), 2)
ChapterComplete("", "Complete mission \"The Mighty Will Fall\"", 5, "PROGRESSION", 0x0a, byte(0x00d03b19), 3)
ChapterComplete("", "Complete mission \"Devastation\"", 5, "PROGRESSION", 0x0a, byte(0x00d03b19), 4)

FinalLevelComplete("", "Complete mission \"Day of the Machines\"", 10, "WIN_CONDITION", 0x0b)
FinalLevelComplete("", "Complete mission \"Cybertron: Decepticon\"", 5, "", 0x12)