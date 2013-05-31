function Get-SecAccountsThatDontExpire {
﻿   <#
    $list = @()
    $root = [ADSI]""            
    $search = [adsisearcher]$root            
    $search.Filter = "(&(objectclass=user)(objectcategory=user)(accountExpires=9223372036854775807))"             
    $search.SizeLimit = 3000            
    $search.FindAll() | foreach {            
        $list = $list + ([adsi]$_.path).DistinguishedName
    } 

    Write-Output $list
    #>
    
    
     
    $filename = Get-DateISO8601 -Prefix "Never-Expire" -Suffix ".xml"
    
    Search-ADAccount -PasswordNeverExpires | Export-Clixml $filename
    [System.Array]$current = Import-Clixml $filename
    [System.Array]$approved = Import-Clixml ".\Never-Expire-Baseline.xml"

    Compare-Object $approved $current | Export-Clixml "Never-Expire-Exception.xml"
    
}
