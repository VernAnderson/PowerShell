<#
.Synopsis
   Stops Server Manager from running every time you log on
.DESCRIPTION
   This one liner will delete the Windows Scheduled Task that causes Server Manager to run upon logon. If you find that annoying this is the PowerShell way to fix it.
.EXAMPLE
   Get-ScheduledTask ServerManager | Disable-ScheduledTask
.OUTPUTS
   This script does not generate any output
.NOTES
   This is not a script per say it is more of a one liner
#>
Get-ScheduledTask ServerManager | Disable-ScheduledTask
