$Now = (Get-Date)::Now
$StartTime = (Get-Date).AddDays(-7) ## Only get events between $Now and 7 days ago
$IDs = 4624,4647 ## 4647 is Logoff and 4624 is a Logon
$Events = Get-WinEvent -FilterHashtable @{ LogName='Security'; Id=$IDs; StartTime=$StartTime ; EndTime=$Now } -ErrorAction Stop| Sort-Object TimeCreated
Function Get-LogonID
{
foreach ($Event in $Events)
    {
    If ($Event.ID -eq 4647) {$LogonID = $Event.Properties[3].Value}
    else {$LogonID = $Event.Properties[7].Value}
    Write-Output -InputObject $LogonID
    }
}
$Matches = Get-LogonID | Where-Object {$_ -gt "999"} | Group-Object | Where-Object {$_.Count -gt 1} | Select-Object -ExpandProperty Name
foreach ($Match in $Matches)
    {
    $Logoff = $Events | Where-Object {$_.ID -eq 4647 -AND $_.Properties[3].Value -like $Match}
    $Logon = $Events | Where-Object {$_.ID -eq 4624 -AND $_.Properties[7].Value -like $Match}
    if ($Logoff)
        {
        $TimeOut = $Logoff.TimeCreated
        $Account = $Logoff.Properties[1].Value
        $LogoffID = $Logoff.Properties[3].Value
        }
    else
        {
        Write-Verbose -Message "We did NOT have a log off event"
        $TimeOut = "Active Session"
        $Account = $Logon.Properties[5].Value
        $LogoffID = $Logon.Properties[7].Value
        }
    $TimeIn = $Logon.TimeCreated
    $Domain = $Logon.Properties[2].Value ## [6] was also Domain in one example
    $Name = $Logon.Properties[5].Value
    $LogonID = $Logon.Properties[7].Value
    $LogonTable = [ordered]@{'TimeIn'=$TimeIn;'TimeOut'=$TimeOut;'Name'=$Name;'Account'=$Account;'Domain'=$Domain;'LogonID'=$LogonID;'LogoffID'=$LogoffID}
    $LogonObject = New-Object -TypeName PSObject -Property $LogonTable
    Write-Output -InputObject $LogonObject
    }
## .\Get-LogOnLogOff.ps1 | Format-Table -AutoSize