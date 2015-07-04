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
