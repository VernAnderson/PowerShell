<#
.Synopsis
    Generates Hyper-V CPU allocation report
.DESCRIPTION
    This script will generate VM resource allocation information to provide an idea of how much you have used and what is still available
.EXAMPLE
    Get-CPUAllocation
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

Function Get-CPUAllocation
{
Param ([Parameter(Mandatory=$true,Position=0)]$ComputerName)
$UsedCPU = 0
$ComputerSystem = Get-WmiObject -ComputerName $ComputerName Win32_ComputerSystem
$HypCPU = @{($ComputerSystem.Name+" CPU(s)") = $ComputerSystem.NumberOfLogicalProcessors}
$CPUobject = New-Object -TypeName PSObject -Property $HypCPU
Format-Table -InputObject $CPUobject -AutoSize
$VMs = Get-VM -ComputerName $ComputerName
foreach ($VM in $VMs)
    {
    $CPUAllocation = [ordered]@{'Name' = $VM.Name;
    'CPU(s)'= $VM.ProcessorCount}
    $obj = New-Object -TypeName PSObject -Property $CPUAllocation
    Write-Output -InputObject $obj
    $UsedCPU = $VM.ProcessorCount  + $UsedCPU
    }
$AllocatedCPU = [ordered]@{'Name'='TotalUsed';'CPU(s)'= $UsedCPU}
$UsedCPUTotal = New-Object -TypeName PSObject -Property $AllocatedCPU
Write-Output -InputObject $UsedCPUTotal
}

$cluster =  Get-Service -Name ClusSvc -ErrorAction SilentlyContinue
if ($cluster)
    {
    Get-ClusterNode | ForEach-Object {Get-CPUAllocation -ComputerName $_.Name}
    }
else
    {
    Get-CPUAllocation -ComputerName $ENV:COMPUTERNAME
    }
