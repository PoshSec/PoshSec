function Compare-SecDeviceInventory
{
<#
    Synopsis
    Compare device baseline list to the current list, then exports the results into an exception report
#>

    
    [String]$filename = Get-DateISO8601 -Prefix ".\Device-Inventory" -Suffix ".xml"

    [System.Array]$approved = Import-Clixml -Path ".\Device-Inventory-Baseline.xml"
    [System.Array]$installed = Import-Clixml -Path $filename
    
    Move-Item $filename .\Reports

    [String]$exception = Get-DateISO8601 -Prefix ".\Device-Inventory-Exception-Report" -Suffix ".xml"
    Compare-Object -ReferenceObject $approved -DifferenceObject $installed -CaseSensitive | Export-Clixml  ".\Exception-Reports\$exception"

    # The script can be emailed for review or processing in the ticketing system:
    # Send-MailMessage -To -Subject "Installed software exception for $computer" -Body "The report is attached." -Attachments $filename

}
