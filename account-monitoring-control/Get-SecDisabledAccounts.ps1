function Get-SecDisabledAccounts {

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

    Write-Output $list

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