<#
.Synopsis
   On a Hyper-V server gets the worker process information for the VMs
.DESCRIPTION
   This is a script for getting a list of information related to the Windows process of each Virtual Machine on the Hyper-V HOST
.EXAMPLE
   .\Get-VMProcess.ps1
.OUTPUTS
   List information about the process of each VM on a Hyper-V HOST Hypervisor
.NOTES
   VM processes are the running state of each Virtual Machine and are usually have "vmwp" in the process name
#>
$VMWPs = Get-WmiObject -query "SELECT * FROM Win32_Process WHERE Name LIKE '%vmwp%'"
foreach ($VMWP in $VMWPs)
    {
    $VMProcess = Get-Process -Id $VMWP.ProcessId
    $VMID = $VMWPs.CommandLine.Split(" ")[1]
    $VM = $(Get-VM -Id $VMID)
    $VMName = $VM.Name
    $VMProcObject = [ordered]@{'VMName'=$VMName;
                    'Handles'=$VMProcess.HandleCount;
                    'NPM(K)'=$($VMProcess.NonpagedSystemMemorySize64);
                    'PM(K)'=$($VMProcess.PagedMemorySize64 / 1KB);
                    'WS(K)'=$($VMProcess.WorkingSet64 / 1KB);
                    'CPU(s)'=[Math]::Round($VMProcess.TotalProcessorTime.TotalSeconds);
                    'PID'=$VMProcess.Id;
                    'OwnerNode'=$VM.ComputerName;
                    'Uptime'=$VM.Uptime}
    $obj = New-Object -TypeName PSObject -Property $VMProcObject
    Write-Output -InputObject $obj
    }
