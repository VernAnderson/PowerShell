Get-WmiObject -Query "SELECT * from Win32_Process WHERE Caption LIKE 'explorer.exe'" | ForEach-Object {$_.GetOwner().User}

# After writing this I discovered the parameter for Get-Process explorer.exe -IncludeUserName
# However, the WMI script doesn't require elevation and can run as a user so I'll keep this
