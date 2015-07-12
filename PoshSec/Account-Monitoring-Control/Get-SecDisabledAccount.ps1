function Get-SecDisabledAccount {
    [CmdletBinding()]
    param(
        [switch]$CreateBaseline
    )

     if (Get-Module -Name "ActiveDirectory" -ErrorAction SilentlyContinue) {
        Write-Verbose -Message "Using Active Directory Cmdlets"
        $list = Search-ADAccount -AccountDisabled
    } else {

        $list = @()

        $adsiSearcher = New-Object DirectoryServices.DirectorySearcher("LDAP://rootdse")
        $adsiSearcher.filter = "(&(objectClass=user)(objectCategory=person))"
        
        $adsiSearcher.findAll() |
        ForEach-Object {
            $disabled = ([adsi]$_.path).psbase.invokeGet("useraccountcontrol")
            if ($disabled -band 0x2) {
                $list = $list + ([adsi]$_.path).DistinguishedName
            }
        }
    }

     if ($CreateBaseline) {
        $filename = Get-DateISO8601 -Prefix "Disabled-Accounts" -Suffix ".xml"
        Write-Verbose -Message "Creating baseline. Filename is $filename"
        $list | Export-Clixml $filename
    } else {
        $list
    }

    
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
