function Get-SecADComputerInventory {
    [CmdletBinding()]
    param()

    Write-Verbose -Message 'Creating object container.'
    $list = @()
    
    Write-Verbose -Message 'Connect to ADSISearcher Object'
    $adsi = [adsisearcher]''
    Write-Verbose -Message 'Set ADSI Filter to only filter on computer objects.'
    $adsi.Filter = 'objectCategory=computer'
    
    Write-Verbose -Message 'Create collection of computers in domain.'
    $results = $adsi.FindAll()
    
    Write-Verbose -Message "Cycle through $($results.Count) computer object"
    foreach ($adsiComputer in $results) {
        Write-Verbose -Message "Processing computer: $($adsiComputer.Properties.cn)"
        $tempObject = New-Object -TypeName 'PSObject'
        $tempObject | Add-Member -MemberType 'NoteProperty' -Name 'Name' -Value $adsiComputer.Properties.cn
        $tempObject | Add-Member -MemberType 'NoteProperty' -Name 'DistinguishedName' -Value $adsiComputer.Properties.distinguishedname
        $tempObject | Add-Member -MemberType 'NoteProperty' -Name 'DNSHostName' -Value $adsiComputer.Properties.dnshostname
        $tempObject | Add-Member -MemberType 'NoteProperty' -Name 'SamAccountName' -Value $adsiComputer.Properties.samaccountname
        $tempObject | Add-Member -MemberType 'NoteProperty' -Name 'ObjGuid' -Value $adsiComputer.Properties.objectguid
    
        Write-Verbose -Message 'Adding computer object to larger computer collection'
        $list += $tempObject
    }
    Write-Verbose -Message "Outputing $($results.Count) objects"   
    Write-Output -InputObject $list
<#
.SYNOPSIS
This function gets all computer objects located in the current user's domain.
Author: Matthew Johnson (@mwjcomputing)
Project: PoshSec/Authorized-Devices
License: BSD-3
Required Dependencies: None
Optional Dependencies: None
.DESCRIPTION
Get-SecADComputerInventory gets all computer objects located in the current user's domain.
.INPUTS
None
.OUTPUTS
PSObject
.EXAMPLE
Get-SecADComputerInventory
.NOTES
This function is part of the PoshSec PowerShell Module's Authorized Devices submodule. 

The items that are returned for each computer are the CN, DistinguishedName, DNSHostName, SamAccountName and ObjGuid.
These values are gathered from an ADSI connection into the current user's current domain.
.LINK
http://www.poshsec.com/
.LINK
https://github.com/PoshSec
#>
}
