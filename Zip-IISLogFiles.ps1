<#
.Synopsis
   Compresses IIS logs based on provided age in days
.DESCRIPTION
   Creates ZIP Archives in the default IIS log file path with a date code based on log file age adds those logs to the ZIP then removes the aged logs, also removes ZIP Archives based on a second parameter for ZIP file age in days.
   If you plan to run from a scheduled task un-remark the last line of the file and change the values to the desired number of days
.EXAMPLE
   Zip-IISLogs -LogFileDays 30 -ZipFileDays 90
.EXAMPLE
   Zip-IISLogs -LogFileDays <number of days old> -ZipFileDays <number of days old>
.EXAMPLE
   If calling from the command line change the default values at the bottom of this script
#>
function Zip-IISLogs
{
    [CmdletBinding()]    
    Param
    (
        # LogFileDays number of days old to archive and then delete
        [Parameter(Mandatory=$false,
                   Position=0)]
        $LogFileDays,
 
        # ZipFileDays number of days old to delete and remove the old ZIP files that are no longer needed
        [Parameter(Mandatory=$false,
                   Position=1)]
        $ZipFileDays
    )
 
    Begin
    {
    $LogFileDays = (Get-Date).AddDays(-$LogFileDays)
 
    # Setup some global variables
    $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
    $includeBaseDirectory = $false # if true creates a folder within a folder
    $defaultLogPath = Get-WebConfiguration -Filter system.applicationhost/sites/sitedefaults/logfile | Select-Object -ExpandProperty directory
 
    # TEMP foldername and filename variable
    $tempName = "IISLogs"+(Get-Date).ToShortDateString().Replace("/","-")
    $Destination = $defaultLogPath.Replace("%SystemDrive%",$env:SystemDrive)+"\"+$tempName+".zip"
    [System.IO.FileInfo]$tempFolder = $env:TEMP+"\"+$tempName
    New-Item -Path $tempFolder -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
 
    function Get-IISLogFilePath
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
    }
    Process
    {
    $iisLogFolders = Get-IISLogFilePath
    foreach ($folder in $iisLogFolders)
        {
        Get-ChildItem $folder -Recurse -Include *.log | Where-Object {$_.LastWriteTime -le $LogFileDays} | Move-Item -Destination $tempFolder -Force
        }
 
    # Now create the zip file
    # Load the built in ZIP Assembly from Windows
    [Reflection.Assembly]::LoadWithPartialName( "System.IO.Compression.FileSystem" )
    if ((Get-ChildItem $tempFolder).Length -lt 1) {Remove-Item $tempFolder -Recurse -Force -ErrorAction SilentlyContinue ; exit}
    else
        {
    [System.IO.Compression.ZipFile]::CreateFromDirectory($tempFolder,$Destination,$compressionLevel,$includeBaseDirectory)
    Remove-Item $tempFolder -Recurse -Force -ErrorAction SilentlyContinue
        }
 
    # Remove old ZIPs
    if ($ZipFileDays)
        {
        Get-ChildItem -Path $defaultLogPath.Replace("%SystemDrive%",$env:SystemDrive) -Include *.zip -Recurse | Where-Object {$_.LastWriteTime -le (Get-Date).AddDays(-$ZipFileDays)} | ForEach-Object {Remove-Item $_.FullName -Force}
        }
    }
    End
    {
    Clear-Host
    (Get-ChildItem $Destination).FullName
    }
}
# Remember to set your defaults below replace the variables with your numbers if you plan to run from a scheduled task then REMOVE the "#" from the last line
# HINT: ZipFileDays 0 will NOT delete old ZIP files 
# Zip-IISLogs -LogFileDays 30 -ZipFileDays 120
