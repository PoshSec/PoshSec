function Get-AccountsThatExpire {
    $list = @()
    $root = [ADSI]""            
    $search = [adsisearcher]$root            
    $search.Filter = "(&(objectclass=user)(objectcategory=user)(!accountExpires=9223372036854775807))"             
    $search.SizeLimit = 3000            
    $search.FindAll() | foreach {            
        $list = $list + ([adsi]$_.path).DistinguishedName
    } 

    Write-Output $list
}