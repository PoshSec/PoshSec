function Get-SecDisabledAccount {

    $filename = Get-DateISO8601 -Prefix "Disabled-Accounts" -Suffix ".xml"
    
    Search-ADAccount -AccountDisabled | Export-Clixml $filename
    if(-NOT(Test-Path ".\Baselines\Disabled-Baseline.xml"))
    {
	    Rename-Item $filename "Disabled-Baseline.xml"
	    Move-Item ".\Disabled-Baseline.xml" .\Baselines
        if(Test-Path ".\Baselines\Disabled-Baseline.xml"){
   	        Write-Warning "The disabled account baseline has been created, running the script again."
            Invoke-Expression $MyInvocation.MyCommand
        }
	    
    }
    [System.Array]$current = Import-Clixml $filename
    [System.Array]$approved = Import-Clixml ".\Baselines\Disabled-Baseline.xml"
    
    Move-Item $filename .\Reports

    $exception = Get-DateISO8601 -Prefix "Disabled-Exceptions" -Suffix ".xml"

    Compare-Object -ReferenceObject $approved -DifferenceObject $current -CaseSensitive | Export-Clixml  ".\Exception-Reports\$exception"

    <#    
    .SYNOPSIS
        Gets list of disabled accounts.
    .DESCRIPTION
        Gets list of disabled in the domain.
    .EXAMPLE
        PS> Get-SecDisabledAccount
            CN=Matt Johnson,OU=IS,DC=PoshSec,DC=com
            CN=Rich Cassara,OU=IS,DC=PoshSec,DC=com
            ..
    .LINK
        www.poshsec.com
    .NOTES
        This function is a PoshSec module.
    #>
}
