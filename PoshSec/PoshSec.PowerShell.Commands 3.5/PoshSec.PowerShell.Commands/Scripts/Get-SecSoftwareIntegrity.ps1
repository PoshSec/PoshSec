function Get-SecSoftwareIntegrity
{


	[string]$computer = Get-Content env:ComputerName
	[string]$filename = Get-DateISO8601 -Prefix ".\$computer-Integrity" -Suffix ".xml"
	Get-SecFileIntegrity | Export-Clixml -Path $filename
	
	[System.Array]$approved = Import-Clixml -Path ".\$computer-Integrity-Baseline.xml"
	[System.Array]$installed = Import-Clixml -Path $filename
	
<<<<<<< HEAD:PoshSec.PowerShell.Commands 3.5/PoshSec.PowerShell.Commands/Scripts/Get-SecSoftwareIntegrity.ps1
	    
    if(-NOT(Test-Path ".\Baselines\$computer-Integrity-Baseline.xml"))
    {
	    Rename-Item $filename "$computer-Integrity-Baseline.xml"
	    Move-Item ".\$computer-Integrity-Baseline.xml" .\Baselines
   	    Write-Warning "The baseline file for this computer has been created, please run this script again."
            Invoke-Expression $MyInvocation.MyCommand
	    
    }
    else
    {
        Compare-SecSoftwareIntegrity
    }
	
=======
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
>>>>>>> d659574ba51394548ce0499d2bbc40bbc9c8043d:Software-Management/Compare-SecSoftwareIntegrity.ps1
}
