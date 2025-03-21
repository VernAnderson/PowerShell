<#
.Synopsis
   This script will calculate the size of each folder in the path where it is run from
.DESCRIPTION
   This script is named DU because it is meant to provide the same output as sysinternals du.exe. It recurses each folder under the current path and calculates the total size of each folder
.EXAMPLE
   CD C:\myfolder ; $PathtoDUScript\du.ps1
.OUTPUTS
   THis script will output a table of the folders in the current path and the size in MB
.NOTES
   I developed this script very early in my PowerShell learning and I still use it all the time. it is very useful especially when I have to tell people their hard drive is full. It helps them to see a summary oif what is using the space.
#>
$location = Get-Location
Get-ChildItem -Path $location -Directory |
    Select-Object @{Name="Size (MB)";Expression={(Get-ChildItem $_.Fullname -Recurse | 
    Measure-Object -Property Length -Sum).Sum/1MB}},Fullname | Sort-Object "Size (MB)" -Descending | 
    Select-Object @{Name="Size (MB)";Expression={"{0:0,0.00}" -f ($_."Size (MB)")}},Fullname | 
    Format-Table -AutoSize
