<#
.Synopsis
   This script can convert an IP Address and subnet mask to CIDR notation or visa verse depending on what you comment out
.DESCRIPTION
   To use this script, comment out the either line 18 or line 19 depending on your needs. Then enter the IP Address information you do have and it will convert it to the format you don’t have. For example, if someone gives you an IP Address in CIDR notation i
t will give you the subnet mask of that network. Otherwise if you know your MASK and IP Address it can convert those to CIDR notation.
.EXAMPLE
   .\Covert-MaskToCIDR.ps1 # I have already commented out either line 18 or line 19
.EXAMPLE
   Open this script in PowerShell_ISE and run it from there by pressing F5 or the green arrow
.OUTPUTS
   This script will output the opposite notation of the Network you have. CIDR if you have MASK and MASKE if you feed it CIDR
.NOTES
   This script is not a complete function and was actually whipped up during a job interview in a kind of rushed manor without a lot of direction of what the 2 interviewes wanted. I got the job so it did do what was asked. It coul.d be converted to use Parameters and be a lot better
#>
#Remove the # in front of $IPwSubnet depending upon the input you want to test and remark the other one out with #
 
#$IPwSubnet = "192.168.1.10 255.255.255.0"
$IPwSubnet = "192.168.1.10/24"
 
#Determine the class
#If you would like the class to be displayed remove the "} #" after the cls
[int]$FirstOctet = $IPwSubnet.Split(".") | Select-Object -First 1
if ($FirstOctet -ge 1 -and $FirstOctet -lt 127) {cls} # ; Write-Host "You have a Class A Network"} #255.0.0.0
elseif ($FirstOctet -ge 128 -and $FirstOctet -lt 192) {cls} # ; Write-Host "You have a Class B Network"} #255.255.0.0
elseif ($FirstOctet -ge 192 -and $FirstOctet -lt 224) {cls} # ; Write-Host "You have a Class C Network"} #255.255.255.0
elseif ($FirstOctet -ge 224 -and $FirstOctet -lt 240) {cls ; Write-Host "You have a Class D Network which is reserved for Multicasting"}
elseif ($FirstOctet -ge 240 -and $FirstOctet -lt 255) {cls ; Write-Host "You have a Class E Network which is Experimental and should only be used for research"}
else {cls ; Write-Host "You have entered an unusable IP Address"}
#CIDR was the input
if ($IPwSubnet -like "*/*")
{
$IPAddress = $IPwSubnet.Split("/") | Select-Object -First 1 #; $IPAddress
$CIDR = $IPwSubnet.Split("/") | Select-Object -Last 1 # ; $CIDR
if ($CIDR -eq 1) {Write-Host $IPAddress " 128.0.0.0"}
elseif ($CIDR -eq 2) {Write-Host $IPAddress " 192.0.0.0"}
elseif ($CIDR -eq 3) {Write-Host $IPAddress " 224.0.0.0"}
elseif ($CIDR -eq 4) {Write-Host $IPAddress " 240.0.0.0"}
elseif ($CIDR -eq 5) {Write-Host $IPAddress " 248.0.0.0"}
elseif ($CIDR -eq 6) {Write-Host $IPAddress " 252.0.0.0"}
elseif ($CIDR -eq 7) {Write-Host $IPAddress " 254.0.0.0"}
elseif ($CIDR -eq 8) {Write-Host $IPAddress " 255.0.0.0"}
elseif ($CIDR -eq 9) {Write-Host $IPAddress " 255.128.0.0"}
elseif ($CIDR -eq 10) {Write-Host $IPAddress " 255.192.0.0"}
elseif ($CIDR -eq 11) {Write-Host $IPAddress " 255.224.0.0"}
elseif ($CIDR -eq 12) {Write-Host $IPAddress " 255.240.0.0"}
elseif ($CIDR -eq 13) {Write-Host $IPAddress " 255.248.0.0"}
elseif ($CIDR -eq 14) {Write-Host $IPAddress " 255.252.0.0"}
elseif ($CIDR -eq 15) {Write-Host $IPAddress " 255.254.0.0"}
elseif ($CIDR -eq 16) {Write-Host $IPAddress " 255.255.0.0"}
elseif ($CIDR -eq 17) {Write-Host $IPAddress " 255.255.128.0"}
elseif ($CIDR -eq 18) {Write-Host $IPAddress " 255.255.192.0"}
elseif ($CIDR -eq 19) {Write-Host $IPAddress " 255.255.224.0"}
elseif ($CIDR -eq 20) {Write-Host $IPAddress " 255.255.240.0"}
elseif ($CIDR -eq 21) {Write-Host $IPAddress " 255.255.248.0"}
elseif ($CIDR -eq 22) {Write-Host $IPAddress " 255.255.252.0"}
elseif ($CIDR -eq 23) {Write-Host $IPAddress " 255.255.254.0"}
elseif ($CIDR -eq 24) {Write-Host $IPAddress " 255.255.255.0"}
elseif ($CIDR -eq 25) {Write-Host $IPAddress " 255.255.255.128"}
elseif ($CIDR -eq 26) {Write-Host $IPAddress " 255.255.255.192"}
elseif ($CIDR -eq 27) {Write-Host $IPAddress " 255.255.255.224"}
elseif ($CIDR -eq 28) {Write-Host $IPAddress " 255.255.255.240"}
elseif ($CIDR -eq 29) {Write-Host $IPAddress " 255.255.255.248"}
elseif ($CIDR -eq 30) {Write-Host $IPAddress " 255.255.255.252"}
elseif ($CIDR -eq 31) {Write-Host $IPAddress " 255.255.255.254"}
elseif ($CIDR -eq 32) {Write-Host $IPAddress " 255.255.255.255"}
else {Write-Host "Your CIDR must be between 1 and 32 per RFC 1878" -ForegroundColor Red}
}
#Input had a space with a MASK
elseif ($IPwSubnet+$MASK -like "* *")
{
$IPAddress = $IPwSubnet.Split("* *") | Select-Object -First 1 # ; $IPAddress
$MASK = $IPwSubnet.Split("* *") | Select-Object -Last 1 # ; $MASK
if ($MASK -eq "128.0.0.0") {Write-Host $IPAddress"/1" }
elseif ($MASK -eq "192.0.0.0") {Write-Host $IPAddress"/2" }
elseif ($MASK -eq "224.0.0.0") {Write-Host $IPAddress"/3" }
elseif ($MASK -eq "240.0.0.0") {Write-Host $IPAddress"/4" }
elseif ($MASK -eq "248.0.0.0") {Write-Host $IPAddress"/5" }
elseif ($MASK -eq "252.0.0.0") {Write-Host $IPAddress"/6" }
elseif ($MASK -eq "254.0.0.0") {Write-Host $IPAddress"/7" }
elseif ($MASK -eq "255.0.0.0") {Write-Host $IPAddress"/8" }
elseif ($MASK -eq "255.128.0.0") {Write-Host $IPAddress"/9" }
elseif ($MASK -eq "255.192.0.0") {Write-Host $IPAddress"/10"}
elseif ($MASK -eq "255.224.0.0") {Write-Host $IPAddress"/11"}
elseif ($MASK -eq "255.240.0.0") {Write-Host $IPAddress"/12"}
elseif ($MASK -eq "255.248.0.0") {Write-Host $IPAddress"/13"}
elseif ($MASK -eq "255.252.0.0") {Write-Host $IPAddress"/14"}
elseif ($MASK -eq "255.254.0.0") {Write-Host $IPAddress"/15"}
elseif ($MASK -eq "255.255.0.0") {Write-Host $IPAddress"/16"}
elseif ($MASK -eq "255.255.128.0") {Write-Host $IPAddress"/17"}
elseif ($MASK -eq "255.255.192.0") {Write-Host $IPAddress"/18"}
elseif ($MASK -eq "255.255.224.0") {Write-Host $IPAddress"/19"}
elseif ($MASK -eq "255.255.240.0") {Write-Host $IPAddress"/20"}
elseif ($MASK -eq "255.255.248.0") {Write-Host $IPAddress"/21"}
elseif ($MASK -eq "255.255.252.0") {Write-Host $IPAddress"/22"}
elseif ($MASK -eq "255.255.254.0") {Write-Host $IPAddress"/23"}
elseif ($MASK -eq "255.255.255.0") {Write-Host $IPAddress"/24"}
elseif ($MASK -eq "255.255.255.128") {Write-Host $IPAddress"/25"}
elseif ($MASK -eq "255.255.255.192") {Write-Host $IPAddress"/26"}
elseif ($MASK -eq "255.255.255.224") {Write-Host $IPAddress"/27"}
elseif ($MASK -eq "255.255.255.240") {Write-Host $IPAddress"/28"}
elseif ($MASK -eq "255.255.255.248") {Write-Host $IPAddress"/29"}
elseif ($MASK -eq "255.255.255.252") {Write-Host $IPAddress"/30"}
elseif ($MASK -eq "255.255.255.254") {Write-Host $IPAddress"/31"}
elseif ($MASK -eq "255.255.255.255") {Write-Host $IPAddress"/32"}
else {Write-Host Error Invalid CIDR You need to read RFC 1878 -ForegroundColor Red}
}
