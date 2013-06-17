 function Compare-SecSoftwareInstalled
 {
    <#
    .Synopsis
        Examines the installed software of a machine and exports it to an XML file. If a baseline has not been created, establishes it as a baseline
    .Description
        Baselines the installed software to an XML file.
        
        CSIS 20 Critical Security Controls for Effective Cyber Defense excerpt:
 	Devise a list of authorized software that is required in the enterprise for each type of system, including servers, workstations, and laptops of various kinds and uses. This list should be tied to file integrity checking software to validate that the software 
    .Example
        Get-InstalledSoftware
    .Link
        https://github.com/organizations/PoshSec
    #>
  
    [string]$computer = Get-Content env:ComputerName
    [string]$filename = Get-DateISO8601 -Prefix ".\$computer-Software" -Suffix ".xml"

    [System.Array]$approved = Import-Clixml -Path ".\Baselines\$computer-Installed-Baseline.xml"
    [System.Array]$installed = Import-Clixml -Path $filename
    
    Move-Item $filename .\Reports

    [string]$filename = Get-DateISO8601 -Prefix ".\$computer-Installed-Exception-Report" -Suffix ".xml"
    Compare-Object $approved $installed | Export-Clixml  ".\Exception-Reports\$filename"

    # The script can be emailed for review or processing in the ticketing system:
    # Send-MailMessage -To -Subject "Installed software exception for $computer" -Body "The report is attached." -Attachments $filename

 }
