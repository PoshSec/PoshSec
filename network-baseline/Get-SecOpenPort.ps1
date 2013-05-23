 function Get-SecOpenPort 
 {
    <#
    Synopsis
    Checks computer for open ports, then exports into an xml file. If a baseline does not exist, establishes baseline
    #>

      [string]$computer = Get-Content env:ComputerName
      [string]$filename = Get-DateISO8601 -Prefix ".\$computer-Ports" -Suffix ".xml"

      
        
       $ipgp = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties();
       $listens = $ipgp.GetActiveTcpListeners();
       foreach($ip in $listens)
       {

       [Array]$table += $ip.Port
          
       }

       Write-Output $table | Export-Clixml -Path $filename
       
       if(-NOT(Test-Path ".\$computer-Ports-Baseline.xml"))
       {
            Rename-Item $filename "$computer-Ports-Baseline.xml"
            Write-Warning  "The baseline file for this computer has been created, now running the script again."
            Invoke-Expression $MyInvocation.MyCommand
        }

       
         
              
}
