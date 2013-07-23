function Get-SecAccountsThatExpire {
    
    $filename = Get-DateISO8601 -Prefix "Expired" -Suffix ".xml"
    Search-ADAccount -AccountExpired | Export-Clixml .\$filename
    
    [System.Array]$current = Import-Clixml $filename
    [System.Array]$approved = Import-Clixml ".\Baselines\Expired-Baseline.xml"

    Move-Item $filename .\Reports

    $exception = Get-DateISO8601 -Prefix "Expired-Exception" -Suffix ".xml"

    Compare-Object -ReferenceObject $approved -DifferenceObject $current -CaseSensitive | Export-Clixml  ".\Exception-Reports\$exception"

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
