<#
.Synopsis
   Adds a Windows Scheduled tasks to create a System State backup that can be picked up by the normal file system backup for disaster and recovery purposes
.DESCRIPTION
   This command will generate the proper syntax to send to a scheduled task that will then create a system state backup to a UNC path but tricking it to be saved to the local drive for the file backup to pickup and save for OS recovery and disaster recovery 
purposes.
.EXAMPLE
   .\Schedule-SystemStateBackup.ps1
.EXAMPLE
   
.OUTPUTS
   This command's output is to send the proper syntax and parameters to a scheduled task that runs the wbadmin command for a system state backup to a UNC path
.NOTES
   Disaster Recovery is important and if you don't have a system state you will not recover all the OS configuration and settings without it
#>
# Setup variables
$server = $env:computername
$UNCpath = "\\$server\Backup" # Create a shared folder and put the full UNC path here
 
# Test that UNC Path is working
$PathTest = Test-Path $UNCpath
if ($PathTest -eq $True) {cls ; Write-Host -ForegroundColor Cyan "Good to go!"} else {cls ; Write-Warning "UNC path is not accessible" ; exit}
 
# Create a System State backup Scheduled Task
Set-Location $ENV:SystemRoot\System32
    $wbadmin = Test-Path .\wbadmin.exe
    if ($wbadmin -eq $True) {
    .\wbadmin.exe enable backup -addtarget:$UNCpath -schedule:02:00 -user:Administrator -password:P@ssw0rd1 -systemState -quiet
    } 
    else {cls ; Write-Warning "Windows Backup is not properly installed" ; exit}
