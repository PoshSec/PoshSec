function Get-DisabledAccounts {

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
}