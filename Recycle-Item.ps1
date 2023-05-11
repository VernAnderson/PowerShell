<#
.Synopsis
   Sends the object in the Path variable to the Windows Recycle bin instead of permanantly deleting it
.EXAMPLE
   Recycle-Item -Path C:\TEMP\*.del
.EXAMPLE
   Recycle-Item C:\Temp\DELEATME.txt
.OUTPUTS
   This script does not generate any output
.NOTES
   I may be improving this script in the future
#>
function Recycle-Item ($Path)
    {
    $objShell = New-Object -ComObject Shell.Application
    $objFolder = $objShell.Namespace(0xA)
    $objFolder.MoveHere($Path)   
    }
