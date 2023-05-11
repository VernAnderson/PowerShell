<#
.Synopsis
   Gets a list of services where the start type is automatic but is "delayed start"
.DESCRIPTION
   This script applies to newer versions of Windows where setting s service to delayed start was an option. It will query the Windows Registry keys where that property can be found and return a list of just those service with "Delayed Start"
.EXAMPLE
   .\Get-DelayedServices.ps1
.EXAMPLE
   Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services -EA SilentlyContinue | Where-Object {$_.Property -contains "DelayedAutoStart"}
.OUTPUTS
   Displays a list of services on the screen where the starup type of the service is automatic with "Delayed Start"
.NOTES
   This is just a one liner and not really a script per say
#>
Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services -EA SilentlyContinue | Where-Object {$_.Property -contains "DelayedAutoStart"}
