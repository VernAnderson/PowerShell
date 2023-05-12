<#
.Synopsis
   Gets a list of installed applications
.DESCRIPTION
   This script is a one liner, but it queries WMI for a list of installed applications like appwiz.cpl
.EXAMPLE
   .\Get-InstalledApps.ps1
.OUTPUTS
   This script outputs a list of the Name,Vendor, and Version of each installed application
.NOTES
   In each WMI Object there is also the GUID for each application which is used by the "Uninstall-Application.ps1" on this same repository. You can also query registry keys to get a list much faster than WMI. However, that list does not have that GUID for un
    installing the app.
#>
Get-WmiObject Win32_Product | Format-Table Name,Vendor,Version
