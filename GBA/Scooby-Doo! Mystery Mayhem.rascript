// Scooby-Doo! Mystery Mayhem
// #ID = 6771

CurrentChapter = byte(0x01b378)
function IsInGame() => 
(byte(0x0086b9) != 0x00 && byte(0x0086b9) != 0x6b && byte(0x0086b9) != 0x69 && byte(0x0086b9) != 0x60 && byte(0x0086b9) != 0x61 &&
byte(0x0086b9) != 0x0a && byte(0x0086b9) != 0x62 && byte(0x0086b9) != 0x68 && byte(0x0086b9) != 0x6a) ||
(byte(0x0086f9) != 0x00 && byte(0x0086f9) != 0x6b && byte(0x0086f9) != 0x69 && byte(0x0086f9) != 0x60 && byte(0x0086f9) != 0x61 &&
byte(0x0086f9) != 0x0a && byte(0x0086f9) != 0x62 && byte(0x0086f9) != 0x68 && byte(0x0086f9) != 0x6a) 

function CurrentArea(screenId) => byte(0x0086b9) == screenId && byte(0x0086f9) == screenId

function SandwichComplete(achTitle, achDesc) {

}

function CluesFound(achTitle, achDesc, points) {

}

function LevelComplete(achTitle, achDesc, points) {

}

