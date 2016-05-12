<#
.Synopsis
    Generates Hyper-V storage allocation report
.DESCRIPTION
    This script will generate VM resource allocation information to provide an idea of how much you have used and what is still available
.EXAMPLE
    Get-StorageAllocation
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

Function Get-ComputeVolumes
{
$volumes = Get-ClusterSharedVolume
foreach ($volume in $volumes)
    {
    $ClusterDisk = $volume.Name
    $OwnerNode = $volume.OwnerNode.Name
    $VolumeName = $volume.SharedVolumeInfo.FriendlyVolumeName
    $VolumeInfo = Get-Volume -FilePath $volume.SharedVolumeInfo.FriendlyVolumeName
    $VolumeSize = [Math]::Round($VolumeInfo.Size /1GB)
    $VolumeFree = [Math]::Round($VolumeInfo.SizeRemaining /1GB)
    $VolumeUsed = ($VolumeSize - $VolumeFree)
    $VolumeLabel = $VolumeInfo.FileSystemLabel
    $CSVObject = [ordered]@{'VolumeName'=$VolumeName;'VolumeTotalGB'=$VolumeSize;'VolumeUsedGB'=$VolumeUsed;'VolumeFreeGB'=$VolumeFree;'VolumeLabel'=$VolumeLabel;'ClusterDisk'=$ClusterDisk;'OwnerNode'=$OwnerNode}
    $VolumeObj = New-Object -TypeName PSObject -Property $CSVObject
    Write-Output -InputObject $VolumeObj
    } # end foreach volume
}

Function Get-AllocatedStorage
{
$VMs = Get-VM -ComputerName $Node
$SizeTotal = 0
$CurrentTotal = 0
foreach ($VM in $VMs)
    {
    $VMName = $VM.VMName | Select-Object -First 1
    $VMDisks = Get-VMHardDiskDrive -ComputerName $Node -VMName $VM.VMName
    $VHDPaths = $VMDisks.Path
    foreach ($Path in $VHDPaths)
        {
        $VHDs = Get-VHD -ComputerName $Node -Path $Path
        #$OwnerNode = $VHDs.ComputerName
        $TotalSize = [Math]::Round($VHDs.Size/1GB,2)
        $CurrentSize = [Math]::Round($VHDs.FileSize/1GB,2)
        $SizeTotal = $TotalSize + $SizeTotal
        $CurrentTotal = $CurrentSize + $CurrentTotal
        $Allocation = [ordered]@{'VMName' = $VMName;
            'TotalSizeGB' = $TotalSize;
            'CurrentSizeGB' = $CurrentSize} # end hashtable # Owner Node is costly
        $obj = New-Object -TypeName PSObject -Property $Allocation
        Write-Output -InputObject $obj
        } # end foreach path
    $Total = [ordered]@{'VMName' = "Total";
            'TotalSizeGB' = $SizeTotal;
            'CurrentSizeGB' = $CurrentTotal}
    $objTotal = New-Object -TypeName PSObject -Property $Total
    } # end foreach VM
    Write-Output -InputObject $objTotal
}

$cluster =  Get-Service -Name ClusSvc -ErrorAction SilentlyContinue
if ($cluster)
    {
    Get-ComputeVolumes | Sort-Object VolumeName | Format-Table -AutoSize
    $ClusterNodes = Get-ClusterNode | Select-Object -ExpandProperty Name
    foreach ($Node in $ClusterNodes)
        {
        Write-Host -ForegroundColor Green -Object $Node
        Get-AllocatedStorage | Format-Table -AutoSize | more
        }
    }
else
    {
    $Node = $ENV:COMPUTERNAME
    Get-Volume
    Get-AllocatedStorage | Format-Table -AutoSize | more
    }
