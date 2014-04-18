function Compare-SecDeviceList
{


    
    [String]$filename = Get-DateISO8601 -Prefix ".\Device-Inventory" -Suffix ".xml"

    [System.Array]$approved = Import-Clixml -Path ".\Device-Inventory-Baseline.xml"
    [System.Array]$installed = Import-Clixml -Path $filename
    
    Move-Item $filename .\Reports

    [String]$filename = Get-DateISO8601 -Prefix ".\Device-Inventory-Exception-Report" -Suffix ".xml"
    Compare-Object $approved $installed | Export-Clixml  ".\Exception-Reports\$filename"

    # The script can be emailed for review or processing in the ticketing system:
    # Send-MailMessage -To -Subject "Installed software exception for $computer" -Body "The report is attached." -Attachments $filename
    <#
        .SYNOPSIS
        Compare device baseline list to the current list, then exports the results into an exception report

		.DESCRIPTION
	    Automated function that is called by Get-SecDeviceInventory to compare the newly-generated list to the baseline and provide an exception report

		.LINK
			www.poshsec.com
	
		.LINK
			github.com/poshsec
    #> 


}
