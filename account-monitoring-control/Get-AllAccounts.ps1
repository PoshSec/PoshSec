function Get-AllAccounts {
    param (
        [int]$days
    )
    $list = @()
    $root = [ADSI]""            
    $search = [adsisearcher]$root            
    $search.Filter = "(&(objectclass=user)(objectcategory=user))"             
    $search.SizeLimit = 3000            
    $search.FindAll() | foreach {
        $list = $list + ([adsi]$_.path).DistinguishedName
    } 

    Write-Output $list
}