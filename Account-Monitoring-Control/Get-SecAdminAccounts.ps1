function Get-SecAdminAccounts
{
    
    <#
      Synopsis
      Gets a list of accounts that are members of various administrator groups, then compares it to the baseline list
    
    
    
    $filename = Get-DateISO8601 -Prefix "Admin-Report" -Suffix ".xml"
    
    Get-ADGroupMember -Identity administrators | Export-Clixml $filename
    [System.Array]$current = Import-Clixml $filename
    [System.Array]$approved = Import-Clixml ".\Admin-Baseline.xml"

    Compare-Object $approved $current | Export-Clixml "Admin-Exceptions.xml"
    

}
