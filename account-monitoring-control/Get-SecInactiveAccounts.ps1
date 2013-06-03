function Get-SecInactiveAccounts
{

    $filename = Get-DateISO8601 -Prefix "Inactive-Accounts" -Suffix ".xml"
    
    Search-ADAccount -AccountInactive -TimeSpan 30 | Export-Clixml $filename
    
    
}
