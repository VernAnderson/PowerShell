<#
.Synopsis
   Gets the owner of the running processes
.DESCRIPTION
   Uses WMI Process objects to find the owner or the logon ID of the owner of each running process
.EXAMPLE
   .\Get-ProcessOwner.ps1
.OUTPUTS
   This one lineer will output a list of processes and the logon ID of who started the process
.NOTES
   This is a one liner but does not require elevation. After writing this I discovered the parameter for Get-Process explorer.exe -IncludeUserName. However, the WMI script doesn't require elevation and can run as a user so I'll keep this
#>
Get-WmiObject -Query "SELECT * from Win32_Process WHERE Caption LIKE 'explorer.exe'" | ForEach-Object {$_.GetOwner().User}
