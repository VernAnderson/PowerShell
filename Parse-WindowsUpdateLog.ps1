# Does not work with Server 2016 and newer nor Windows 10 and newer
Select-String -Path $env:windir\WindowsUpdate.log -Pattern 'successfully installed' |
  ForEach-Object {
    $information = $_ | Select-Object -Property Date, LineNumber, Product
    $parts = $_.Line -split '\t'
    [DateTime]$information.Date = $parts[0] + ' ' + $parts[1].SubString(0,8) 
    $information.Product = ($_.Line -split 'following update: ')[-1]

    $information
  } | Format-Table Date,Product -AutoSize
