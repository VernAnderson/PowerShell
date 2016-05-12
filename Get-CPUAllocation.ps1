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