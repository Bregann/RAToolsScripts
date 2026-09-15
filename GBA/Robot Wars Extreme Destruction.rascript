// Robot Wars: Extreme Destruction
// #ID = 5285

function CurrentMode() => byte(0x026d20)
function HasWonGame(mode) => byte(0x00cc6c) == 0x01 && CurrentMode() == mode

// ========= Progression =========
function Progression(achTitle, achDesc, points, awardType, modeName, modeHex) {
  achievement(
    title = achTitle,
    description = "Win the " + awardType+ " award" + "in the " + "\"" + modeName + "\"" + " mode"
    points = points,
    type = "PROGRESSION",
    trigger = (
      HasWonGame(modeHex) &&
      
    )
  )
}