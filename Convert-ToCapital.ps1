.Synopsis
   "Converts the first charecter in a string to a capital letter"
.DESCRIPTION
   "Breaks a string of alpha characters apart and joins it back together making the first character upper case or ""Title"" case"
.EXAMPLE
   Convert-ToCapital joe
.EXAMPLE
   Convert-ToCapital "superDuper"
.OUTPUTS
   "The function will output a string with the first letter being upper case"
.NOTES
   "This script was just a fun project if it were complete it would include checks to insure the string is not numeric"
function Convert-ToCapital ($String="vern"){
[string]$1stLetter = $String[0]
$CapLetter = $1stLetter.ToUpper()
$CapLetter+$String.Substring(1)}
