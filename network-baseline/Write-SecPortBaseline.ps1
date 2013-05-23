 function Write-SecPortBaseline 
 {
      [string]$computer = Get-Content env:ComputerName
      [string]$filename = ".\$computer-Ports-Baseline.xml"

      
        
       $ipgp = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties();
       $listens = $ipgp.GetActiveTcpListeners();
       foreach($ip in $listens)
       {

       [Array]$table += $ip.Port
          
       }
       
       Write-Output $table | Export-Clixml -Path $filename 
         
              
}
