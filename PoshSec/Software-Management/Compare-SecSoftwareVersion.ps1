function Compare-SecSoftwareVersion
 {
    
  
    [string]$computer = Get-Content env:ComputerName
    [string]$filename = Get-DateISO8601 -Prefix ".\$computer-Software" -Suffix ".xml"

    [System.Array]$approved = Import-Clixml -Path ".\Baselines\$computer-Installed-Baseline.xml"
    [System.Array]$installed = Import-Clixml -Path ".\Reports\$filename" 

    [string]$filename = Get-DateISO8601 -Prefix ".\$computer-Version-Exception-Report" -Suffix ".xml"
    Compare-Object $approved $installed -Property DisplayVersion | select DisplayName,DisplayVersion | Export-Clixml  ".\Exception-Reports\$filename"

    # The script can be emailed for review or processing in the ticketing system:
    # Send-MailMessage -To -Subject "Installed software exception for $computer" -Body "The report is attached." -Attachments $filename
    
    <#
        .Synopsis
            Examines the version info of installed software of a machine and exports it to an XML file. If a baseline has not been created, establishes it as a baseline
        .Description
            Baselines the installed software version info to an XML file.
        
            CSIS 20 Critical Security Controls for Effective Cyber Defense excerpt:
  	        Devise a list of authorized software that is required in the enterprise for each type of system, including servers, workstations, and laptops of various kinds and uses.
        .Example
            Compare-SecSoftwareVersion
        .Link
            https://github.com/organizations/PoshSec
    #>
 }
