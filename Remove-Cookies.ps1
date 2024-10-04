<#
.Synopsis
   Removes Cookies from modern web browsers Edge, Chrome, Firefox, and Opera
.DESCRIPTION
   Modern browsers no longer use individual TXT files with the domain name they use SQLite databases instead. This script reads those databases and presents a list of cookies by domain so that you can remove unwanted cookies such as advertisers.
.EXAMPLE
   .\Remove-Cookies.ps1
.CREDITS
   Thanks to RamblingCookieMonsterfor "Warren F" the PSSQLite module https://github.com/RamblingCookieMonster/PSSQLite
#>
 ## Install-Module PSSQLite -Scope CurrentUser ## If the module is not installed yet
 Write-Warning -Message "Your browsers will need to not be running" ## Should go without saying but I forget this every time LOL
Import-Module -Name PSSQLite

$MSEdgeDatabase = "$ENV:USERPROFILE\AppData\Local\Microsoft\Edge\User Data\Default\Network\Cookies"
$MSEdgeUnwanted = Invoke-SqliteQuery -DataSource $MSEdgeDatabase -Query "SELECT * FROM cookies" | Sort-Object host_key -Unique | Select-Object host_key | Out-GridView -Title "Select the EDGE cookies you do not want" -PassThru
foreach ($MSEdgeCookie in $MSEdgeUnwanted)
    {
    $MSEdgeHostKey = $MSEdgeCookie.host_key
    $MSEdgeQuery = "DELETE FROM cookies where host_key = " + "'" + $MSEdgeHostKey + "'" + ';'
    Invoke-SqliteQuery -DataSource $MSEdgeDatabase -Query $MSEdgeQuery -Verbose
    }

$ChromeDatabase = "$ENV:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Network\Cookies"
$ChromeUnwanted = Invoke-SqliteQuery -DataSource $ChromeDatabase -Query "SELECT * FROM cookies" | Sort-Object host_key -Unique | Select-Object host_key | Out-GridView -Title "Select the CHROME cookies you do not want" -PassThru
foreach ($ChromeCookie in $ChromeUnwanted)
    {
    $ChromeHostKey = $ChromeCookie.host_key
    $ChromeQuery = "DELETE FROM cookies where host_key = " + "'" + $ChromeHostKey + "'" + ';'
    Invoke-SqliteQuery -DataSource $ChromeDatabase -Query $ChromeQuery -Verbose
    }

$FireFoxDatabase = Get-ChildItem -Path "$ENV:USERPROFILE\AppData\Roaming\Mozilla\Firefox\Profiles\cookies.sqlite" -Recurse | Sort-Object LastWriteTime | Select-Object -Last 1 -Property FullName
$FireFoxUnwanted = Invoke-SqliteQuery -DataSource $FireFoxDatabase -Query "SELECT * FROM cookies" | Sort-Object host_key -Unique | Select-Object host_key | Out-GridView -Title "Select the FIREFOX cookies you do not want" -PassThru
foreach ($FireFoxCookie in $FireFoxUnwanted)
    {
    $FireFoxHostKey = $FireFoxCookie.host_key
    $FireFoxQuery = "DELETE FROM cookies where host_key = " + "'" + $FireFoxHostKey + "'" + ';'
    Invoke-SqliteQuery -DataSource $FireFoxDatabase -Query $FireFoxQuery -Verbose
    }

$OperaDatabase = "$ENV:USERPROFILE\AppData\Roaming\Opera Software\Opera Stable\Network\Cookies"
$OperaUnwanted = Invoke-SqliteQuery -DataSource $OperaDatabase -Query "SELECT * FROM cookies" | Sort-Object host_key -Unique | Select-Object host_key | Out-GridView -Title "Select the OPERA cookies you do not want" -PassThru
foreach ($OperaCookie in $OperaUnwanted)
    {
    $OperaHostKey = $OperaCookie.host_key
    $OperaQuery = "DELETE FROM cookies where host_key = " + "'" + $OperaHostKey + "'" + ';'
    Invoke-SqliteQuery -DataSource $OperaDatabase -Query $OperaQuery -Verbose
    }
