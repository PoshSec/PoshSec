function Get-SecLockedOutAccounts {

    $list = @()

    $adsiSearcher = New-Object DirectoryServices.DirectorySearcher("LDAP://rootdse")
    $adsiSearcher.filter = "ObjectCategory=User"
    
    $adsiSearcher.findAll() | 
    ForEach-Object {
        If(([adsi]$_.path).psbase.invokeGet("IsAccountLocked")) {
            $list = $list + ([adsi]$_.path).DistinguishedName
        }
    } 

    Write-Output $list

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