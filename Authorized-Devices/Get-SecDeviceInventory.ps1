function Get-SecDeviceInventory 
{




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
else
    {
        Compare-SecDeviceList
    }


<#
		.SYNOPSIS
	    To generate a list of all devices with an IP address in a domain
		.DESCRIPTION
	    Generates a list of devices in a domain that have an IP address, then compares that list to a previously-created baseline
		.EXAMPLE
			PS C:\> Get-SecDeviceInventory

		.LINK
			www.poshsec.com
	
		.LINK
			github.com/poshsec
	
	#>

}
