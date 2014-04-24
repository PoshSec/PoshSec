function Get-SecAccountThatExpire {
    [CmdletBinding()]
    param(
        [switch]$CreateBaseline
    )

     if (Get-Module -Name "ActiveDirectory" -ErrorAction SilentlyContinue) {
        Write-Verbose -Message "Using Active Directory Cmdlets"
        $list = Search-ADAccount -AccountExpired
    } else {

        $list = @()
        $root = [ADSI]""
        $search = [adsisearcher]$root
        $search.Filter = "(&(objectclass=user)(objectcategory=user)(!accountExpires=9223372036854775807))"
        $search.SizeLimit = 3000
        $search.FindAll() | foreach {
            $list = $list + ([adsi]$_.path).DistinguishedName
        }
    }

     if ($CreateBaseline) {
        $filename = Get-DateISO8601 -Prefix "Expire" -Suffix ".xml"
        Write-Verbose -Message "Creating baseline. Filename is $filename"
        $list | Export-Clixml $filename
    } else {
        $list
    }

    <#    
    .SYNOPSIS
        Gets list of accounts that are set to expire.
    .DESCRIPTION
        Gets list of accounts from the domain that are set to expire.
    .EXAMPLE
        PS> Get-SecAccountThatExpire
            CN=Matt Johnson,OU=IS,DC=PoshSec,DC=com
            CN=Rich Cassara,OU=IS,DC=PoshSec,DC=com
    .LINK
        www.poshsec.com
    .NOTES
        This function is a PoshSec module.
    #>
}
