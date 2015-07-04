New-TimeSpan -Seconds (Get-WmiObject Win32_PerfFormattedData_PerfOS_System).SystemUptime | Format-Table Days,Hours,Minutes
