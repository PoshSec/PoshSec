function Get-SecWAPs
{

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
        Compare-SecWAPs
    }

    
}
