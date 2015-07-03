<#
.Synopsis
   Removes output from a PowerShell Transcript leaving just the commands
.DESCRIPTION
   This function will locate lines in a PowerShell Transcript that are most likely commands and not output
.EXAMPLE
   Clean-Transcript -Transcript D:\PSClass.txt -Destination D:\JustTheCommands.txt
.EXAMPLE
   Clean-Transcript D:\PSClass.txt D:\JustTheCommands.txt
#>
Function Clean-Transcript
{
    [CmdletBinding()]
    Param
    (
        # Specifies the path to a PowerShell Transcript text file
        [Parameter(Mandatory=$true,
                   Position=0)]
        $Transcript,
 
        # Specifies the path to the new text file for the output
        [Parameter(Mandatory=$true,
                   Position=1)]
        $Destination
    )
 
    Begin
    {
    if ((Test-Path $Transcript) -ne $true)  {Write-Error "The transcript file could not be found!" -ErrorAction Stop}
    if (Test-Path $Destination) {Write-Error "The destination file already exists!" -ErrorAction Stop}
    }
    Process
    {
    Get-Content $Transcript | Select-String '> [A-Za-z0-9][^[]]*' | Out-File $Destination -NoClobber -ErrorAction Stop
    Get-ChildItem $Destination
    }
    End
    {
    $Transcript = $null ; $Destination =$null
    }
}
