## https://www.webrunapps.com/
## https://github.com/dan-osull/PowerShell-Script-Menu-Gui
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

<#
On the desktop website:

There are two ways to access your saved posts:

Go to https://www.facebook.com/help/220284408163249.
On your Facebook homepage, look for Saved in the left sidebar menu under the Explore section.
Clicking on either option will take you to your saved items page, which displays all your saved posts and collections.

Additional tips:

You can use the filter option on the saved items page to sort your saved content by type (posts, links, events, etc.).
To remove a post from your saved list, tap the three-dot icon next to the post and select Unsave.
Facebook allows you to create collections to organize your saved posts into categories. You can find the option to create new collections on both the mobile app and desktop website.
#>
