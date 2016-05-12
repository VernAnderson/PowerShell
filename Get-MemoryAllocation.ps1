<#
.Synopsis
    Generates Hyper-V memory allocation report
.DESCRIPTION
    This script will generate VM resource allocation information to provide an idea of how much you have used and what is still available
.EXAMPLE
    Get-MemoryAllocation
.EXAMPLE
    Or just run it from ISE, you can also just paste the whole thing at the PowerShell prompt and press enter twice afterwards
.INPUTS
    NONE
.OUTPUTS
    A list of Hypervisor or cluster resoucres as well as resources used by each VM with the total per Hypervisor
.NOTES
    This is by no means complete and is a work in progress
.ROLE
    Microsoft Hyper-V
.FUNCTIONALITY
    Hyper-V Resource Allocation
#>

Function  Get-MemoryAllocation
{
Param ([Parameter(Mandatory=$true,Position=0)]$ComputerName)
Get-WmiObject -ComputerName $ComputerName Win32_PhysicalMemory  | Measure-Object Capacity -Sum  | Format-Table -AutoSize @{Name=$ComputerName+" Total(GB)";Expression={$_.Sum / 1GB}; Format="F2"; Alignment="Right"}
$UsedRAM = 0
$SUTotal = 0
$VMs = Get-VM -ComputerName $ComputerName
foreach ($VM in $VMs)
    {
    $RAMAllocation = [ordered]@{'Name' = $VM.Name;
    'Assigned(GB)' = [Math]::Round($VM.MemoryAssigned/1GB,2);
    'Startup(GB)' = [Math]::Round($VM.MemoryStartup/1GB,2);
    'Dynamic'=$VM.DynamicMemoryEnabled}
    $obj = New-Object -TypeName PSObject -Property $RAMAllocation
    Write-Output -InputObject $obj
    $UsedRAM = $obj.'Assigned(GB)' + $UsedRAM
    $SUTotal = $obj.'Startup(GB)' + $SUTotal
    }
$AllocatedRAM = [ordered]@{'Name'='TotalUsed';
'Assigned(GB)' = $UsedRAM;
'Startup(GB)' = $SUTotal;
'Dynamic' = 'N/A'}
$AllocatedTotal = New-Object -TypeName PSObject -Property $AllocatedRAM
Write-Output -InputObject $AllocatedTotal
}

$cluster =  Get-Service -Name ClusSvc -ErrorAction SilentlyContinue
if ($cluster)
    {
    Get-ClusterNode | ForEach-Object {Get-MemoryAllocation -ComputerName $_.Name}
    }
else
    {
    Get-MemoryAllocation -ComputerName $ENV:COMPUTERNAME
    }
