function Enable-Assessor
{
https://github.com/NJJacob/PoshSec/tree/0.1.5-Release/Account-Monitoring-Control/Enable-VulnAccount
    <#
    Enables an assessor account to be used with a vulnerability scanner.
    If enable is chosen, it enables the account and escalates its privileges
    If disable is chosen, demotes privileges and disables the account
    
    
    Future Additions:
    Ability to choose account 
      
    #>

    $account = Read-Host 'What is the SAM Account Name of the account that will be used?'
    $group = Read-Host 'What group is the account being added to?'
    Enable-ADAccount $account 
    Add-ADGroupMember $group $account
    Start-Sleep -Seconds 21600
    
    Remove-ADGroupMember -Identity $group -Members $account -Confirm:$false
    Disable-ADAccount $account 
  
}
