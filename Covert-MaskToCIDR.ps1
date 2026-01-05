<#
.Synopsis
   Convert an IP v4 MASK to CIDR notation
.DESCRIPTION
   Uses built in math and regex to convert an IPv4 MASK to CIDR notation or mask bits
.EXAMPLE
   .\Convert-MaskToCIDR.ps1 255.255.252.0
#>
Param ([Parameter(Mandatory=$true,Position=0)][ValidatePattern("^(?:25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(?:25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(?:25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(?:25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$")][string]$NetMask)
$Bits = $NetMask.Split('.') | ForEach-Object { [Convert]::ToString([int]$_, 2).PadLeft(8, '0') }
$CIDR = ($Bits -join '').TrimEnd('0').Length
Write-Host -Object "The CIDR notation of the NetMask $NetMask is a slash $CIDR" -ForegroundColor Green
