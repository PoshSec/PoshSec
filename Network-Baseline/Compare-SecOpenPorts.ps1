Function Compare-SecOpenPorts {
<#
    .Synopsis
        Compares the the current list to the baseline and exports that into an XML file
    
    .Description
        Compares the open ports to the XML baseline and exports to an XML file.
        
        CSIS 20 Critical Security Controls for Effective Cyber Defense excerpt:
    	Limitation and control of network ports, protocols and services
    
    .Link
        https://github.com/organizations/PoshSec

    .NOTES
        Name: Compare-SecOpenPorts.ps1
        Author: PoshSec
        Last Edit: 4-19-2014
#>

# Start Begin statement
Begin{

        # Define localcomputer and XML output
        [String]$Computer = $env:COMPUTERNAME
        [String]$Filename = Get-DateISO8601 -Prefix ".\$Computer-Ports" -Suffix ".xml"

        # Import Files
        [Array]$Open = Import-Clixml $Filename
        [Array]$Baseline = Import-Clixml ".\Baselines\$computer-Ports-Baseline.xml"


} # End Begin statement

# Start Process statement
Process {   
    
    # Move into the reports directory (will replace if exact filename exists)
    Move-Item $Filename .\Reports\ -Force
    
    # Create Report location and run Compare
    [string]$Report = Get-DateISO8601 -Prefix ".\$Computer-Ports-Exception-Report" -Suffix ".xml"
    $Compare = Compare-Object -ReferenceObject $Open -DifferenceObject $Baseline -CaseSensitive


}

# Start End statement
End {
    
    # Return the results of comparison (if any) and export Report to output location
    Return $Compare | Export-Clixml -Path ".\Exception-Reports\$Report"

} # End End statement

} # End Function Compare-SecOpenPorts
