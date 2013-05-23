function Get-SecAccountsThatExpire {
    $list = @()
    $root = [ADSI]""            
    $search = [adsisearcher]$root            
    $search.Filter = "(&(objectclass=user)(objectcategory=user)(!accountExpires=9223372036854775807))"             
    $search.SizeLimit = 3000            
    $search.FindAll() | foreach {            
        $list = $list + ([adsi]$_.path).DistinguishedName
    } 

    Write-Output $list

    <#    
    .SYNOPSIS
        Gets list of accounts that are set to expire.
    .DESCRIPTION
        Gets list of accounts from the domain that are set to expire.
    .EXAMPLE
        PS> Get-SecAccountsThatExpire
            CN=Matt Johnson,OU=IS,DC=PoshSec,DC=com
            CN=Rich Cassara,OU=IS,DC=PoshSec,DC=com
    .LINK
        www.poshsec.com
    .NOTES
        This function is a PoshSec module.
    #>
}