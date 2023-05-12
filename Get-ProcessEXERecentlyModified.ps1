<#
.Synopsis
   Gets any running processes where the executable has been modified in the last 90 days
.DESCRIPTION
   This script can be used to assist you in finding possible processes that have been comprimised or updated in the last 90 days if for example there is a security concern or any unexplained activity
.EXAMPLE
   .\Get-ProcessEXERecentlyModified.ps1
.OUTPUTS
   This script will output a list of running processes where the executable file date and time stamp in the file system is less than 90 days ago
.NOTES
   This script was written to help identify processes that were updated when the user said no changes had been made but also said the system was behaving strangely
#>
$90days = (Get-Date).AddDays(-90)
Get-Process | Select-Object Path -Unique | Get-Item | Where-Object {$_.LastWriteTime -gt $90days} | Format-Table LastWriteTime,Name
