function Get-PasswordsOverExpireDate {
    param (
        [int]$days
    )
    $list = @()
    $root = [ADSI]""            
    $search = [adsisearcher]$root            
    $search.Filter = "(&(objectclass=user)(objectcategory=user))"             
    $search.SizeLimit = 3000            
    $search.FindAll() | foreach {
        $pwdset = [datetime]::fromfiletime($_.properties.item("pwdLastSet")[0])
        $age = (New-TimeSpan $pwdset).Days

        if ($age -gt $days) {
            $list = $list + ([adsi]$_.path).DistinguishedName
        }
    } 

    Write-Output $list
}