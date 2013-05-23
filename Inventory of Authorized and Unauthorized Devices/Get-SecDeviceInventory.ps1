function Get-SecDeviceInventory 
{

$list = @()
 
$objSearcher = New-Object DirectoryServices.DirectorySearcher("LDAP://rootdse")
$objSearcher.SearchRoot = $objDomain
$objSearcher.Filter = "objectCategory=computer"
$objSearcher.FindAll() | Foreach {
    $list += ([adsi]$_.path).DistinguishedName
}
 
#Write-Output $list
 
if(-NOT(Test-Path ".\Device-Inventory-Baseline.xml"))
    {
		Write-Output $list | Export-Clixml "Device-Inventory-Baseline.xml"
		Write-Warning "Baseline list now created. Please re-run this script to check for unauthorized devices."
	
	}

[System.Array]$authorized = Import-Clixml -Path ".\Device-Inventory-Baseline.xml"

[string]$exception = Get-DateISO8601 -Prefix ".\Device-Exception-Report" -Suffix ".xml"
Compare-Object $list $authorized | Export-Clixml ".\$exception"

    # The script can be emailed for review or processing in the ticketing system:
	# Send-MailMessage -To -Subject "Device Inventory Exception" -Body "The report is attached." -Attachments $exception


}
