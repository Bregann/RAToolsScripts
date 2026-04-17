// Golden Balls
// #ID = 35164

RA_MASK = 0x1FFFFFFF

function ChainPointer(base, offsets, accessor=dword_be)
{
    val = base
    val = val & RA_MASK
    
    for i in range(0, length(offsets) - 1)
    {
        addr = val + offsets[i]
        if (i == length(offsets) - 1)
        {
            val = accessor(addr)
        }
        else
        {
            val = dword_be(addr)
            val = val & RA_MASK
        }
    }
    
    return val
}

function IsInGame() => dword_be(0x104418a0) == 0x02 && dword_be(0x104411c0) == 0x01
function PlayersLeft() => dword_be(0x104424e0)

HonestyPointer = dword_be(0x0020abcc) & 0x1fffffff
function HonestySelected() => dword_be(HonestyPointer + 0x1ad0)
function HonestyLockedIn() => dword_be(HonestyPointer + 0x1af0)

function Jackpot() => ChainPointer(dword_be(0x0020a664), [0x98C, 0x00])

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
      (
        dword_be(0x10441184) == aiOpt ||
        dword_be(0x10441188) == aiOpt ||
        dword_be(0x1044118c) == aiOpt
      ) &&
      prev(dword_be(0x10441180)) == 0xffffffff
    )
  )
}

EndingAchievement("Splitting the Spoils", "Win the final jackpot by both players choosing the split ball", "WIN_CONDITION", 0x00, 0x00)
EndingAchievement("I'm Going to Steal", "Win the final jackpot by choosing the steal ball while your opponent chooses the split ball", "WIN_CONDITION", 0x01, 0x00)
EndingAchievement("What a Waste of Time!", "Finish the game with no winnings after both players choose the steal ball", "", 0x01, 0x01)
EndingAchievement("Total Betrayal", "Lose the final jackpot after choosing the split ball while your opponent chooses the steal ball", "", 0x00, 0x01)

// -------------------- Challenges --------------------
function BallsSelected() => ChainPointer(dword_be(0x0020a664), [0x1664, 0x00])

function Ball1() => ChainPointer(dword_be(0x0020a664), [0x167C, 0x00])
function Ball2() => ChainPointer(dword_be(0x0020a664), [0x167C, 0x04])
function Ball3() => ChainPointer(dword_be(0x0020a664), [0x167C, 0x08])
function Ball4() => ChainPointer(dword_be(0x0020a664), [0x167C, 0x0c])
function Ball5() => ChainPointer(dword_be(0x0020a664), [0x167C, 0x10])

achievement(
  title = "Killing the Killers",
  description = "Fill the final five jackpot slots using only cash balls and no killer balls",
  points = 5,
  trigger = (
    IsInGame() &&
    BallsSelected() == 0x05 &&
    prev(BallsSelected()) == 0x04 &&
    Ball1() != 0x00 &&
    Ball2() != 0x00 &&
    Ball3() != 0x00 &&
    Ball4() != 0x00 &&
    Ball5() != 0x00
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
      !IsInGame() 
      ||
      (
        HonestyLockedIn() == 0xffffffff &&
        (
          HonestySelected() == 0x00 
          || 
          HonestySelected() == 0xffffffff
        )
      )
    ) &&
    trigger_when(
      dword_be(0x10441180) == 0x01 &&
      (
        dword_be(0x10441184) == 0x00 ||
        dword_be(0x10441188) == 0x00 ||
        dword_be(0x1044118c) == 0x00
      ) &&
      prev(dword_be(0x10441180)) == 0xffffffff
    )
  )
)

achievement(
  title = "Honesty Is the Best Policy",
  description = "Split the jackpot after telling the truth in every previous round",
  points = 5,
  trigger = (
    once(
      IsInGame() &&
      PlayersLeft() == 0x04 &&
      HonestyLockedIn() == 0x01
    ) &&
    never(
      !IsInGame() 
      ||
      (
        HonestyLockedIn() == 0xffffffff &&
        (
          HonestySelected() == 0x01 
          || 
          HonestySelected() == 0x02 
          || 
          HonestySelected() == 0x03
        )
      )
    ) 
    &&
    trigger_when(
      dword_be(0x10441180) == 0x00 &&
      (
        dword_be(0x10441184) == 0x00 ||
        dword_be(0x10441188) == 0x00 ||
        dword_be(0x1044118c) == 0x00
      ) &&
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
    (
      dword_be(0x10441184) == 0x00 ||
      dword_be(0x10441188) == 0x00 ||
      dword_be(0x1044118c) == 0x00
    ) &&
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
    (
      dword_be(0x10441184) == 0x00 ||
      dword_be(0x10441188) == 0x00 ||
      dword_be(0x1044118c) == 0x00
    )
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
    (
      dword_be(0x10441184) == 0x00 ||
      dword_be(0x10441188) == 0x00 ||
      dword_be(0x1044118c) == 0x00
    )
  ),
  value = Jackpot()
)

// -------------------- RP --------------------
function IsLoading() => dword_be(0x104418a0) == 0x00 || dword_be(0x104418a0) == 0xffffffff

Names = {
  0x00: "Steve",
  0x01: "Ron",
  0x02: "Guy",
  0x03: "Toby",
  0x04: "Reginald",
  0x05: "Sylvester",
  0x06: "Mo",
  0x07: "Sam",
  0x08: "Sanjiev",
  0x09: "Amy",
  0x0a: "Yvonne",
  0x0b: "Jamie",
  0x0c: "Tammy",
  0x0d: "Sylvia",
  0x0e: "Rose",
  0x0f: "Estelle",
  0x10: "Philippe",
  0x11: "Ken",
  0x12: "Naomi",
  0x13: "Kim"
}

function Fallback() => "£"

rich_presence_conditional_display(IsLoading(), "Booting up Golden Balls...")
rich_presence_conditional_display(dword_be(0x104418a0) == 0x01, "Browsing the Menus")
rich_presence_conditional_display(
  dword_be(0x104418a0) == 0x02 && dword_be(0x104411c0) == 0x01, 
  "In a one player game of Golden Balls against {0}, {1} & {2}",
  rich_presence_lookup("PlayerNames", dword_be(0x10442264), Names),
  rich_presence_lookup("PlayerNames", dword_be(0x10442268), Names),
  rich_presence_lookup("PlayerNames", dword_be(0x1044226c), Names)
)
rich_presence_conditional_display(
  dword_be(0x104418a0) == 0x02 && dword_be(0x104411c0) == 0x01, 
  "In a two player game of Golden Balls"
)
rich_presence_display("Playing Golden Balls")