<#
.Synopsis
   Discovers the log file path of each site in IIS
.DESCRIPTION
   Returns the current path of the IIS Log file path for each site inside of IIS
.EXAMPLE
   .\Get-IISLogFilePath.ps1
.OUTPUTS
   Outputs the full path where each website's log files are being saved to disk
.NOTES
   IIS was a big part of my job for over 10 years or more
#>
Function Get-IISLogFilePath
{
# Load the PowerShell Module for IIS
Import-Module WebAdministration
 
$Sites = Get-ItemProperty 'IIS:\Sites\*'
foreach ($Site in $Sites)
    {
    $SiteID = $Site.ID
    $LogPath = $Site.logFile.directory
    $Logpath = $LogPath.Replace("%SystemDrive%",$env:SystemDrive)
    "$LogPath"+'\W3SVC'+"$SiteID"
    }
}
