<#
.Synopsis
   Extract a ZIP Archive to a folder path
.DESCRIPTION
   This function extracts a ZIP file placing its contents into a folder path you provide using .NET 4.5 Windows ZIP library
.EXAMPLE
   Unzip-File -Source D:\foldername -Destination D:\fullpath\zipfilename.zip
.EXAMPLE
   Unzip-File -Source D:\fullpath\onefile\or\more\*.ps1 -Destination D:\fullpath\myscripts.zip
#>
# Source = Files to UNZIP normally should be a path to a ZIP file D:\fullpath\zipfilename.zip (with ZIP extension)
# Destination = The name of a folder that will be created in the current path
 
# Load the built in ZIP Assembly from Windows
[Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
function Unzip-File ($ZIPFile, $Destination)
    {
    if (Test-Path -Path $Destination)
        {
        Write-Verbose "The exists and we are ready to extract to that location"
        }
    else
        {
        Write-Host -ForegroundColor Cyan -Object "The destination folder does not exist"
        Write-Host -ForegroundColor Green -Object "Creating the folder for you"
        New-Item -Path $Destination -ItemType Directory | Out-Null
        }
    if (Test-Path -Path $ZIPFile)
        {
        Write-Verbose -Message "The Zip file is there ready to be extracted"
        }
    else
        {
        Write-Error -Message "The ZIP File could not be found in the path that was provided" -ErrorAction Stop
        }
    $ZIPFile = Get-ChildItem -LiteralPath $ZIPFile -ErrorAction SilentlyContinue
    $Destination = Get-Item -LiteralPath $Destination -ErrorAction SilentlyContinue
    # Now extract the zip file
    [System.IO.Compression.ZipFile]::ExtractToDirectory($ZIPFile,$Destination)
    Get-ChildItem -Path $Destination
    }
