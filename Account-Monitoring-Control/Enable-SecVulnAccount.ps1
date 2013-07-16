function Enable-Assessor
{
https://github.com/NJJacob/PoshSec/tree/0.1.5-Release/Account-Monitoring-Control/Enable-VulnAccount
    <#
    Enables an assessor account to be used with a vulnerability scanner.
    If enable is chosen, it enables the account and escalates its privileges
    If disable is chosen, demotes privileges and disables the account
    
    
    Future Additions:
    Ability to choose account 
    Automate the entirety of function during vuln scan, upon completion, demotes and disables account.
    
  
    #>

    $assessor = "Assessor Account"

    $message = "Do you want to Enable or Disable the assessor account?"

    $enable = New-Object System.Management.Automation.Host.ChoiceDescription "&Enable",`
        "Enables the assessor account."

    $disable = New-Object System.Management.Automation.Host.ChoiceDescription "&Disable",`
        "Disables the assessor account."

    $option = [System.Management.Automation.Host.ChoiceDescription[]]($enable,$disable)

    $result = $Host.UI.PromptForChoice($assessor,$message,$option, 0)

    Switch ($result)
    {
        0 {
        Enable-ADAccount "assessor" 
        Add-ADGroupMember "domain admins" "assessor"
        }
        1 {
        Remove-ADGroupMember  "domain admins"  "assessor"
        Disable-ADAccount "assessor" 
        }
    }
   
   
}
