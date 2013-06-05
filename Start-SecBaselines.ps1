function Start-SecBaseline
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

    Get-SecDNSLogStatus
    Get-SecDeviceList
    Get-SecSoftwareInstalled 
    Get-SecSoftwareIntegrity
    Get-SecOpenPort
    Compare-SecDeviceList
    Compare-SecSoftwareInstalled
    Compare-SecSoftwareVersion
    Compare-SecSoftwareIntegrity
    Compare-SecOpenPort
    Set-SecFirewallSettings
    Set-SecLogSettings
    
}
