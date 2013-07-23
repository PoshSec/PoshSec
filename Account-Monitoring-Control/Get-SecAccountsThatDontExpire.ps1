function Get-SecAccountsThatDontExpire {
﻿
    $filename = Get-DateISO8601 -Prefix "Never-Expire" -Suffix ".xml"
    
    Search-ADAccount -PasswordNeverExpires | Export-Clixml $filename
    [System.Array]$current = Import-Clixml $filename
    [System.Array]$approved = Import-Clixml ".\Baselines\Never-Expire-Baseline.xml"
    
    Move-Item $filename .\Reports

    $exception = Get-DateISO8601 -Prefix "Never-Expire-Exception" -Suffix ".xml"

    Compare-Object -ReferenceObject $approved -DifferenceObject $current -CaseSensitive | Export-Clixml  ".\Exception-Reports\$exception"

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
