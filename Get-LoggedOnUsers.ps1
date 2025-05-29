$UserProfiles = Get-WmiObject -Query "SELECT * FROM Win32_UserProfile  WHERE Special != TRUE AND Loaded = TRUE"
foreach ($UserProfile in $UserProfiles)
    {
    $UserID = $UserProfile.LocalPath.Split('\') | Select-Object -Last 1
    $LoginTable = [ordered]@{'LoginID'=$UserID}
    $LoginID = New-Object -TypeName PSObject -Property $LoginTable
    Write-Output -InputObject $LoginID
    }
