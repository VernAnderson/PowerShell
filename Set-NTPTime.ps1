<#
.Synopsis
   Sets up NTP time sync properly
.DESCRIPTION
   Sets the NTP time settings used by the Windows Time service to sync time based on Microsoft Best practices for domain joined computers according to their role
.EXAMPLE
   .\Set-NTPTime.ps1
.EXAMPLE
   
.OUTPUTS
   This command generates the proper syntax and sends it to the w32tm.exe command line utility
.NOTES
   This command should be used with caution on Windows Clusters as the cluster service depends on the time service. Time is also extremely important for proper logon and kerberos tickets from Active Directory. One should never turn their backs on time -Casta
way
#>
$DomainRole = (Get-WmiObject Win32_ComputerSystem).DomainRole
switch ($DomainRole)
    {
    0 {"Stand Alone Workstation" ; $SYNCType = "MANUAL"}
    1 {"Member Workstation" ; $SYNCType = "DOMHIER"}
    2 {"Standalone Server" ; $SYNCType = "MANUAL"}
    3 {"Member Server" ; $SYNCType = "DOMHIER"}
    4 {"Backup Domain Controller" ; $SYNCType = "DOMHIER"}
    5 {"Primary Domain Controller" ; $SYNCType = "MANUAL"}
    }

if ($SYNCType -ne $Null)
    {
    $FilePath = Get-ChildItem C:\Windows\system*\w32tm.exe -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName
    cmd.exe /c "$FilePath /config /update /manualpeerlist:time.nist.gov /syncfromflags:$SYNCType"
    }
cmd.exe /c "$FilePath /dumpreg /subkey:Parameters"
