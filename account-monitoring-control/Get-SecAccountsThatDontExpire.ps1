function Get-SecAccountsThatDontExpire {
﻿   <#
    $list = @()
    $root = [ADSI]""            
    $search = [adsisearcher]$root            
    $search.Filter = "(&(objectclass=user)(objectcategory=user)(accountExpires=9223372036854775807))"             
    $search.SizeLimit = 3000            
    $search.FindAll() | foreach {            
        $list = $list + ([adsi]$_.path).DistinguishedName
    } 

    Write-Output $list
<<<<<<< HEAD

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
=======
    #>
    
    
     
    $filename = Get-DateISO8601 -Prefix "Never-Expire" -Suffix ".xml"
    
    Search-ADAccount -PasswordNeverExpires | Export-Clixml $filename
    [System.Array]$current = Import-Clixml $filename
    [System.Array]$approved = Import-Clixml ".\Never-Expire-Baseline.xml"

    Compare-Object $approved $current | Export-Clixml "Never-Expire-Exception.xml"
    
}
>>>>>>> 09066c41e7cc4e5097a6cbb2cfc1d86b53ccc765
