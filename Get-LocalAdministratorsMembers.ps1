<#
.Synopsis
   Get the members of the local Administrators Group
.DESCRIPTION
   This script will list the members of the local Administrators Group using WMI not ADSI
.EXAMPLE
   .\Get-LocalAdministratorsMembers.ps1
#>
$GroupComponent = "Win32_Group.Domain=""$env:COMPUTERNAME"",Name=""Administrators"""
$PartComponent = Get-WmiObject -Query "SELECT PartComponent FROM Win32_GroupUser WHERE GroupComponent='$GroupComponent'"
foreach ($Part in $PartComponent)
    {
    $Part.PartComponent -split "Name=" | Select-Object -Last 1
    }
