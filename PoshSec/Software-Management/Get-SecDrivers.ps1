function Get-SecDrivers
{

    $computer = Get-Content env:ComputerName
    $filename = Get-DateISO8601 -Prefix ".\$computer-Drivers" -Suffix ".xml"
   
   
    Get-WmiObject win32_systemdriver | Select-Object 
    
    Export-Clixml -InputObject $driver -Path  $filename

     if(-NOT(Test-Path ".\Baselines\$computer-Drivers-Baseline.xml"))
       {
            Rename-Item $filename "$computer-Drivers-Baseline.xml"
            Move-Item ".\$computer-Drivers-Baseline.xml" .\Baselines
            Write-Warning  "The baseline file for this computer has been created, now running the script again."
            Invoke-Expression $MyInvocation.MyCommand
        }

       else
    {
        Compare-SecDrivers
    }
    
    <#
		.SYNOPSIS
        Generates a list of drivers, then calls compare function to generate an exception report	
		
	
		.EXAMPLE
			PS C:\> Get-SecDrivers

		.LINK
			www.poshsec.com
	
		.LINK
			github.com/poshsec
	
	#> 

}
