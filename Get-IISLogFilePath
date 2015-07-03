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
