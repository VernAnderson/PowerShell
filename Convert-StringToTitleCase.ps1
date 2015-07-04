function Convert-ToCapital ($String="vern"){
[string]$1stLetter = $String[0]
$CapLetter = $1stLetter.ToUpper()
$CapLetter+$String.Substring(1)}
