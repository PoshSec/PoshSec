function Get-LockedOutAccounts {

    $adsiSearcher = New-Object DirectoryServices.DirectorySearcher("LDAP://rootdse")
    $adsiSearcher.filter = "ObjectCategory=User"
    
    $adsiSearcher.findAll() | 
    ForEach-Object {
        If(([adsi]$_.path).psbase.invokeGet("IsAccountLocked")) {
            $list = $list + ([adsi]$_.path).DistinguishedName
        }
    } 

    Write-Output $list
}