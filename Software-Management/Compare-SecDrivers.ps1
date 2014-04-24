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
    <#
    .Synopsis
        Compares the baseline of installed drivers to the newly-generated list of currently installed drivers.
    .Description
        Called by the Get function, compares the baseline of installed drivers to the newly-generated list of currently installed drivers, then provides an exception report based on the differences
        
        CSIS 20 Critical Security Controls for Effective Cyber Defense excerpt:
 	    Devise a list of authorized software that is required in the enterprise for each type of system, including servers, workstations, and laptops of various kinds and uses. This list should be tied to file integrity checking software to validate that the software 
    .Example
        Compare-SecDrivers
    .Link
        https://github.com/organizations/PoshSec
    #>
 }
