 function Write-SecPortBaseline 
 {
      [string]$computer = Get-Content env:ComputerName
      [string]$filename = ".\$computer-Ports-Baseline.xml"

      if (-not ($computer[0] -eq 'localhost') -or $computer.Length -gt 1 )
       { 
        
       $ipgp = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties();
       $listens = $ipgp.GetActiveTcpListeners();
       foreach($ip in $listens)
       {
       $table += $computer, $ip.Port   
          
       }
        Write-Output $table | Export-Clixml -Path $filename 
         
         #Out-File -filepath $filename -Append -NoClobber -inputobject $table
 

          }
          #local-only if no remoting
          
          
        <#
         else
         {
         
          $ipgp = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties();
          $listens = $ipgp.GetActiveTcpListeners();
          foreach($ip in $listens)
          {
           $row = "localhost," + $ip.Port        
           #Out-File -filepath $filename -Append -NoClobber -inputobject $row
           Write-Output $row | Export-Clixml -Path $filename 
          }
          

         }
          #>
       
}
