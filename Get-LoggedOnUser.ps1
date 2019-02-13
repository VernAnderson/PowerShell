Get-WmiObject -Query "SELECT * from Win32_Process WHERE Caption LIKE 'explorer.exe'" | ForEach-Object {$_.GetOwner().User}
