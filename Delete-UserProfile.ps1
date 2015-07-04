# In sysdm.cpl advanced tab you can do this in the GUI
# Here's how in PowerShell
$UserSID = (Get-WmiObject Win32_UserProfile | Where {$_.LocalPath -match 'Dale.Eatme'}).SID
(gwmi -class Win32_UserProfile -filter "SID='$UserSID'").Delete() 
