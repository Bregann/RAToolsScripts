// Horrible Histories: Ruthless Romans
// #ID = 35209

function IsInGame() => dword_be(0x00403e2c) != 0x00
function Minigame() => dword_be(0x00318c88)
function Location() => dword_be(0x00403e2c)
// -------------------- Progression --------------------

function ProgressionAchievement(achTitle, championName, progressionHex){
  achievement(
    title = achTitle,
    description = "Defeat the " + "\"" + championName + "\"" + " gladiator in the Colosseum in Story mode",
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
  description = "Defeat the " + "\"" + "Champion of Champions" + "\"" + " in the Colosseum in Story mode",
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
  description = "Talk to Cornelia after navigating through the sewers",
  points = 2,
  trigger = (
    IsInGame() &&
    dword_be(0x0031a2b4) == 0x01 &&
    prev(dword_be(0x0031a2b4)) == 0x00
  )
)

// -------------------- Mini games --------------------
PlayerHealth = float_be(0x0040443c)
EnemyHealth = float_be(0x00404440)

achievement(
  title = "Are You Not Entertained?!",
  description = "Defeat any gladiator in the Colosseum in 2 hits",
  points = 5,
  trigger = (
    once(
      Minigame() == 0x20 &&
      PlayerHealth == 0.0 &&
      EnemyHealth == 0.0
    ) &&
    never(
      Minigame() != 0x20 ||
      tally(2, EnemyHealth > prev(EnemyHealth) && EnemyHealth != 99.0)
    ) &&
    trigger_when(
      EnemyHealth == 99.0
    )
  )
)

Minigames = {
  0x02: "Fishing",
  0x03: "Pour Wine",
  0x04: "Sort Fruit",
  0x05: "Andabatae",
  0x06: "Sagittarii",
  0x07: "Hammer",
  0x08: "Hoplomachi",
  0x09: "Memory",
  0x0b: "Laqueatores",
  0x0c: "Retiarii",
  0x0d: "Dimacheri",
  0x0e: "Bottles",
  0x0f: "Invitations",
  0x10: "Strongbox",
  0x11: "Loaves",
  0x12: "Hidden Keys",
  0x13: "Rats",
  0x14: "Emperor",
  0x15: "Rodents",
  0x16: "Details",
  0x17: "Bestiarii",
  0x18: "Potion",
  0x1a: "Training",
  0x1c: "The Box",
  0x1d: "Rings",
  0x1f: "Senator"
}

MinigameSecs = dword_be(0x004030bc)
MinigameMins = dword_be(0x004030b8)
MinigamePoints = dword_be(0x00355d90)

function MinigameAchievement(achTitle, pointsAmount, minigameName, minigameId){
  achievement(
    title = achTitle,
    description = "Score " + pointsAmount + " points or higher in the " + "\"" + minigameName + "\"" + " minigame in Minigames mode",
    points = 5,
    trigger = (
      Minigame() == minigameId &&
      (
        MinigameMins > 0 ||
        MinigameSecs > 0
      ) &&
      Location() == 0x00 &&
      trigger_when(
        MinigamePoints >= pointsAmount &&
        prev(MinigamePoints) < pointsAmount &&
        MinigamePoints < 1000000 // the minigame points will never be this high but when in a minus value it overflows...
      )
    )
  )
}

function MinigameLeaderboard(minigameName, minigameId){
  leaderboard(
    title = minigameName + " Minigame",
    description = "Earn the highest amount of points in the minigame in Minigames mode",
    start = (
      Location() == 0x00 &&
      Minigame() == minigameId &&
      (
        MinigameSecs > 0 ||
        MinigameMins > 0
      ) &&
      MinigamePoints == 0
    ),
    cancel = (
      Minigame() != minigameId
    ),
    submit = (
      MinigameSecs == 0 &&
      MinigameMins == 0 &&
      Minigame() == minigameId &&
      MinigamePoints > 0 &&
      MinigamePoints < 1000000 // the minigame points will never be this high but when in a minus value it overflows...
    ),
    value = MinigamePoints
  )
}

achievement(
  title = "Blocking & Slashing",
  description = "Complete the " + "\"" + "Secutores" + "\"" + " minigame in Minigames mode without ever losing any points",
  points = 5,
  trigger = (
    once(
      Location() == 0x00 &&
      Minigame() == 0x19 &&
      MinigameMins == 1 &&
      MinigameSecs == 30 &&
      MinigamePoints == 0
    ) &&
    never(
      MinigamePoints < prev(MinigamePoints) || 
      MinigamePoints > 1000000 // the minigame points will never be this high but when in a minus value it overflows...
    ) &&
    trigger_when(
      MinigameMins == 0 &&
      MinigameSecs == 0 &&
      MinigamePoints > 1
    )
  )
)

achievement(
  title = "One Wise Roman",
  description = "Complete the " + "\"" + "Quiz" + "\"" + " minigame in Minigames mode after getting every question correct",
  points = 5,
  trigger = (
    once(
      Location() == 0x00 &&
      Minigame() == 0x0a &&
      MinigamePoints == 0 &&
      byte(0x00404719) <= 1
    ) &&
    never(
      Minigame() != 0x0a ||
      MinigamePoints < prev(MinigamePoints) || 
      MinigamePoints > 1000000 // the minigame points will never be this high but when in a minus value it overflows...
    ) &&
    trigger_when(
      MinigamePoints >= 50 &&
      prev(MinigamePoints) < 50
    )
  )
)

achievement(
  title = "Bestiarii Beast",
  description = "Score 300 points or higher in the " + "\"" + "Bestiarii" + "\"" + " minigame in Minigames mode",
  points = 5,
  trigger = (
    Location() == 0x00 &&
    Minigame() == 0x17 &&
    trigger_when(
      MinigamePoints >= 300 &&
      prev(MinigamePoints) < 300 &&
      MinigamePoints < 1000000 // the minigame points will never be this high but when in a minus value it overflows...
    )
  )
)

MinigameAchievement("Andabatae Master", 90, "Andabatae", 0x05)
MinigameAchievement("Dimacheri Dominator", 175, "Dimacheri", 0x0d)
MinigameAchievement("Apple Organiser", 320, "Sort Fruit", 0x04)
MinigameAchievement("Strongbox Cracker", 195, "Strongbox", 0x10)
MinigameAchievement("Bottle Spotter", 141, "Bottles", 0x0e)
MinigameAchievement("Eye for Detail", 165, "Details", 0x16)
MinigameAchievement("Ring Puller", 200, "Rings", 0x1d)
MinigameAchievement("Oh Rats!", 300, "Rats", 0x13)
MinigameAchievement("Box Solver", 290, "The Box", 0x1c)

for i in Minigames{
  MinigameLeaderboard(Minigames[i], i)
}

// -------------------- RP --------------------

MinigameRP = {
  0x00: "In game",
  0x01: "In the menus",
  0x02: "Fishing",
  0x03: "Pour Wine",
  0x04: "Sort Fruit",
  0x05: "Andabatae",
  0x06: "Sagittarii",
  0x07: "Hammer",
  0x08: "Hoplomachi",
  0x09: "Memory",
  0x0a: "Quiz",
  0x0b: "Laqueatores",
  0x0c: "Retiarii",
  0x0d: "Dimacheri",
  0x0e: "Bottles",
  0x0f: "Invitations",
  0x10: "Strongbox",
  0x11: "Loaves",
  0x12: "Hidden Keys",
  0x13: "Rats",
  0x14: "Emperor",
  0x15: "Rodents",
  0x16: "Details",
  0x17: "Bestiarii",
  0x18: "Potion",
  0x19: "Secutores",
  0x1a: "Training",
  0x1c: "The Box",
  0x1d: "Rings",
  0x1e: "Chariots",
  0x1f: "Senator",
  0x20: "Retiarii Fight"
}

Location = {
  0x16: "the Dorm Rooms",
  0x17: "the School Garden",
  0x18: "the Training Arena",
  0x19: "the Classroom",
  0x1a: "Rome",
  0x1c: "the Feast Building",
  0x1d: "the Underworld",
  0x1e: "the Rome Suburbs",
  0x1f: "the Market",
  0x20: "the Merchant's Guild",
  0x21: "the Guild Corridor",
  0x22: "the Guild Warehouse",
  0x23: "the Temple",
  0x24: "the Baths",
  0x25: "the Games Inn",
  0x26: "Sewer West",
  0x27: "Sewer East",
  0x28: "Sewer Labyrinth",
  0x29: "the Colosseum Tunnel"
}

rich_presence_conditional_display(Minigame() == 0x01, "Browsing the menus")
rich_presence_conditional_display(Minigame() > 0x01, "Rassimus is playing in the {0} minigame!",
  rich_presence_lookup("Minigame", Minigame(), MinigameRP)
)
rich_presence_conditional_display(Location() > 0x01 && Minigame() == 0x00, "Rassimus is exploring {0}!",
  rich_presence_lookup("Location", Location(), Location)
)
rich_presence_display("Playing Horrible Histories: Ruthless Romans")