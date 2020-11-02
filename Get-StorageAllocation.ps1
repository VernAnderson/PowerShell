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

Function Get-CSVPercentFree
{
$volumes = Get-ClusterSharedVolume
foreach ($volume in $volumes)
    {
    $ClusterDisk = $volume.Name
    $OwnerNode = $volume.OwnerNode.Name
    $VolumeName = $volume.SharedVolumeInfo.FriendlyVolumeName
    $VolumeInfo = $volume | Select-Object -ExpandProperty SharedVolumeInfo | Select-Object FriendlyVolumeName -ExpandProperty Partition
    $VolumeSize = [Math]::Round($VolumeInfo.Size /1GB)
    $VolumeUsed = [Math]::Round($VolumeInfo.UsedSpace /1GB)
    $VolumeFree = [Math]::Round($VolumeInfo.FreeSpace /1GB)
    $PercentFree = [Math]::Round($VolumeInfo.PercentFree)
    $CSVObject = [ordered]@{'VolumeName'=$VolumeName;'VolumeTotalGB'=$VolumeSize;'VolumeUsedGB'=$VolumeUsed;'VolumeFreeGB'=$VolumeFree;'PercentFree'=$PercentFree;'ClusterDisk'=$ClusterDisk;'OwnerNode'=$OwnerNode}
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

Function Get-LocalDiskInfo
{
$LogicalDisks = Get-CimInstance -ClassName Win32_LogicalDisk
foreach ($Disk in $LogicalDisks)
    {
    $DriveLetter = $Disk.Name
    $FileSystemlabel = $Disk.VolumeName
    $Size = [Math]::Round($Disk.Size /1GB)
    $UsedSpace = [Math]::Round(($Disk.Size - $Disk.FreeSpace) /1GB)
    $FreeSpace = [Math]::Round($Disk.FreeSpace /1GB)
    $Query = 'SELECT PercentFreeSpace,FreeMegabytes FROM Win32_PerfFormattedData_PerfDisk_LogicalDisk WHERE Name=''' + $DriveLetter + "'"
    $FreeStuff = Get-CimInstance -Query $Query
    $PercentFree = $FreeStuff.PercentFreeSpace
    $DiskInfo = [ordered]@{'Drive' = $DriveLetter;
        'FileSystemlabel' = $FileSystemlabel;
        'Size(GB)'= $Size;
        'Used Space (GB)'= ($Size - $FreeSpace);
        'FreeSpace(GB)'= $FreeSpace;
        'FreeSpace(%)' = $PercentFree}
    $obj = New-Object -TypeName PSObject -Property $DiskInfo
    Write-Output -InputObject $obj
    } # end foreach Disk
}

$SharedStorage = Get-ClusterSharedVolume -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Measure-Object | Select-Object -ExpandProperty Count
if ($SharedStorage -ge 1)
    {
    Get-CSVPercentFree | Sort-Object -Property PercentFree | Format-Table -AutoSize
    $ClusterNodes = Get-ClusterNode | Select-Object -ExpandProperty Name
    foreach ($Node in $ClusterNodes)
        {
        Write-Host -ForegroundColor Green -Object $Node
        Get-AllocatedStorage | Format-Table -AutoSize
        }
    }
else
    {
    $Node = $ENV:COMPUTERNAME
    Get-LocalDiskInfo | Format-Table -AutoSize
    Get-AllocatedStorage | Format-Table -AutoSize
    }
