function Start-SecBaselines
{
     
    <#
        Concept: Creates the baseline files for comparison later. Must be run as an administrator, then disable administrator priveleges.
        
        Steps of Implementation:
            1. Check for proper directories (.\Exception-Reports)
            3. Run Scripts
            4. Send current Exception-Reports to Admin


     #>
    
        
    if(-NOT(Test-Path ".\Exception-Reports"))
        {
            New-Item .\Exception-Reports -type directory
        }
    if(-NOT(Test-Path ".\Baselines"))
        {
            New-Item .\Baselines -type directory
        }
    if(-NOT(Test-Path ".\Reports"))
        {
            New-Item .\Reports -type directory
        }
    
    Get-ADGroupMember -Identity administrators | Export-Clixml ".\Baselines\Admin-Baseline.xml"
    Search-ADAccount -PasswordNeverExpires | Export-Clixml ".\Baselines\Never-Expires-Baseline.xml"
    Search-ADAccount -AccountExpired | Export-Clixml ".\Baselines\Expired-Baseline.xml"
    Search-ADAccount -AccountDisabled | Export-Clixml ".\Baselines\Disabled-Baseline.xml"
    Search-ADAccount -LockedOut | Export-Clixml ".\Baselines\Locked-Baseline.xml"

    $DomainRole = (Get-WmiObject Win32_ComputerSystem).DomainRole  
        $IsDC = $False  
        if ($DomainRole -gt 3) {  
            $IsDC = $True  
                           
        } 
             
      
        #If not a DC, run specific scripts  
        if ($IsDC -ne $true) {  
        
        Get-SecSoftwareInstalled 
        Get-SecSoftwareIntegrity
        Get-SecOpenPorts
        Set-SecFirewallSettings
        Set-SecLogSettings
        Get-SecDrivers
        Get-SecWAPs
        Get-SecFiles
  
             
        } 
        else {  
              
        
        Get-SecDeviceInventory
        Get-SecSoftwareInstalled 
        Get-SecSoftwareIntegrity
        Get-SecOpenPorts
        Set-SecFirewallSettings
        Set-SecLogSettings
        Get-SecDrivers
        Get-SecFiles  
        }
    
}
