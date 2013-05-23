function Compare-SecPorts
{

    <#
        Synopsis
            Compare the baseline list created by Write-SecPortBaseline and generate an exception report based on the differences between the lists

    #>

       
      [string]$computer = Get-Content env:ComputerName
      [string]$filename = Get-DateISO8601 -Prefix ".\$computer-Ports" -Suffix ".xml"
     

            
        $ipgp = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties();
        $listens = $ipgp.GetActiveTcpListeners();
        foreach($ip in $listens)
        {
       
         [Array]$table += $ip.Port
         Write-Output $table | Export-Clixml -Path $filename       
      
        }

        [array]$open = Import-Clixml $filename
        [array]$baseline = Import-Clixml ".\$computer-Ports-Baseline.xml"
        [string]$report = Get-DateISO8601 -Prefix ".\$computer-Ports-Exception-Report" -Suffix ".xml"
        Compare-Object $baseline $open | Export-Clixml .\Exception-Reports\$report   


}
