function Set-SecFirewallSettings
{
    <#
        Synopsis
        Sets the firewall settings for all profiles, includes log settings with Set-SecFirewallLog
                
    #>

    Write-Warning "Establishing firewall configurations and logging."
    #Establish Firewall Rules
    Set-NetFirewallProfile -All -LogAllowed True -LogBlocked True -NotifyOnListen True
    Set-NetFirewallProfile -All -LogMaxSizeKilobytes 10240
    Write-Warning "Firewall Logging now configured and enabled"
    Set-NetFirewallProfile -All -Enabled True
    Write-Warning "Firewall now enabled"


}
