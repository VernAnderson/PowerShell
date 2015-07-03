function Recycle-Item ($Path)
    {
    $objShell = New-Object -ComObject Shell.Application
    $objFolder = $objShell.Namespace(0xA)
    $objFolder.MoveHere($Path)   
    }
