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
