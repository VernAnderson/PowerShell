<#
.Synopsis
   "Blocks an IP in the Windows Firewall that has failed a given number of logon attempts"
.DESCRIPTION
   "This command retrieves failed Remote logon events from the Security log and gets the offending IP Address from the logged event. Then is uses that IP to create a firewall rule to block further connections from that IP Address."
.EXAMPLE
   "You can schedule a Windows Scheduled Task to run this script as often as you like (5 minutes is recommended)"
.EXAMPLE
   "You may want to have that scheduled task run as the ""SYSTEM"" Account"
.OUTPUTS
   "The output of this script is the full syntax needed by the netsh command, and a firewall rule named ""FailedLogon-AutoShun"" gets created (or you can change that string to whatever you would like)"
.NOTES
   "This script is provided for free without any implied support"
#>
# Change the value of the following variable to control how many login failures before you block
$MaxFailures=3

# We get the offending IP from the Eventlog
Function Get-OffendingIPs
    {
    # Only logon failures in the past 24 hours will remain shunned
    $time = (Get-Date).AddHours(-24)
    $logonfails = Get-EventLog -LogName Security -After $time -EntryType FailureAudit | Where-Object {$_.EventID -eq 4625}
    foreach ($logonfail in $logonfails)
        {
        $logonfail.ReplacementStrings[19]
        }
    }
$offendingIPs = Get-OffendingIPs | Where-Object {$_ -notmatch '-'}
foreach ($IP in $offendingIPs)
    {
    $occurrences = $offendingIPs | Select-String $IP | Measure-Object | Select-Object -ExpandProperty Count
    if ($occurrences -ge $MaxFailures)
        {
        $ShunAddresses = "$IP,$ShunAddresses"
        }
    }


Function Create-Rule
    {
    if ($ShunAddresses)
        {
        netsh advfirewall firewall add rule name="FailedLogon-AutoShun" dir=in action=block remoteip=$ShunAddresses enable=yes
        }
    }
   
   
Function Add-Rule
    {
    if ($ShunAddresses)
        {
        netsh advfirewall firewall set rule name="FailedLogon-AutoShun" dir=in new remoteip=$ShunAddresses enable=yes
        }
    }


# Determine if the rule already exist or not
netsh advfirewall firewall show rule Name=FailedLogon-Autoshun
if ($LASTEXITCODE -gt 0)
    {
    Create-Rule
    }
elseif ($LASTEXITCODE -eq 0)
    {
    Add-Rule
    }
