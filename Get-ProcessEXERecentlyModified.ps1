$90days = (Get-Date).AddDays(-90)
Get-Process | Select-Object Path -Unique | Get-Item | Where-Object {$_.LastWriteTime -gt $90days} | Format-Table LastWriteTime,Name
