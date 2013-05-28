function Get-SecDeviceInventory 
{


<#
    Synopsis
    To generate a list of devices on the network and then export it to an XML document.



    
#>

$list = @()

[string]$filename = Get-DateISO8601 -Prefix ".\Device-Inventory" -Suffix ".xml" 

$objSearcher = New-Object DirectoryServices.DirectorySearcher("LDAP://rootdse")
$objSearcher.SearchRoot = $objDomain
$objSearcher.Filter = "objectCategory=computer"
$objSearcher.FindAll() | Foreach {
    $list += ([adsi]$_.path).DistinguishedName
}
 
Write-Output $list | Export-Clixml $filename

if(-NOT(Test-Path ".\Device-Inventory-Baseline.xml"))
	{
		Rename-Item $filename ".\Device-Inventory-Baseline.xml"
		Write-Warning "Baseline list now created"
	   	Invoke-Expression $MyInvocation.MyCommand
	}



}
