<#
.Synopsis
   Gets a list of running services sorted by the service with the most dependancies at the top
.DESCRIPTION
   This script gets a list of services and queries each one for how many services depend on each service and sorts the one with the most dependancies at the top of the list
.EXAMPLE
   .\Get-ServiceSortDependency.ps1
.EXAMPLE
   Get-Service * | Where-Object {$_.Status -ne 'Stopped'} | ForEach-Object {$_.ServicesDependedOn} | Group-Object DisplayName | Sort-Object Count -Descending | Format-Table Count,Name -AutoSize
.OUTPUTS
   The output is a list of services eventually sent to "group-object" with the output sorted by count in descending order
.NOTES
   This is actually a one liner. However, the idea is when you have a server such as Exchange and you want to restart those services, it can be helpful to know what order they will need to be stopped and you would need to stop the ones with the most dependen
cies last to avoid errors about "this service cannot be stopped" or warnings stating that if you stop that service it will cause these other services to be stopped. Then they would also most likely need to be started in the opposite order.
#>
Get-Service * | Where-Object {$_.Status -ne 'Stopped'} | ForEach-Object {$_.ServicesDependedOn} | Group-Object DisplayName | Sort-Object Count -Descending | Format-Table Count,Name -AutoSize
