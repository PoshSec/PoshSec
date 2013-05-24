function Compare-SecOpenPort
{

   <#
    .Synopsis
    Compares the the current list to the baseline and exports that into an XML file
    
    .Description
        Compares the open ports to the XML baseline and exports to an XML file.
        
        CSIS 20 Critical Security Controls for Effective Cyber Defense excerpt:
    	Limitation and control of network ports, protocols and services
    
    .Link
        https://github.com/organizations/PoshSec
    #>

       
      [string]$computer = Get-Content env:ComputerName
      [string]$filename = Get-DateISO8601 -Prefix ".\$computer-Ports" -Suffix ".xml"
     

      [array]$open = Import-Clixml $filename
      [array]$baseline = Import-Clixml ".\$computer-Ports-Baseline.xml"
      [string]$report = Get-DateISO8601 -Prefix ".\$computer-Ports-Exception-Report" -Suffix ".xml"
      Compare-Object $baseline $open | Export-Clixml .\Reports\$report   


}
