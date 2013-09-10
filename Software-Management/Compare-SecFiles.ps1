function Compare-SecFiles
 {
   
  
    [string]$computer = Get-Content env:ComputerName
    [string]$filename = Get-DateISO8601 -Prefix ".\$computer-Files" -Suffix ".xml"

    [System.Array]$approved = Import-Clixml -Path ".\Baselines\$computer-Files-Baseline.xml"
    [System.Array]$installed = Import-Clixml -Path $filename

    Move-Item $filename .\Reports

    [string]$exception = Get-DateISO8601 -Prefix ".\$computer-Files-Exception-Report" -Suffix ".xml"
    Compare-Object -ReferenceObject $approved -DifferenceObject $installed -CaseSensitive | Export-Clixml  ".\Exception-Reports\$exception"

    # The script can be emailed for review or processing in the ticketing system:
    # Send-MailMessage -To -Subject "Installed software exception for $computer" -Body "The report is attached." -Attachments $filename
 }
