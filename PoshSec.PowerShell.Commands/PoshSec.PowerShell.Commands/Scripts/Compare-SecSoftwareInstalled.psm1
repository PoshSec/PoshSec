 function Compare-SecSoftwareInstalled
 {
  
    [string]$computer = Get-Content env:ComputerName
    [string]$filename = Get-DateISO8601 -Prefix ".\$computer-Software" -Suffix ".xml"

    [System.Array]$approved = Import-Clixml -Path ".\$computer-Installed-Baseline.xml"
    [System.Array]$installed = Import-Clixml -Path $filename

    [string]$filename = Get-DateISO8601 -Prefix ".\$computer-Installed-Exception-Report" -Suffix ".xml"
    Compare-Object $approved $installed | Export-Clixml  ".\Reports\$filename"

    # The script can be emailed for review or processing in the ticketing system:
    # Send-MailMessage -To -Subject "Installed software exception for $computer" -Body "The report is attached." -Attachments $filename

 }
