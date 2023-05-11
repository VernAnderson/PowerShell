<#
.Synopsis
   Gets the domain role of the current computer
.DESCRIPTION
   This script will get the domain role property from a WMI class, which is a number system. It translates that number to a human readable string based on the documentation from Microsoft as it relates to that property and number.
.EXAMPLE
   .\Get-DomainRole.ps1
.OUTPUTS
   The output is a human readable string of the computers domain role. For example Primary Domain Controller if that computer holds the PDC Emulater FSMO role
.NOTES
   This script is also a great example of a real world use for the "switch" construct in PowerShell
#>
$DomainRole = (Get-WmiObject Win32_ComputerSystem).DomainRole
switch ($DomainRole) {
0 {"Stand Alone Workstation"}
1 {"Member Workstation"}
2 {"Standalone Server"}
3 {"Member Server"}
4 {"Backup Domain Controller"}
5 {"Primary Domain Controller"}
}
