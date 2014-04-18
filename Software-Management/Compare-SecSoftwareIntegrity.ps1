function Compare-SecSoftwareIntegrity
{


    	[string]$computer = Get-Content env:ComputerName
	[string]$filename = Get-DateISO8601 -Prefix ".\$computer-Integrity" -Suffix ".xml"

    	[System.Array]$approved = Import-Clixml -Path ".\Baselines\$computer-Integrity-Baseline.xml"
	[System.Array]$installed = Import-Clixml -Path $filename
	
	Move-Item $filename .\Reports

	[string]$exception = Get-DateISO8601 -Prefix ".\$computer-Integrity-Exception-Report" -Suffix ".xml"
	Compare-Object $approved $installed | Export-Clixml ".\Exception-Reports\$exception"

	# The script can be emailed for review or processing in the ticketing system:
	# Send-MailMessage -To -Subject "Installed software exception for $computer" -Body "The report is attached." -Attachments $filename
    <#
    .Synopsis
        Compares the installed software properties baseline to a newly-generated XML file
    .Description
        Compares the installed software properties baseline to a newly-generated XML file, then creates an exception report based on the differneces.
        
        CSIS 20 Critical Security Controls for Effective Cyber Defense excerpt:
		Devise a list of authorized software that is required in the enterprise for each type of system, including servers, workstations, and laptops of various kinds and uses. This list should be tied to file integrity checking software to validate that the software 
    .Example
        Compare-SecSoftwareIntegrity
    .Link
        https://github.com/organizations/PoshSec
    #>
}
