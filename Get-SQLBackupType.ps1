<#
.Synopsis
   Gets MS SQL Server backup events and determines the most likely type of backup
.DESCRIPTION
   This script looks for EVENT IDs in the Windows Application Logs related to MS SQL Backup events and determines whether the backup type was to disk, or to tape, or to a Network UNC path.
.EXAMPLE
   .\Get-SQLBackupType.ps1
.OUTPUTS
   This outputs the backup type to the screen translated from a number to human readable types based on a Microsoft Article that describes those numbers
.NOTES
   I originally wrote this script when a customer was breaking the SQL backup chain because they were performing their own backups outside of the scheduled backups to tape. This script helped me prove that the backup failures were not the fault of the backup
    to tape software, but rather the customers own manual backups that broke the "chain" for SQL Transaction Log backups.
#>
$Database = Read-Host "Enter the name of the database"
$lastfail = Get-EventLog -LogName Application -Source *SQL* -Message *Backup*$Database*  | Where-Object {$_.EventID -eq 3041} | Select-Object -First 1 -ExpandProperty TimeGenerated
$18264 = Get-EventLog -LogName Application -Source *SQL* -After $lastfail -Data *$Database* | Where-Object {$_.EventID -eq 18264}
$BUdevice = $18264.ReplacementStrings[7]
if ($BUdevice -notmatch "TYPE=")
    {
    "We could not determine the backup device type"
    }
elseif ($BUdevice -match "TYPE=DISK")
    {
    "The backup device was a DISK or UNC path"
    }
elseif ($BUdevice -match "TYPE=VIRTUAL_DEVICE")
    {
   "The backup device was most likely a tape backup"
    }
