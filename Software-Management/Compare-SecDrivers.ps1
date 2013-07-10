function Compare-SecDrivers
 {
   
  
    [string]$computer = Get-Content env:ComputerName
    [string]$filename = Get-DateISO8601 -Prefix ".\$computer-Drivers" -Suffix ".xml"

    [System.Array]$approved = Import-Clixml -Path ".\Baselines\$computer-Drivers-Baseline.xml"
    [System.Array]$installed = Import-Clixml -Path $filename

    Move-Item $filename .\Reports

    [string]$filename = Get-DateISO8601 -Prefix ".\$computer-Drivers-Exception-Report" -Suffix ".xml"
    Compare-Object $approved $installed | Export-Clixml  ".\Exception-Reports\$filename"

    # The script can be emailed for review or processing in the ticketing system:
    # Send-MailMessage -To -Subject "Installed software exception for $computer" -Body "The report is attached." -Attachments $filename
 }
