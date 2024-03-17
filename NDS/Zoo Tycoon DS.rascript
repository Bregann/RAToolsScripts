// Zoo Tycoon DS
// #ID = 7344

TutorialBitflags = bit0(0x0cf2c0) + bit1(0x0cf2c0) + bit2(0x0cf2c0)
CardsCollected = bitcount(0x0cf2c4) + bitcount(0x0cf2c5) + bitcount(0x0cf2c6) +
bitcount(0x0cf2c7) + bitcount(0x0cf2c8) + bitcount(0x0cf2c9) + bit0(0x0cf2ca) + bit1(0x0cf2ca)
FreeformStartingCash = dword(0x0cf2a0)

function InGame() => byte(0x0cf334) == 0x38
function InFreeformGame() => byte(0x0cf334) == 0x38 && byte(0x0cf2d0) == 0x01
function InGameOrScenarioScreen() => byte(0x0cf334) == 0x38 || byte(0x0cf334) == 0x78

achievement(
    title = "Learning The Basics",
    description = "Complete all 3 tutorial scenarios",
    type = "PROGRESSION",
    points = 3,
    trigger = (
        InGameOrScenarioScreen() &&
        TutorialBitflags == 0x03 &&
        prev(TutorialBitflags) == 0x02
    )
)
function BeatScenario(achTitle, scenarioName, points, scenario, achType){
    achievement(
        title = achTitle,
        description = "Beat scenario "  + scenarioName,
        points = points,
        type = achType,
        trigger = (
            InGame() &&
            scenario == 0x01 &&
            prev(scenario) == 0x00
        )
    )
}

BeatScenario("Starting Small", "Small Zoo", 4, bit3(0x0cf2c0), "PROGRESSION")
BeatScenario("Trip to the Sea", "Seasideville Zoo", 4, bit4(0x0cf2c0), "PROGRESSION")
BeatScenario("A Zoo of Trees", "Forest Zoo", 4, bit5(0x0cf2c0), "PROGRESSION")
BeatScenario("Badly Managed Zoo", "Revitalize Burkitsville Zoo", 4, bit6(0x0cf2c0), "PROGRESSION")
BeatScenario("The Mayor's Zoo", "Inner City Zoo", 5, bit7(0x0cf2c0), "PROGRESSION")
BeatScenario("Come Here Kitty", "Saving The Great Cats", 5, bit0(0x0cf2c1), "PROGRESSION")
BeatScenario("Saving the Animals", "Endangered Species Zoo", 5, bit1(0x0cf2c1), "PROGRESSION")
BeatScenario("Isla Nublar", "Island Zoo", 5, bit2(0x0cf2c1), "PROGRESSION")
BeatScenario("A Zoo For Kenya", "African Savannah Zoo", 10, bit3(0x0cf2c1), "PROGRESSION")
BeatScenario("Rainy Zoo", "Tropical Rainforest Zoo", 10, bit4(0x0cf2c1), "PROGRESSION")
BeatScenario("Animal Island", "Paradise Island", 10, bit5(0x0cf2c1), "PROGRESSION")
BeatScenario("Giant Pandas!", "Breeding Giant Pandas", 10, bit6(0x0cf2c1), "PROGRESSION")
BeatScenario("Rich Man Zoo", "Secret Scenario 1", 10, bit7(0x0cf2c1), "PROGRESSION")
BeatScenario("Mile High Zoo", "Secret Scenario 2", 10, bit0(0x0cf2c2), "PROGRESSION")
BeatScenario("The Ultimate Zoo", "Secret Scenario 3", 25, bit1(0x0cf2c2), "WIN_CONDITION")

function CollectibleCardsUnlocked(achTitle, achDesc, points, amount)
{
    achievement (
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            InGameOrScenarioScreen() &&
            CardsCollected >= amount &&
            prev(CardsCollected) <= amount
        )
    )
}

CollectibleCardsUnlocked("Animal Card Collector", "Collect at least half of cards available in the card collection", 10, 25)
CollectibleCardsUnlocked("Full Animal Set!", "Collect all of cards available in the card collection", 25, 50)

