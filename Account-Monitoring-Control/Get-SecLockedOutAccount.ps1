function Get-SecLockedOutAccount {
    [CmdletBinding()]
    param(
        [switch]$CreateBaseline
    )

     if (Get-Module -Name "ActiveDirectory" -ErrorAction SilentlyContinue) {
        Write-Verbose -Message "Using Active Directory Cmdlets"
        $list = Search-ADAccount -LockedOut
    } else {

        $list = @()

        $adsiSearcher = New-Object DirectoryServices.DirectorySearcher("LDAP://rootdse")
        $adsiSearcher.filter = "ObjectCategory=User"
    
        $adsiSearcher.findAll() |
        ForEach-Object {
          If(([adsi]$_.path).psbase.invokeGet("IsAccountLocked")) {
              $list = $list + ([adsi]$_.path).DistinguishedName
          }
        } 
    }

     if ($CreateBaseline) {
        $filename = Get-DateISO8601 -Prefix "Never-Expire" -Suffix ".xml"
        Write-Verbose -Message "Creating baseline. Filename is $filename"
        $list | Export-Clixml $filename
    } else {
        $list
    }
 
   
   

    <#    
    .SYNOPSIS
        Gets current users that are locked out.
    .DESCRIPTION
        This function gets the current users in the domain who are locked out.
    .EXAMPLE
        PS> Get-SecLockedOutAccount
            CN=Matt Johnson,OU=IS,DC=PoshSec,DC=com
            CN=Rich Cassara,OU=IS,DC=PoshSec,DC=com
    .LINK
        www.poshsec.com
    .NOTES
        This function is a PoshSec module.
    #>
}
