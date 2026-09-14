// Wacky World of Sports
// #ID = 36112


// -------------------- Progression --------------------
function InTourProgression(tour) => prior(dword_be(0x005958a8)) == tour && prior(dword_be(0x00595880)) != 0
function IsInGame(gameId) => word(0x00473dd2) == gameId
function SubMinigame(sub) => word(0x00473dd4) == sub
function PlayerAntiCheat() => byte(0x00383101) == 0xff && byte(0x00383102) == 0xff && byte(0x00383103) == 0xff

PlayerMoney = dword_be(0x005958cc)

function ProgressionAchievement(achTitle, tourName, points, progType, tourId, miiBit){
  achievement(
    title = achTitle,
    description = "Earn the medal in the " + "\"" + tourName + "\"" + " tour",
    points = points,
    type = progType,
    trigger = (
      InTourProgression(tourId) &&
      miiBit == 1 &&
      prev(miiBit) == 0
    )
  )
}

ProgressionAchievement("Beginners Tour", "Norland", 5, "PROGRESSION", 0x00, bit2(0x00473e52))
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
bit7(0x00473e3e) +bit0(0x00473e3c) + 
bitcount(0x00473e3d) + 
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

MiiMasks = 
bit6(0x00473e4c) + bit7(0x00473e4c) +
bitcount(0x00473e51) +
bitcount(0x00473e52) +
bitcount(0x00473e53)

function PurchaseAchievement(achTitle, categoryName, points, shopStuff, shopStuffAmount){
  achievement(
    title = achTitle,
    description = "Purchase all of the items in the " + "\"" + categoryName + "\"" + " category",
    points = points,
    trigger = (
      shopStuff == shopStuffAmount &&
      prev(shopStuff) == shopStuffAmount - 1 &&
      PlayerMoney < prior(PlayerMoney)
    )
  )
}

PurchaseAchievement("Pole Purchaser", "Poles", 4, PolesPurchased, 4)
PurchaseAchievement("Fishy Deals", "Tunas", 4, FishPurchased, 4)
PurchaseAchievement("Garage of Whacky Cars", "Furniture Cars", 10, FurnitureCarsPurchased, 14)
PurchaseAchievement("Timberrr!", "Axes", 5, AxesPurchased, 6)
PurchaseAchievement("Ready to Roll", "Cheeses", 5, CheesePurchased, 6)
PurchaseAchievement("Chopping up the Competition", "Blades", 4, LawnmowersPurchased, 4)
PurchaseAchievement("Well Protected", "Defensive Items", 5, DefensiveItemsPurchased, 6)
PurchaseAchievement("Hole-in-one Ready!", "Golf Balls", 4, GolfBallsPurchased, 4)
PurchaseAchievement("A Brand New Person", "Mii Masks", 25, MiiMasks, 26)

// -------------------- Challenges --------------------
FierljeppenR1 = float_be(0x00c47a20)
FierljeppenR2 = float_be(0x00c47a30)
FierljeppenR3 = float_be(0x00c47a40)
FierljeppenTotal = FierljeppenR1 + FierljeppenR2 + FierljeppenR3

TunaTossingScore = float_be(0x00595504)

LogCuttingScore = dword_be(0x005954d4)

achievement(
  title = "Fierljeppen Master",
  description = "Score a total of 130m or higher in the \"Fierljeppen\" game mode",
  points = 10,
  trigger = (
    IsInGame(0x400) &&
    FierljeppenTotal >= 129.99 &&
    prev(FierljeppenTotal) < 129.99
  )
)

achievement(
  title = "Fin-tastic Flight",
  description = "Throw a fish 210m or further in the \"Tuna Tossing\" game mode",
  points = 5,
  trigger = (
    IsInGame(0x200) &&
    TunaTossingScore >= 209.99 &&
    prev(TunaTossingScore) < 209.99
  )
)

achievement(
  title = "I'm a Lumberjack and I'm OK",
  description = "Score 35 points or higher in the \"Log Cutting\" game mode",
  points = 10,
  trigger = (
    IsInGame(0x600) &&
    LogCuttingScore == 35 &&
    prev(LogCuttingScore) == 34
  )
)

CheeseSections = [
  0x00595520, 0x00595524, 0x00595528, 0x0059552c, 0x00595530, 
  0x00595534, 0x00595538, 0x0059553c, 0x00595540, 0x00595544, 0x00595548, 
  0x0059554c, 0x00595550, 0x00595554, 0x00595558, 0x0059555c, 0x00595560, 
  0x00595564, 0x00595568, 0x0059556c, 0x00595570, 0x00595574, 0x00595578, 
  0x0059557c, 0x00595580, 0x00595584, 0x00595588, 0x0059558c, 0x00595590, 
  0x00595594, 0x00595598, 0x0059559c, 0x005955a0, 0x005955a4, 0x005955a8, 
  0x005955ac, 0x005955b0, 0x005955b4, 0x005955b8, 0x005955bc, 0x005955c0, 
  0x005955c4, 0x005955c8, 0x005955cc, 0x005955d0, 0x005955d4, 0x005955d8, 
  0x005955dc
]

