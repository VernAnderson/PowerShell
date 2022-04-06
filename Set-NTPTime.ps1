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