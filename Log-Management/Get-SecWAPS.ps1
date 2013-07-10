function Get-SecWAPs
{

    <#
    Synopsis
    To use each workstation as a sensor, by checking for available wireless networks and comparing it to the baseline of networks
    This works with CSIS Control 7 Wireless Device Control
    #>

    $computer = Get-Content Env:\COMPUTERNAME
    $filename = Get-DateISO8601 -Prefix ".\$computer-WAP" -Suffix ".xml"


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
        [System.Array]$approved = Import-Clixml -Path ".\Baselines\$computer-WAP-Baseline.xml"
        [System.Array]$installed = Import-Clixml -Path $filename

        Move-Item $filename .\Reports

        [string]$filename = Get-DateISO8601 -Prefix ".\$computer-WAP-Exception-Report" -Suffix ".xml"
        Compare-Object $approved $installed -Property | Export-Clixml  ".\Exception-Reports\$filename"

        # The script can be emailed for review or processing in the ticketing system:
        # Send-MailMessage -To -Subject "Wireless access point exception for $computer" -Body "The report is attached." -Attachments $filename
    }

    
}
