#This example uninstalled Skype from my machine
 
#The following should all be on one line . . .
 
Get-WmiObject Win32_Product | Where-Object {$_.IdentifyingNumber -eq "{1845470B-EB14-4ABC-835B-E36C693DC07D}"} |  Invoke-WmiMethod -Name "Uninstall"
