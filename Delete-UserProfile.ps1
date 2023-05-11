<#
.Synopsis
   Cleans up user profiles in the C:\Users path in Windows as well as the actual profile object itself
.DESCRIPTION
   This script will delete a user’s Windows profile. Essentially erasing the fact that they ever logged onto the system. This is one way to do that with PowerShell, the GUI way would be in sysdm.cpl advanced tab, otherwise known as system properties.
.EXAMPLE
   .\Delete-UserProfile.ps1
.OUTPUTS
   The result is that the users SID is removed from the local SAM and the C:\Users\<loginid> folder will be removed as well
.NOTES
   Yet another script I need to come back and paramaterize static data
#>
$UserSID = (Get-WmiObject Win32_UserProfile | Where {$_.LocalPath -match 'Dale.Eatme'}).SID
(gwmi -class Win32_UserProfile -filter "SID='$UserSID'").Delete() 