function FreeformAchievement(achTitle, awardName, points, awardBit)
{
    achievement(
        title = achTitle,
        description = "In freeform mode start with $25,000 cash and unlock the " + "\"" + awardName + "\"" + " award",
        points = points,
        trigger = (
            InFreeformGame() &&
            FreeformStartingCash <= 25000 &&
            awardBit == 0x01 &&
            prev(awardBit) == 0x00
        )
    )
}

FreeformAchievement("Only the Best Exhibits", "Highest Quality Exhibits (silver)", 5, bit1(0x0ebbd0))
FreeformAchievement("The Master of Exhibit Quality", "Highest Quality Exhibits (gold)", 10, bit0(0x0ebbd0))
FreeformAchievement("A Variety of Animals", "Diverse Species (silver)", 5, bit3(0x0ebbd0))
FreeformAchievement("Mr Worldwide", "Diverse Species (gold)", 10, bit2(0x0ebbd0))
FreeformAchievement("The Customer is Always Right!", "Highest Customer Satisfaction", 10, bit4(0x0ebbd0))
FreeformAchievement("Animal Kindness", "Quality Animal Care", 10, bit5(0x0ebbd0))
FreeformAchievement("Standing Out From the Competition", "Best Zoo (silver)", 5, bit7(0x0ebbd0))
FreeformAchievement("The Greatest Zoo Ever!", "Best Zoo (gold)", 10, bit6(0x0ebbd0))

FreeformAchievement("A Very Busy Zoo", "Most Popular Zoo (silver)", 5, bit1(0x0ebbd1))
FreeformAchievement("The Ultimate Trendy Zoo", "Most Popular Zoo (gold)", 10, bit0(0x0ebbd1))
FreeformAchievement("Plenty of Happy Animals", "Excellence In Exhibit Design (silver)", 5, bit3(0x0ebbd1))
FreeformAchievement("Perfect Designer", "Excellence In Exhibit Design (gold)", 10, bit2(0x0ebbd1))

function FreeformResearch(achTitle, achDesc, points, researchValues, amount)
{
    achievement(
        title = achTitle,
        description = achDesc,
        points = points,
        trigger = (
            InFreeformGame() &&
            FreeformStartingCash <= 15000 &&
            researchValues == amount &&
            prev(researchValues) == amount - 1
        )
    )
}

ResearchBits = bit0(0x0fa56a) + bit1(0x0fa56a) + bit0(0x0fa56b) + bit1(0x0fa56b) + bit3(0x0fa56b) + bit4(0x0fa56b) + 
bit5(0x0fa56b) + bit6(0x0fa56b) + bit7(0x0fa56b) + bit0(0x0fa56c) + bit1(0x0fa56c) + bit2(0x0fa56c)
  
ConservationBits = bit0(0x0fa56d) + bit1(0x0fa56d) + bit2(0x0fa56d) + bit3(0x0fa56d) + bit4(0x0fa56d) + bit5(0x0fa56d) +
bit0(0x0fa56e) + bit1(0x0fa56e) + bit2(0x0fa56e) + bit3(0x0fa56e) + bit0(0x0fa56f) + bit1(0x0fa56f) + bit0(0x0fa570) +
bit1(0x0fa570) + bit0(0x0fa571) + bit0(0x0fa572) + bit0(0x0fa573) + bit1(0x0fa573)

FreeformResearch("Making New Discoveries", "In freeform mode start with $15,000 cash complete half of the \"Research\" research", 5, ResearchBits, 6)
FreeformResearch("Much Needed Upgrades", "In freeform mode start with $15,000 cash complete all of the \"Research\" research", 10, ResearchBits, 12)

FreeformResearch("Saving the Animals", "In freeform mode start with $15,000 cash complete half of the \"Conservation\" research", 5, ConservationBits, 9)
FreeformResearch("Ready to Build the Animal Kingdom", "In freeform mode start with $15,000 cash complete all of the \"Conservation\" research", 10, ConservationBits, 18)