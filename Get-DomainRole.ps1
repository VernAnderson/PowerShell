$DomainRole = (Get-WmiObject Win32_ComputerSystem).DomainRole
switch ($DomainRole) {
0 {"Stand Alone Workstation"}
1 {"Member Workstation"}
2 {"Standalone Server"}
3 {"Member Server"}
4 {"Backup Domain Controller"}
5 {"Primary Domain Controller"}
}
