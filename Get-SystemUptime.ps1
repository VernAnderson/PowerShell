<#
.Synopsis
   Gets the current uptime in days, hours, and minutes
.DESCRIPTION
   This script queries a performance counter WMI object for the current system uptime
.EXAMPLE
   .\Get-SystemUptime.ps1
.EXAMPLE
   New-TimeSpan -Seconds (Get-WmiObject Win32_PerfFormattedData_PerfOS_System).SystemUptime | Format-Table Days,Hours,Minutes
.OUTPUTS
   This script will display the number of days, and how many hours and minutes the current computer has been up and running
.NOTES
   This can also just be a one liner but it is very useful so I saved it here
#>
New-TimeSpan -Seconds (Get-WmiObject Win32_PerfFormattedData_PerfOS_System).SystemUptime | Format-Table Days,Hours,Minutes
