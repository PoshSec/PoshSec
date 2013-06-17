﻿function Get-SecDisabledAccounts {

    $filename = Get-DateISO8601 -Prefix "Disabled-Accounts" -Suffix ".xml"
    
    Search-ADAccount -AccountDisabled | Export-Clixml $filename
    [System.Array]$current = Import-Clixml $filename
    [System.Array]$approved = Import-Clixml ".\Baselines\Disabled-Baseline.xml"
    
    Move-Item $filename .\Reports

    $exception = Get-DateISO8601 -Prefix "Disabled-Exceptions" -Suffix ".xml"

    Compare-Object $approved $current | Export-Clixml ".\Exception-Reports\$exception"

    <#    
    .SYNOPSIS
        Gets list of disabled accounts.
    .DESCRIPTION
        Gets list of disabled in the domain.
    .EXAMPLE
        PS> Get-SecAccountsThatExpire
            CN=Matt Johnson,OU=IS,DC=PoshSec,DC=com
            CN=Rich Cassara,OU=IS,DC=PoshSec,DC=com
            ..
    .LINK
        www.poshsec.com
    .NOTES
        This function is a PoshSec module.
    #>
}
