$Steps = 0..101
foreach ($Step in $Steps)
    {
    Clear-Host
    $Head = 'O'
    if ($Step % 2 -eq 0)
        {
        $Arms = '↙|↘'
        $Legs = '/\'
        Write-Host -Object $Head.PadLeft($Step) -ForegroundColor Green
        Write-Host -Object $Arms.PadLeft($Step) -ForegroundColor Green
        Write-Host -Object $Legs.PadLeft($Step) -ForegroundColor Green
        }
    else
        {
        $Arms = '|'
        $Legs = '‖'
        Write-Host -Object $Head.PadLeft($Step) -ForegroundColor Green
        Write-Host -Object $Arms.PadLeft($Step) -ForegroundColor Green
        Write-Host -Object $Legs.PadLeft($Step) -ForegroundColor Green
        }
    Start-Sleep -Milliseconds 125
    }
$Step = 0