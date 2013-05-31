function Get-SecInventory {

<#
-Description Get-SecInventory 
-Synopsis "Retrieves all computer accounts for a single domain"

An array was an easier way of both collecting results and outputting them.
The strCategory was unnecessary, since it was only called in one location. It was removed to avoid redunancy

#>

$list=@()


$objDomain = New-Object System.DirectoryServices.DirectorySearcher("LDAP://rootdse")

$objSearcher.SearchRoot = $objDomain

$objSearcher.Filter = "objectCategory=computer"

$objSearcher.FindAll() | Foreach {
    $list = $list + ([adsi]$_.path).DistinguishedName
}

Write-Output $list
    
}
