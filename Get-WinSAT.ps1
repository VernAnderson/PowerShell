#Requires -RunAsAdministrator         
$WinSAT = Get-ChildItem -Path $ENV:SystemRoot -Recurse -Include WinSAT.exe -ErrorAction SilentlyContinue | Where-Object {$_.Directory -notmatch "WinSxS"}
Set-Location $WinSAT.Directory
Start-Process -FilePath .\WinSAT.exe -ArgumentList "formal" -NoNewWindow -Wait
Set-Location $ENV:SystemRoot
Set-Location .\Performance\WinSAT\DataStore\
$results = Get-Childitem *formal* | Sort-Object LastWriteTime | Select-Object -Last 1 -ExpandProperty FullName
[xml]$WinSATformal = Get-Content $results
$WinSATformal.WinSAT.WinSPR | Select-Object CpuScore,MemoryScore,GraphicsScore,GamingScore,DiskScore,SystemScore
