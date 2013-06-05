function Get-SecInactiveAccounts
{


    $filename = Get-DateISO8601 -Prefix "Inactive-Accounts" -Suffix ".xml"
    
    Search-ADAccount -AccountInactive -TimeSpan 30 | Export-Clixml $filename

    $timespan = Search-ADAccount -AccountInactive -TimeSpan 30 

    foreach ($n in $timespan)
    {
        Disable-ADAccount -Identity $n -Confirm
    }
    
    <#
    Designed to check for any accounts that have been active for 30 days.
    For each account that has, will prompt the admin to confirm disabling
    #>
   
}
