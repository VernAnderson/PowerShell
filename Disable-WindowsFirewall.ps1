<#
.Synopsis
   Affectively disables the Windows Firewall
.DESCRIPTION
   You should never stop the Windows Firewall Services. Instead it is recommended that you disable the profiles. I do not remember the side affects caused by disabling the service but this is the recommended way. It should only be done if you are behind a ph
ysical firewall or some other device that secures your network ports and access.
.EXAMPLE
   .\Disable-WindowsFirewall.ps1
.EXAMPLE
   Import-Module NetSecurity ; Get-NetFirewallProfile | Set-NetfirewallProfile -Enabled False
.OUTPUTS
   This script generates no output unless you include the "-PassThru" switch on the end of the "set-netfirewallprofile" command
.NOTES
   This is less of a script, it's really just a one liner
#>
Import-Module NetSecurity ; Get-NetFirewallProfile | Set-NetfirewallProfile -Enabled False

# This also works by itself
# Set-NetFirewallProfile -Enabled False
