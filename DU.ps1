$location = Get-Location
Get-ChildItem $location | Where-Object { $_.PSIScontainer } |
    Select @{Name="Size (MB)";Expression={(Get-ChildItem $_.Fullname -Recurse | 
    Measure-Object -Property Length -Sum).Sum/1MB}},Fullname | Sort-Object "Size (MB)" -Descending | 
    Select-Object @{Name="Size (MB)";Expression={"{0:0,0.00}" -f ($_."Size (MB)")}},Fullname | 
    Format-Table -AutoSize
