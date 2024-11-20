$objShell = New-Object -ComObject Shell.Application
$objRecycleBin = $objShell.Namespace(0xA)
$RecycledItems = $objRecycleBin.Items()
Function Get-RecycledItems
{
foreach ($RecycledItem in $RecycledItems)
    {
    $Name = $RecycledItem.Name
    $DateDeleted = $RecycledItem.ExtendedProperty("System.Recycle.DateDeleted")
    $OriginalLocation = $RecycledItem.ExtendedProperty("System.Recycle.DeletedFrom")
    $RecycledTable = [ordered]@{'Name'=$Name;'DateDeleted'=$DateDeleted;'OriginalLocation'=$OriginalLocation}
    $RecycledObject = New-Object -TypeName PSObject -Property $RecycledTable
    Write-Output -InputObject $RecycledObject
    }
}
$SelectedItems = Get-RecycledItems | Sort-Object DateDeleted | Out-GridView -Title "Select the items you would like to have restored" -PassThru
foreach ($SelectedItem in $SelectedItems)
    {
    $Undelete = $objRecycleBin.Items() | Where-Object {$_.Name -like $SelectedItem.Name}
    $Undelete.InvokeVerb("undelete")
    }
