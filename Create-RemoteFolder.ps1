# Remember to enter credentials that are valid for each server in your c:\servers.txt file
$credentials = Get-Credential
$servers = Get-Content c:\servers.txt
foreach ($server in $servers)
    {    
    $scriptsFolder = Invoke-Command -ComputerName $server -Credential $credentials -ScriptBlock {Test-Path C:\Scripts}
    if ($scriptsFolder -ne $true)
        {
        Invoke-Command -ComputerName $server -Credential $credentials -ScriptBlock {New-Item C:\scripts -ItemType directory}
        }
    }
