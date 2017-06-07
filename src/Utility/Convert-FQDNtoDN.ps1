Function Convert-FQDNtoDN
{
    <#
      .SYNOPSIS
        Converts FQDN to DN
      .DESCRIPTION
        This converts a user supplied Fully Qualified DOmain Name (FQDN) into a Distinguished Name (DN).
      .PARAMETER domainFQDN
        This is the Fully Qualified Domain Name (FQDN) that needs to be turned into a Distinguished Name (DN).
      .NOTES
        This is a PoshSec Utility Function.
      .EXAMPLE
        Convert-SecFQDNtoDN -domainFQDN 'poshsec.com'

        DC=poshsec,DC=com
      .EXAMPLE
        Convert-SecFQDNtoDN 'dev.contoso.net'

        DC=dev,DC=contoso,DC=NET

    #>

    [CmdletBinding()]
    param (
      [Parameter(Mandatory=$true)]
      [string]$domainFQDN
    )
    Write-Verbose -Message "Entered FQDN: $domainFQDN"
    Write-Verbose -Message 'Splitting FQDN by periods.'
    $colSplit = $domainFQDN.Split('.')

    Write-Verbose -Message 'Getting Size of FQDN Split Collection'
    $FQDNdepth = $colSplit.length

    Write-Verbose -Message 'Emptying out $DomainDN variable'
    $DomainDN = ''

    Write-Verbose -Message 'Loop through FQDN Split Collection'
    for ($x=0; $x -lt ($FQDNdepth); $x++)
    {
        Write-Verbose -Message 'Determining the seperator between each level.'
        if ($x -eq ($FQDNdepth - 1)) {
          $Separator=''
        } else {
          $Separator=','
        }

        [string]$DomainDN += 'DC=' + $colSplit[$x] + $Separator
    }

    Write-Verbose "The final DN is $DomainDN"
    Write-Output $DomainDN

}
