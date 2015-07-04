Get-Service * | Where-Object {$_.Status -ne 'Stopped'} | ForEach-Object {$_.ServicesDependedOn} | Group-Object DisplayName | Sort-Object Count -Descending | Format-Table Count,Name -AutoSize
