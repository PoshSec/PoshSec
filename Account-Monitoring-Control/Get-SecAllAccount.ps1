function Get-SecAllAccount {
    $list = @()
    $root = [ADSI]""            
    $search = [adsisearcher]$root            
    $search.Filter = "(&(objectclass=user)(objectcategory=user))"             
    $search.SizeLimit = 3000            
    $search.FindAll() | foreach {
        $list = $list + ([adsi]$_.path).DistinguishedName
    } 

    Write-Output $list

    <#    
    .SYNOPSIS
        Gets list of all accounts.
    .DESCRIPTION
        Gets list of all accounts in the domain.
    .EXAMPLE
        PS> Get-SecAllAccount
            CN=Matt Johnson,OU=IS,DC=PoshSec,DC=com
            CN=Rich Cassara,OU=IS,DC=PoshSec,DC=com
            ..
    .LINK
        www.poshsec.com
    .NOTES
        This function is a PoshSec module.
    #>
}