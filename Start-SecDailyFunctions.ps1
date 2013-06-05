  function Start-SecDailyFunctions

{
    
    <#
    To perform the necessary daily functions of PoshSec
    Rather than establish baselines, this is to organize and continue reporting.
    #>
    
   
    Get-SecDeviceList
    Get-SecSoftwareInstalled 
    Get-SecSoftwareIntegrity
    Get-SecOpenPort
    Get-SecExpiredAccounts
    Get-SecAdminAccounts
    Get-SecLockedOutAccounts
    Get-SecDisabledAccounts
    Compare-SecDeviceList
    Compare-SecSoftwareInstalled
    Compare-SecSoftwareVersion
    Compare-SecSoftwareIntegrity
    Compare-SecOpenPort


}
