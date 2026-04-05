// Horrible Histories: Ruthless Romans
// #ID = 35209

function IsInGame() => dword_be(0x00403e2c) != 0x00

// -------------------- Progression --------------------

function ProgressionAchievement(achTitle, championName, progressionHex){
  achievement(
    title = achTitle,
    description = "Defeat the " + "\"" + championName + "\"" + " gladiator in the Colosseum in story mode",
    points = 5,
    type = "PROGRESSION",
    trigger = (
      IsInGame() &&
      dword_be(0x0031a264) == progressionHex &&
      prev(dword_be(0x0031a264)) == progressionHex - 1
    )
  )
}

ProgressionAchievement("Net Ripper", "Retiarii", 0x04)
ProgressionAchievement("A Beastly Encounter", "Bestiarii", 0x07)
ProgressionAchievement("Blind Victory", "Andabatae", 0x0a)
ProgressionAchievement("No More Noose", "Laqueatores", 0x0d)
ProgressionAchievement("Dual Wield Down", "Dimacheri", 0x10)
ProgressionAchievement("Armoured Up", "Secutores", 0x13)
ProgressionAchievement("Hoplomachi Defeated", "Hoplomachi", 0x16)
ProgressionAchievement("Arrow to the Knee", "Sagittarii", 0x19)

achievement(
  title = "The Colosseum Conqueror",
  description = "Defeat the " + "\"" + "Champion of Champions" + "\"" + " in the Colosseum in story mode",
  points = 5,
  type = "WIN_CONDITION",
  trigger = (
    IsInGame() &&
    dword_be(0x0031a478) == 0x01 &&
    prev(dword_be(0x0031a478) == 0x00)
  )
)

achievement(
  title = "Unlocking the Guild",
  description = "Solve the puzzle to unlock the merchant's guild door",
  points = 2,
  trigger = (
    IsInGame() &&
    dword_be(0x0031a288) == 0x04 &&
    prev(dword_be(0x0031a288)) == 0x03
  )
)

achievement(
  title = "Return of the Stolen Sword",
  description = "Return the Emperor's sword back to the blacksmith",
  points = 2,
  trigger = (
    IsInGame() &&
    dword_be(0x0031a288) == 0x06 &&
    prev(dword_be(0x0031a288)) == 0x05
  )
)

achievement(
  title = "It's a Feast!",
  description = "Unlock the feast building",
  points = 2,
  trigger = (
    IsInGame() &&
    dword_be(0x0031a27c) == 0x05 &&
    prev(dword_be(0x0031a27c)) == 0x04
  )
)

achievement(
  title = "Family News",
  description = "Update Cornelia with the news about her parents",
  points = 2,
  trigger = (
    IsInGame() &&
    dword_be(0x0031a274) == 0x04 &&
    prev(dword_be(0x0031a274)) == 0x03
  )
)

achievement(
  title = "Sewer Escape",
  description = "Talk with Cornelia after navigating through the sewers",
  points = 2,
  trigger = (
    IsInGame() &&
    dword_be(0x0031a2b4) == 0x01 &&
    prev(dword_be(0x0031a2b4)) == 0x00
  )
)