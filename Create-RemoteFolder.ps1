<#
.Synopsis
   If you need to add a folder to a bunch of servers on the network this script can help do that
.DESCRIPTION
   This script will iterate through a list of servers and open a UNC connection to each server and create a new folder, if you had a standard folder you are being asked to put on each server manually it may make things easier for you to script it.
.EXAMPLE
   .\Create-RemoteFolder.ps1
.NOTES
   This script could be made better by Parameterizing the folder path instead of being static, I must have created this early in my PowerShell learning because I don't know why I did not parameterize it. I may add that soon.
#>
# Remember to enter credentials that are valid for each server in your c:\servers.txt file
$credentials = Get-Credential
$servers = Get-Content c:\servers.txt
foreach ($server in $servers)
    {    
    $scriptsFolder = Invoke-Command -ComputerName $server -Credential $credentials -ScriptBlock {Test-Path C:\Scripts}
    if ($scriptsFolder -ne $true)
        {
        Invoke-Command -ComputerName $server -Credential $credentials -ScriptBlock {New-Item C:\scripts -ItemType directory}
        }
    }