achievement(
  title = "Big Cheese",
  description = "Complete a perfect roll in the \"Cheese Rolling\" game mode",
  points = 5,
  trigger = (
    IsInGame(0x900) &&
    dword_be(0x00595484) == 0x00 &&
    all_of(CheeseSections, cs => dword_be(cs) != 0xffffffff && dword_be(cs) != 0x00) &&
    any_of(CheeseSections, cs => prev(dword_be(cs)) == 0xffffffff)
  )
)

P1LawnmowerScore = dword_be(0x00595500)
P2LawnmowerScore = dword_be(0x00595504)
P3LawnmowerScore = dword_be(0x00595508)
P4LawnmowerScore = dword_be(0x0059550c)
LawnmowerFrames = dword_be(0x005954f0)

achievement(
  title = "Mowing Away the Competition",
  description = "Win a match in Greenhenge in the \"Lawnmower Racing\" game mode without losing any points",
  points = 10,
  trigger = (
    IsInGame(0x100) &&
    SubMinigame(0x100) &&
    PlayerAntiCheat() &&
    once(
      LawnmowerFrames == 2700
    ) &&
    never(
      P1LawnmowerScore < prev(dword_be(0x00595500)) ||
      word(0x00473dd2) != 0x100
    ) &&
    trigger_when(
      LawnmowerFrames == 0 &&
      prev(dword_be(0x005954f0)) == 1 &&
      P1LawnmowerScore > P2LawnmowerScore &&
      P1LawnmowerScore > P3LawnmowerScore &&
      P1LawnmowerScore > P4LawnmowerScore
    )
  )
)

achievement(
  title = "Pair Pro",
  description = "Win a match in the \"Card Boxing\" game mode by finding 7 pairs of cards",
  points = 10,
  trigger = (
    IsInGame(0x500) &&
    PlayerAntiCheat() &&
    dword_be(0x0059550c) == 0x07 &&
    prev(dword_be(0x0059550c)) == 0x06
  )
)

achievement(
  title = "A Muddy Masterpiece",
  description = "Score 13,000 points or higher in the \"Mud Slide Rally\" game mode",
  points = 10,
  trigger = (
    IsInGame(0x800) &&
    dword_be(0x005954a8) >= 13000 &&
    prev(dword_be(0x005954a8)) < 13000
  )
)

function MenuCheck() => dword_be(0x0034e778) == 0x00

rich_presence_conditional_display(IsInGame(0x400) && MenuCheck(),"Player is jumping in a game of Fierljeppen!")
rich_presence_conditional_display(IsInGame(0x200) && SubMinigame(0x000) && MenuCheck(),"Player is tossing some tuna at Pandaful Beach!")
rich_presence_conditional_display(IsInGame(0x200) && SubMinigame(0x100) && MenuCheck(),"Player is tossing some tuna at Unvirtual Studio!")
rich_presence_conditional_display(IsInGame(0x000) && SubMinigame(0x000) && MenuCheck(),"Player is racing furniture in Seaside Hill!")
rich_presence_conditional_display(IsInGame(0x000) && SubMinigame(0x000) && MenuCheck(),"Player is racing furniture in Rockyroad Valley!")
rich_presence_conditional_display(IsInGame(0x700) && SubMinigame(0x000) && MenuCheck(),"Player is doing some extreme ironing in Boundless Sky!")
rich_presence_conditional_display(IsInGame(0x700) && SubMinigame(0x100) && MenuCheck(),"Player is doing some extreme ironing in Lava Splashdown!")
rich_presence_conditional_display(IsInGame(0x600) && MenuCheck(),"Player is chopping some logs in Chipchop Woods!")
rich_presence_conditional_display(IsInGame(0x900) && MenuCheck(),"Player is rolling some cheese in Le Fromage Circus!")
rich_presence_conditional_display(IsInGame(0x100) && SubMinigame(0x000) && MenuCheck(),"Player is racing their lawnmower in Weedwhacked Farm!")
rich_presence_conditional_display(IsInGame(0x100) && SubMinigame(0x100) && MenuCheck(),"Player is competing in a battle on top of Greenhenge!")
rich_presence_conditional_display(IsInGame(0x100) && SubMinigame(0x100) && MenuCheck(),"Player is competing in a battle on top of Greenhenge!")
rich_presence_conditional_display(IsInGame(0x100) && MenuCheck(),"Player is boxing in the Card Shark Arena!")
rich_presence_conditional_display(IsInGame(0x300) && MenuCheck(),"Player is playing a round of golf in Snowman Way!")
rich_presence_conditional_display(IsInGame(0x800) && SubMinigame(0x000) && MenuCheck(),"Player is sliding around in the mud in Mud Slide Alley!")
rich_presence_conditional_display(IsInGame(0x800) && SubMinigame(0x100) && MenuCheck(),"Player is sliding around in the mud in Mudarama Theatre!")
rich_presence_conditional_display(dword_be(0x0034e778) == 0x01, "Browsing the menus")
rich_presence_display("Playing Wacky World of Sports")