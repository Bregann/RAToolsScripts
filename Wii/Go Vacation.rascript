// Go Vacation
// #ID = 35935

OFFSET = 0x11A0
function IsInGame() => dword_be(0x1001eb50) != 0xffffff00

// Dictionaries
function CalculateOffsetAndReturnAddress(baseAddr){
  dict = {}

  for i in range(0, 7) {
    dict[i + 1] = baseAddr + (i * OFFSET)
  }

  return dict
}

function BadgeAchievement(achTitle, minigameName, badgeDict){
  achievement(
    title = achTitle,
    description = "badge",
    points = 3,
    type = "PROGRESSION",
    trigger = (
      IsInGame() &&
      any_of(badgeDict, addr =>
        bit7(badgeDict[addr]) == 1 &&
        prev(bit7(badgeDict[addr])) == 0
      )
    )
  )
}

idk = CalculateOffsetAndReturnAddress(0x1003d0bd)
BadgeAchievement("Marine Racer", "Marine Bike", idk)