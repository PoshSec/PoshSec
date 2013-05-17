function Get-SecInventory {

<#
-Description Get-SecInventory 
-Synopsis "Retrieves all computer accounts for a single domain"

An array was an easier way of both collecting results and outputting them.
The strCategory was unnecessary, since it was only called in one location. It was removed to avoid redunancy
5-17: now creates a baseline list of devices when first run, then compares against baseline with subsequent runs, making a separate XML document listing the differences.

#>

$list=@()


$objDomain = New-Object System.DirectoryServices.DirectorySearcher("LDAP://rootdse")

$objSearcher.SearchRoot = $objDomain

$objSearcher.Filter = "objectCategory=computer"

$objSearcher.FindAll() | Foreach {
    $list += ([adsi]$_.path).DistinguishedName
}

if(-NOT(Test-Path ".\Device-Inventory-Baseline.xml"))
    {
    	Write-Output $list | Export-Clixml "Device-Inventory-Baseline.xml"
		Write-Warning "Baseline list now created. Please re-run this script to check 

for unauthorized devices."
	Break
	}

[System.Array]$authorized = Import-Clixml -Path ".\Device-Inventory-Baseline.xml"

[string]$exception = Get-DateISO8601 -Prefix ".\-Unauthorized-Device-Report" -Suffix ".xml"
Compare-Object $list $authorized | Export-Clixml $exception
}
