function Get-SecWAPs
{
    <#
    
    Uses individual workstations and generates a list of access points, baselines them and compares.
    
    #>


    $computer = Get-Content Env:\COMPUTERNAME
    $filename = Get-DateISO8601 -Prefix ".\$computer-WAPS" -Suffix ".xml"


    netsh wlan show network | Export-Clixml $filename

    if(-NOT(Test-Path ".\Baselines\$computer-WAP-Baseline.xml"))
    {
        Rename-Item $filename "$computer-WAP-Baseline.xml"
        Move-Item ".\$computer-WAP-Baseline.xml" .\Baselines
         Write-Warning "The baseline file for this computer has been created, running this script again."
        Invoke-Expression $MyInvocation.MyCommand
	    
    }

	else
    {
        [System.Array]$approved = Import-Clixml -Path ".\Baselines\$computer-WAPS-Baseline.xml"
        [System.Array]$installed = Import-Clixml -Path $filename

        Move-Item $filename .\Reports

        [string]$filename = Get-DateISO8601 -Prefix ".\$computer-WAPS-Exception-Report" -Suffix ".xml"
        Compare-Object $approved $installed -Property | Export-Clixml  ".\Exception-Reports\$filename"

        # The script can be emailed for review or processing in the ticketing system:
        # Send-MailMessage -To -Subject "Installed software exception for $computer" -Body "The report is attached." -Attachments $filename
    }

    
}
