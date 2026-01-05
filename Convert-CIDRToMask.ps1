Param (
# Enter a number between 1 and 32
[Parameter(Mandatory=$true)]
[ValidateRange(0, 32)]
[int]$CIDR)
## Create a binary string with the number of BITS equal to the CIDR value
$BinaryMask = ('1' * $CIDR).PadRight(32, '0')
## Split the binary string into 8-bit segments referred to in Networking as Octets
$Octets = $BinaryMask -split '(.{8})' -ne '' # A regex matches any single character except a newline and repeat for 8 matches # basically splitting after each 8 charecters
## Convert each 8-bit segment to a decimal number and bring them back into one string separated by the dot (or decimal or period)
$SubnetMask = ($Octets | ForEach-Object { [Convert]::ToInt32($_, 2) }) -join '.'
Write-Host -Object "The SubnetMask for a slash $CIDR is $SubnetMask" -ForegroundColor Green