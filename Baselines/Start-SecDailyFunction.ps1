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
    Get-SecWAP
    Get-SecExpiredAccount
    Get-SecAdminAccount
    Get-SecLockedOutAccount
    Get-SecDisabledAccount
    Get-SecFile


}
