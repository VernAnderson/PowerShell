<#
.Synopsis
   Deletes selected rows from PSReadline's history
.DESCRIPTION
   Sends the current contents of PSReadline history text file to Out-Gridview to let you select each row you want to delete and then deletes them and over writes the file
.EXAMPLE
   .\Remove-PSHistory.ps1
#>
# The path needs to be a variable so we can over write it later
$PSReadlinePath = "$ENV:USERPROFILE\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
# Get the current contents of the current PSReadline file
$ConsoleHistory = Get-Content -Path $PSReadlinePath
# Out-Gridview passes the lines that will be removed not the lines that will remain
$RemoveLines = $ConsoleHistory | Out-GridView -Title "Select which lines you would like to remove from history" -PassThru
# Build the new contents that excludes the unwanted lines
$KeepHistory = $ConsoleHistory | Where-Object {$RemoveLines -notcontains $_}
# Finally overwrite the file with the new contents
$KeepHistory | Set-Content -Path $PSReadlinePath
