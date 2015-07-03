Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services -EA SilentlyContinue | Where-Object {$_.Property -contains "DelayedAutoStart"}
