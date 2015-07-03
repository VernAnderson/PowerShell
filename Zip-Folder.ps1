<#
.Synopsis
   Compresses a folder path to a ZIP Archive
.DESCRIPTION
   This function compresses files in a folder path to a ZIP file using the native Windows ZIP library no 3rd party DLLs needed
.EXAMPLE
   Zip-Folder -Source D:\foldername -Destination D:\fullpath\zipfilename.zip
.EXAMPLE
   Zip-Folder -Source D:\fullpath\onefile\or\more\*.ps1 -Destination D:\fullpath\myscripts.zip
#>
# Source = Files to ZIP normally should be a folder but it handles a single file or multiple files
# Destination = D:\fullpath\zipfilename.zip (with ZIP extension)
 
# Setup some global variables
$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
$includeBaseDirectory = $false # if true creates a folder within a folder
$tempName = "ZIP"+(Get-Date -Format MM-d)
[System.IO.FileInfo]$tempFolder = $env:TEMP+"\"+$tempName
 
# Load the built in ZIP Assembly from Windows
[Reflection.Assembly]::LoadWithPartialName( "System.IO.Compression.FileSystem" )
function Zip-Folder ($Source, $Destination)
    {
        if (Test-Path $Destination) {Write-Error "Zip file by that name already exists in the destination folder" -ErrorAction Stop}
        if ((Get-Item $Source).PSIsContainer -ne $true ) 
            {
            Write-Warning "Source is not a folder creating one for you"
            New-Item -Path $tempFolder -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
            Copy-Item $Source -Destination $tempFolder -Force
            $Source = $tempFolder
            }
 
    # Now create the zip file
    [System.IO.Compression.ZipFile]::CreateFromDirectory($Source,$Destination,$compressionLevel,$includeBaseDirectory)
    Remove-Item $tempFolder -Recurse -Force -ErrorAction SilentlyContinue
    }
