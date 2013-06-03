function Get-SecDisabledAccounts {
<#
    $list = @()

    $adsiSearcher = New-Object DirectoryServices.DirectorySearcher("LDAP://rootdse")
    $adsiSearcher.filter = "(&(objectClass=user)(objectCategory=user))"
    
    $adsiSearcher.findAll() |
    ForEach-Object {
        $disabled = ([adsi]$_.path).psbase.invokeGet("useraccountcontrol")
        if ($disabled -and 0x2) {
            $list = $list + ([adsi]$_.path).DistinguishedName
        }

    }

    Write-Output $list
#>

 $filename = Get-DateISO8601 -Prefix "Disabled-Accounts" -Suffix ".xml"
    
    Search-ADAccount -AccountDisabled | Export-Clixml $filename
    [System.Array]$current = Import-Clixml $filename
    [System.Array]$approved = Import-Clixml ".\Disabled-Baseline.xml"

    Compare-Object $approved $current | Export-Clixml "Disabled-Exception.xml"

}
