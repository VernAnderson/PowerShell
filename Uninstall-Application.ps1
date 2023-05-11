<#
.Synopsis
   Removes an application or software product from Windows
.DESCRIPTION
   I ran into a server running Windows Core and there were no GUI tools such as appwiz.cpl so I had to figure this out. This script will generate a list and display it in "grid view" and whicever applications you select will be sent down the pipeline to the 
uninstall method defined by that application
.EXAMPLE
   .\Uninstall-Application.ps1
.OUTPUTS
   This script does not really display any output
.NOTES
   I still need to test this version
#>
Get-WmiObject Win32_Product | Out-GridView -Title "Select the application you wish to unistall from Windows" -PassThru | Invoke-WmiMethod -Name "Uninstall" -WhatIf
