<#
.Synopsis
   Outputs the size of the objects in the specified directory
.DESCRIPTION
   Measures the size of each object in the specified path and determines the unit of measure that is appropriate for each item
.EXAMPLE
   .\Get-DirectoryUsage.ps1
.EXAMPLE
   .\Get-DirectoryUsage.ps1 -Path C:\ | Sort-Object Unit,Size -Descending | Format-Table -AutoSize
#>
Param ([Parameter(Mandatory=$False,Position=0)]$Path=".")
Push-Location
$TopItems = Get-ChildItem -Path $Path -Force -ErrorAction SilentlyContinue
foreach ($Item in $TopItems)
    {
    if ($Item.GetType().Name -like 'DirectoryInfo')
        {
        $Name = $Item.Name
        $SubDirBytes = Get-ChildItem -Path $Item.Fullname -File -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum | Select-Object -ExpandProperty Sum
        if ($SubDirBytes -ge 1048576)
            {
            $SubDirMB = [Math]::Round($SubDirBytes /1MB)
            $FolderObject = [ordered]@{'Name'=$Name;'Size'=$SubDirMB;'Unit'="MB"}
            }
        elseif ($SubDirBytes -ge 1024)
            {
            $SubDirKB = [Math]::Round($SubDirBytes /1KB)
            $FolderObject = [ordered]@{'Name'=$Name;'Size'=$SubDirKB;'Unit'='KB'}
            }
        elseif ($SubDirBytes -gt 0) {$FolderObject = [ordered]@{'Name'=$Name;'Size'=$SubDirBytes;'Unit'='Bytes'}}
        else {$FolderObject = [ordered]@{'Name'=$Name;'Size'=0;'Unit'='Bytes'}}
        $ObjectInfo = New-Object -TypeName PSObject -Property $FolderObject
        }
    else
        {
        $Name = $Item.Name
        $FileBytes=$Item.Length
        if ($FileBytes -ge 1048576)
            {
            $FileMB = [Math]::Round($FileBytes /1MB)
            $FileObject = [ordered]@{'Name'=$Name;'Size'=$FileMB;'Unit'='MB'}
            }
        elseif ($FileBytes -ge 1024)
            {
            $FileKB = [Math]::Round($FileBytes /1KB)
            $FileObject = [ordered]@{'Name'=$Name;'Size'=$FileKB;'Unit'='KB'}
            }
        else {$FileObject = [ordered]@{'Name'=$Name;'Size'=$FileBytes;'Unit'='Bytes'}}
        $ObjectInfo = New-Object -TypeName PSObject -Property $FileObject
        } # end else Type is like "FileInfo"
    Write-Output -InputObject $ObjectInfo
    }
Pop-Location