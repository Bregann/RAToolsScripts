// Wacky World of Sports
// #ID = 36112


// -------------------- Progression --------------------
function InTourProgression(tour) => dword_be(0x005958a8) == tour && dword_be(0x0059591c) == tour && dword_be(0x00595880) != 0

function ProgressionAchievement(achTitle, tourName, points, progType, tourId, miiBit){
  achievement(
    title = achTitle,
    description = "Earn the medal in the " + "\"" + tourName + "\"" + " tour",
    points = points,
    type = progType,
    trigger = (
      InTourProgression(tourId) &&
      miiBit = 1 &&
      prev(miiBit) == 0
    )
  )
}

ProgressionAchievement("Norland", "Norland", 5, "PROGRESSION", 0x00, bit2(0x00473e52))
ProgressionAchievement("A Fishy Tour", "Big Fish", 5, "PROGRESSION", 0x01, bit6(0x00473e53))
ProgressionAchievement("Household Name", "Household", 5, "PROGRESSION", 0x02, bit0(0x00473e51))
ProgressionAchievement("Afterburners Engage!", "Knockout", 5, "PROGRESSION", 0x03, bit4(0x00473e52))
ProgressionAchievement("A Heart-breaking Defeat", "Dark Destroyer", 5, "PROGRESSION", 0x04, bit6(0x00473e52))
ProgressionAchievement("Desert Domination", "Hot Sands", 5, "PROGRESSION", 0x05, bit6(0x00473e51))
ProgressionAchievement("Funk Master Outta Here", "Dancing Assassin", 5, "PROGRESSION", 0x06,bit2(0x00473e51))
ProgressionAchievement("A Muddy Victory", "Red Rose", 5, "PROGRESSION", 0x07, bit0(0x00473e52))
ProgressionAchievement("A Defeated King", "Invincible", 10, "WIN_CONDITION", 0x08, bit4(0x00473e51))

// -------------------- Purchases --------------------
PolesPurchased = 
bit7(0x00473e47) + bit0(0x00473e46) +
bit1(0x00473e46) + bit2(0x00473e46)

FishPurchased = 
bit7(0x00473e43) + bit0(0x00473e42) +
bit1(0x00473e42) + bit2(0x00473e42)

FurnitureCarsPurchased = 
bit0(0x00473e3d) + bit7(0x00473e3e) +
bitcount(0x00473e3d) + bit0(0x00473e3c) + 
bit1(0x00473e3c) + bit2(0x00473e3c) +
bit3(0x00473e3c) + bit4(0x00473e3c)

AxesPurchased = 
bit7(0x00473e49) + bit0(0x00473e48) +
bit1(0x00473e48) + bit2(0x00473e48) +
bit3(0x00473e48) + bit4(0x00473e48)

CheesePurchased = 
bit7(0x00473e4b) + bit0(0x00473e4a) +
bit1(0x00473e4a) + bit2(0x00473e4a) +
bit3(0x00473e4a) + bit4(0x00473e4a)

LawnmowersPurchased = 
bit7(0x00473e45) + bit0(0x00473e44) +
bit1(0x00473e44) + bit2(0x00473e44)

DefensiveItemsPurchased = 
bit7(0x00473e41) + bit0(0x00473e40) +
bit1(0x00473e40) + bit2(0x00473e40) +
bit3(0x00473e40) + bit4(0x00473e40)

GolfBallsPurchased = 
bit7(0x00473e4f) + bit0(0x00473e4e) +
bit1(0x00473e4e) + bit2(0x00473e4e)