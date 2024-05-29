$folder = Add-Type -AssemblyName System.Windows.Forms
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
    RootFolder      = "MyComputer"
    Description     = "Pick a folder"   
}
    if($FolderBrowser.ShowDialog() -eq "OK")
    {
        $folder += $FolderBrowser.SelectedPath
    }
Get-ChildItem -Name $FolderBrowser.SelectedPath -Directory

<#
## Valid values for RootFolder
	ApplicationData
	CommonApplicationData
	LocalApplicationData
	Cookies
	DesktopDirectory
	Favorites
	History
	InternetCache
	MyComputer
	MyDocuments
	MyMusic
	MyPictures
	MyVideos
	Recent
	SendTo
	StartMenu
	Startup
	System
	Templates
#>