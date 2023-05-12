<#
.Synopsis
   This script gets scheduled tasks in older versions of Windows
.DESCRIPTION
   This script queries and XML file that used to be used by Windows for scheduled tasks. Microsoft has since changed that and PowerShell now has CMDLETs build in for scheduled tasks
.EXAMPLE
   .\Get-SheduledTasks.ps1
.EXAMPLE
   Get-ScheduledTask #The newer built in CMDLET by Microsoft
.OUTPUTS
   Outputs the task name, whether it is enabled or disabled, the "triggers", the next scheduled run time, and the author
.NOTES
   This script no longer works on Windows newer than 2012 or Windows 7
#>
$ErrorActionPreference = 'SilentlyContinue'
Set-Location $ENV:SystemRoot\System32\Tasks
Get-ChildItem | Where-Object {!$_.PSIsContainer} |
ForEach-Object {
    [xml]$tasks = get-content $_.FullName
    $NextRun = $tasks.task.Triggers.CalendarTrigger.StartBoundary
    @{"Name"=$_.Name},
    @{"Enabled"=$tasks.task.Settings.Enabled},
    @{"Triggers"=$tasks.task.triggers.Childnodes},
    @{"NextRun"=[datetime]$NextRun},
    @{"Author"=$tasks.Task.RegistrationInfo.Author}
    } | FT -AutoSize
