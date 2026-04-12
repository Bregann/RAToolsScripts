// Golden Balls
// #ID = 35164

function IsInGame() => dword_be(0x104418a0) == 0x02 && dword_be(0x104411c0) == 0x01
function PlayersLeft() => dword_be(0x104424e0)
function HonestyLockedIn() => dword_be(0x10525e00)
function HonestySelected() => dword_be(0x10525de0)
function Jackpot() => dword_be(0x10523980)

// -------------------- Progression --------------------
achievement(
  title = "Avoiding the Bin",
  description = "Survive the round 1 vote-off",
  points = 2,
  type = "PROGRESSION",
  trigger = (
    IsInGame() &&
    PlayersLeft() == 0x03 &&
    prev(PlayersLeft()) == 0x04
  )
)

achievement(
  title = "Time to Bin or Win",
  description = "Survive the round 2 vote-off",
  points = 3,
  type = "PROGRESSION",
  trigger = (
    IsInGame() &&
    PlayersLeft() == 0x02 &&
    prev(PlayersLeft()) == 0x03
  )
)

function EndingAchievement(achTitle, achDesc, achType, playerOpt, aiOpt){
  achievement(
    title = achTitle,
    description = achDesc,
    points = 5,
    type = achType,
    trigger = (
      IsInGame() &&
      dword_be(0x10441180) == playerOpt &&
      dword_be(0x10441188) == aiOpt &&
      prev(dword_be(0x10441180)) == 0xffffffff
    )
  )
}

EndingAchievement("Splitting the Spoils", "Win the final jackpot by both players choosing the split ball", "WIN_CONDITION", 0x00, 0x00)
EndingAchievement("I'm Going to Steal", "Win the final jackpot by choosing the steal ball while your opponent chooses the split ball", "WIN_CONDITION", 0x01, 0x00)
EndingAchievement("What a Waste of Time!", "Finish the game with no winnings after both players choose the steal ball", "", 0x01, 0x01)
EndingAchievement("Total Betrayal", "Lose the final jackpot after choosing the split ball while your opponent chooses the steal ball", "", 0x00, 0x01)

// -------------------- Challenges --------------------
achievement(
  title = "Killing the Killers",
  description = "Fill the final five jackpot slots using only cash balls",
  points = 5,
  trigger = (
    IsInGame() &&
    dword_be(0x10525680) == 0x05 &&
    prev(dword_be(0x10525680)) == 0x04 &&
    dword_be(0x105256a0) != 0x00 &&
    dword_be(0x105256a4) != 0x00 &&
    dword_be(0x105256a8) != 0x00 &&
    dword_be(0x105256ac) != 0x00 &&
    dword_be(0x105256b0) != 0x00
  )
)

achievement(
  title = "The Master Liar",
  description = "Win the jackpot by choosing the steal ball after bluffing in every previous round",
  points = 5,
  trigger = (
    once(
      IsInGame() &&
      PlayersLeft() == 0x04 &&
      HonestyLockedIn() == 0x01
    ) &&
    never(
      (
        (
          HonestySelected() == 0x00 
          || 
          HonestySelected() == 0xffffffff
        ) 
        &&
        HonestyLockedIn() == 0xffffffff
      ) ||
      !IsInGame()
    ) &&
    trigger_when(
      dword_be(0x10441180) == 0x01 &&
      dword_be(0x10441188) == 0x00 &&
      prev(dword_be(0x10441180)) == 0xffffffff
    )
  )
)

achievement(
  title = "Honesty is the Best Policy",
  description = "Split the jackpot after telling the truth in every previous round",
  points = 5,
  trigger = (
    once(
      IsInGame() &&
      PlayersLeft() == 0x04 &&
      HonestyLockedIn() == 0x01
    ) &&
    never(
      (
        (
          HonestySelected() != 0x00 
          || 
          HonestySelected() != 0xffffffff
        ) 
        &&
        HonestyLockedIn() == 0xffffffff
      ) ||
      !IsInGame()
    ) 
    &&
    trigger_when(
      dword_be(0x10441180) == 0x00 &&
      dword_be(0x10441188) == 0x00 &&
      prev(dword_be(0x10441180)) == 0xffffffff
    )
  )
)

achievement(
  title = "A Ballsy Move",
  description = "Steal a jackpot of £20,000 or higher",
  points = 10,
  trigger = (
    IsInGame() &&
    Jackpot() >= 20000 &&
    dword_be(0x10441180) == 0x01 &&
    dword_be(0x10441188) == 0x00 &&
    prev(dword_be(0x10441180)) == 0xffffffff
  )
)

leaderboard(
  title = "Jackpot Amount Won - Splitting",
  description = "Win the highest amount by splitting the jackpot",
  start = (
    IsInGame()
  ),
  cancel = (
    !IsInGame()
  ),
  submit = (
    prev(dword_be(0x10441180)) == 0xffffffff &&
    dword_be(0x10441180) == 0x00 &&
    dword_be(0x10441188) == 0x00
  ),
  value = Jackpot()
)

leaderboard(
  title = "Jackpot Amount Won - Stealing",
  description = "Win the highest amount by stealing the jackpot",
  start = (
    IsInGame()
  ),
  cancel = (
    !IsInGame()
  ),
  submit = (
    prev(dword_be(0x10441180)) == 0xffffffff &&
    dword_be(0x10441180) == 0x01 &&
    dword_be(0x10441188) == 0x00
  ),
  value = Jackpot()
)

// -------------------- RP --------------------
function IsLoading() => dword_be(0x104418a0) == 0x00 || dword_be(0x104418a0) == 0xffffffff

Names = {

}

function Fallback() => "£"

rich_presence_conditional_display(IsLoading(), "Booting up Golden Balls...")
rich_presence_conditional_display(dword_be(0x104418a0) == 0x01, "Browsing the Menus")
rich_presence_conditional_display(
  dword_be(0x104418a0) == 0x02 && dword_be(0x10440d50) == 0x00, 
  "In game against {0}, {1}, {2}",
  rich_presence_lookup("PlayerNames", dword_be(), Names)
)
rich_presence_display("temp")