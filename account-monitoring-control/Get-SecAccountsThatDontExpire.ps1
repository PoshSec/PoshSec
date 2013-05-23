function Get-SecAccountsThatDontExpire {
    $list = @()
    $root = [ADSI]""            
    $search = [adsisearcher]$root            
    $search.Filter = "(&(objectclass=user)(objectcategory=user)(accountExpires=9223372036854775807))"             
    $search.SizeLimit = 3000            
    $search.FindAll() | foreach {            
        $list = $list + ([adsi]$_.path).DistinguishedName
    } 

    Write-Output $list

    <#    
    .SYNOPSIS
        Gets a list of the accounts that don't expire.
    .DESCRIPTION
        Gets a list of the accounts from the active directory domain that don't expire.
    .EXAMPLE
        PS> Get-SecAccountsThatDontExpire
            CN=Matt Johnson,OU=IS,DC=PoshSec,DC=com
            CN=Rich Cassara,OU=IS,DC=PoshSec,DC=com
    .LINK
        www.poshsec.com
    .NOTES
        This function is a PoshSec module.
    #>
}