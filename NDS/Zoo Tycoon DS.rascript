// Zoo Tycoon DS
// #ID = 7344

TutorialBitflags = bit0(0x0cf2c0) + bit1(0x0cf2c0) + bit2(0x0cf2c0)
function InGame() => byte(0x0cf334) == 0x38

//Beat scenario achievements
achievement(
    title = "Learning The Basics",
    description = "Complete all 3 tutorial scenarios",
    points = 3,
    trigger = (
        byte(0x0cf334) == 0x38 || byte(0x0cf334) == 0x78 &&
        TutorialBitflags == 0x03 &&
        prev(TutorialBitflags) == 0x02
    )
)
function BeatScenario(achTitle, scenarioName, points, scenario){
    achievement(
        title = achTitle,
        description = "Beat scenario "  + scenarioName,
        points = points,
        trigger = (
            InGame() &&
            scenario == 0x01 &&
            prev(scenario) == 0x00
        )
    )
}

BeatScenario("Starting Small", "Small Zoo", 4, bit3(0x0cf2c0))
BeatScenario("Trip to the Sea", "Seasideville Zoo", 4, bit4(0x0cf2c0))
BeatScenario("A Zoo of Trees", "Forest Zoo", 4, bit5(0x0cf2c0))
BeatScenario("Badly Managed Zoo", "Revitalize Burkitsville Zoo", 4, bit6(0x0cf2c0))
BeatScenario("The Mayor's Zoo", "Inner City Zoo", 5, bit7(0x0cf2c0))
BeatScenario("Come Here Kitty", "Saving The Great Cats", 5, bit0(0x0cf2c1))
BeatScenario("Saving the Animals", "Endangered Species Zoo", 5, bit1(0x0cf2c1))
BeatScenario("Isla Nublar", "Island Zoo", 5, bit2(0x0cf2c1))
BeatScenario("A Zoo For Kenya", "African Savannah Zoo", 10, bit3(0x0cf2c1))
BeatScenario("Rainy Zoo", "Tropical Rainforest Zoo", 10, bit4(0x0cf2c1))
BeatScenario("Animal Island", "Paradise Island", 10, bit5(0x0cf2c1))
BeatScenario("Giant Pandas!", "Breeding Giant Pandas", 10, bit6(0x0cf2c1))
BeatScenario("Rich Man Zoo", "Secret Scenario 1", 10, bit7(0x0cf2c1))
BeatScenario("Mile High Zoo", "Secret Scenario 2", 10, bit0(0x0cf2c2))
BeatScenario("The Ultimate Zoo", "Secret Scenario 3", 25, bit1(0x0cf2c2))