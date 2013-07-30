function Get-SecDeviceInventory 
{


     <#

        Synopsis
        Control 1: Inventory of Authorized and Unauthorized Devices
        Uses AD to generate a list of devices that are on the network, exports it to a XML document.
        Checks to see if a baseline exists, and if one does not, renames the current report to the baseline, then runs itself again. Upon completion, calls sister-function
   
    #>

    $list = @()

    [string]$filename = Get-DateISO8601 -Prefix ".\Device-Inventory" -Suffix ".xml"
    $listMaker = Get-ADComputer -Filter *

    foreach($name in $listMaker){
        $comps = Get-ADComputer -Identity $name
      
        $objects = New-Object PSObject 
        $objects | Add-Member -MemberType NoteProperty -Name "Name" -Value $($comps | Select-Object -ExpandProperty Name)
        $objects | Add-Member -MemberType NoteProperty -Name "DistinguishedName" -Value $($comps | Select-Object -ExpandProperty DistinguishedName)
        $objects | Add-Member -MemberType NoteProperty -Name "DNSHostName" -Value $($comps | Select-Object -ExpandProperty DNSHostName)
        $objects | Add-Member -MemberType NoteProperty -Name "SAMAccountName" -Value $($comps | Select-Object -ExpandProperty SAMAccountName)
        $objects | Add-Member -MemberType NoteProperty -Name "ObjGUID" -Value $($comps | Select-Object -ExpandProperty ObjectGUID)
       
        $list += $objects
    
    }
    Export-Clixml -InputObject $list -Path $filename
    
    if(-NOT(Test-Path ".\Baselines\Device-Inventory-Baseline.xml"))
	    {
		    Rename-Item $filename "Device-Inventory-Baseline.xml"
            Move-Item ".\Device-Inventory-Baseline.xml" .\Baselines
            if(Test-Path ".\Baselines\Device-Inventory-Baseline.xml"){
		        Write-Warning "Baseline list now created"
	   	        Invoke-Expression $MyInvocation.MyCommand
            }
	    }
    else
        {
            Compare-SecDeviceInventory
        }
        
}
