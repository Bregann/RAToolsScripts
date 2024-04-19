# Prompt the user to enter the start and end numbers
$startNumber = Read-Host "Enter the start number"
$endNumber = Read-Host "Enter the end number"

# Convert input to integers
$startNumber = [int]$startNumber
$endNumber = [int]$endNumber

# Loop through the numbers and print them in the specified format
for ($i = $startNumber; $i -le $endNumber; $i++) {
    Write-Host "[game=$i]"
}
