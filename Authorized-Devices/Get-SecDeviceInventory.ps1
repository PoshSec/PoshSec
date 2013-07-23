function Get-SecDeviceInventory 
{

     <#

        Synopsis
        Control 1: Inventory of Authorized and Unauthorized Devices
        Uses AD to generate a list of devices that are on the network, exports it to a XML document.
        Checks to see if a baseline exists, and if one does not, renames the current report to the baseline, then runs itself again. Upon completion, calls sister-function
   
    #>

    [string]$filename = Get-DateISO8601 -Prefix ".\Device-Inventory" -Suffix ".xml"
    Get-ADComputer -Filter * | Select-Object DistinguishedName,DNSHostName,Name,SAMAccountName,ObjectGUID | Export-Clixml $filename
 
    if(-NOT(Test-Path ".\Baselines\Device-Inventory-Baseline.xml"))
	    {
		    Rename-Item $filename "Device-Inventory-Baseline.xml"
            Move-Item ".\Device-Inventory-Baseline.xml" .\Baselines
		    Write-Warning "Baseline list now created"
	   	    Invoke-Expression $MyInvocation.MyCommand
	    }
    else
        {
            Compare-SecDeviceInventory
        }
        
}

