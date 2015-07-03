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
