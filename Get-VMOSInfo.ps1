Function Get-VMIntrinsicData
{
$KvpExchangeComponent = Get-WmiObject -Namespace "root\virtualization\v2" -Query "SELECT * FROM Msvm_KvpExchangeComponent"
foreach ($KVP in $KvpExchangeComponent)
    {
    $VMID = $KVP.SystemName
    $GuestIntrinsicExchangeItems = $KVP.GuestIntrinsicExchangeItems
    $VMName = Get-VM -Id $VMID | Select-Object -ExpandProperty Name
    $VMObject = New-Object -TypeName PSObject
    Add-Member -InputObject $VMObject -Name 'VMName' -Value $VMName -MemberType NoteProperty
    foreach ($KeyValuePair in $GuestIntrinsicExchangeItems)
        {
        # Write-Host -Object $VMName -ForegroundColor Cyan
        $PropertyName = ([XML]$KeyValuePair).INSTANCE.PROPERTY.VALUE | Select-Object -First 2 | Select-Object -Last 1
        $PropertyValue = ([XML]$KeyValuePair).INSTANCE.PROPERTY.VALUE | Select-Object -First 2 | Select-Object -First 1
        if ($PropertyValue -match "deprecated")
            {
            $PropertyValue = "N/A"
            }
        else
            {
            $PropertyValue = $PropertyValue
            }
        Add-Member -InputObject $VMObject -Name $PropertyName -Value $PropertyValue  -MemberType NoteProperty
        }
    Write-Output -InputObject $VMObject
    }
}
Get-VMIntrinsicData | Format-Table VMName,OSName,NetworkAddressIPv4,IntegrationServicesVersion,FullyQualifiedDomainName -AutoSize -Wrap

<#
All available Properties include the following
VMName                     
CSDVersion                 
FullyQualifiedDomainName   
IntegrationServicesVersion 
NetworkAddressIPv4                                    
NetworkAddressIPv6                                    
OSBuildNumber              
OSEditionId                
OSMajorVersion             
OSMinorVersion             
OSName                     
OSPlatformId               
OSSignature                
OSVendor                   
OSVersion                  
ProcessorArchitecture      
ProductType                
RDPAddressIPv4                                        
RDPAddressIPv6                                        
ServicePackMajor           
ServicePackMinor           
SuiteMask                  
#>
