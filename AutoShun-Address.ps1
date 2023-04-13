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
        netsh advfirewall firewall add rule name="Rackspace-AutoShun" dir=in action=block remoteip=$ShunAddresses enable=yes
        }
    }
   
   
Function Add-Rule
    {
    if ($ShunAddresses)
        {
        netsh advfirewall firewall set rule name="Rackspace-AutoShun" dir=in new remoteip=$ShunAddresses enable=yes
        }
    }


# Determine if the rule already exist or not
netsh advfirewall firewall show rule Name=Rackspace-Autoshun
if ($LASTEXITCODE -gt 0)
    {
    Create-Rule
    }
elseif ($LASTEXITCODE -eq 0)
    {
    Add-Rule
    } 
