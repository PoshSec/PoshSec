function Get-SecInactiveAccounts
{


    $filename = Get-DateISO8601 -Prefix "Inactive-Accounts" -Suffix ".xml"
    
    Search-ADAccount -AccountInactive -TimeSpan 30 | Export-Clixml $filename

    $timespan = Search-ADAccount -AccountInactive -TimeSpan 30 

    foreach ($n in $timespan)
    {
        Disable-ADAccount -Identity $n -Confirm
    }
    
    #if Timespan > 30, then disable the account. At that point, another script should be run that will allow associated files to be encrypted.
   
}
