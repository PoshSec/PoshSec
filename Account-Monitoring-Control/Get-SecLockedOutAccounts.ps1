function Get-SecLockedOutAccounts {
 
    $filename = Get-DateISO8601 -Prefix "Locked-Out" -Suffix ".xml"
    Search-ADAccount -LockedOut | Export-Clixml .\$filename
    
    [System.Array]$current = Import-Clixml $filename
    [System.Array]$approved = Import-Clixml ".\Baselines\Locked-Baseline.xml"

    Move-Item $filename .\Reports

    $exception = Get-DateISO8601 -Prefix "Locked-Exception" -Suffix ".xml"

    Compare-Object $approved $current | Export-Clixml ".\Exception-Reports\$exception"
   

    <#    
    .SYNOPSIS
        Gets current users that are locked out.
    .DESCRIPTION
        This function gets the current users in the domain who are locked out.
    .EXAMPLE
        PS> Get-SecLockedOutAccounts
            CN=Matt Johnson,OU=IS,DC=PoshSec,DC=com
            CN=Rich Cassara,OU=IS,DC=PoshSec,DC=com
    .LINK
        www.poshsec.com
    .NOTES
        This function is a PoshSec module.
    #>
}
