function Get-SecConnectivity { 
  <#
  Designed to check each device currently available on the network and see whether they are responsive.
  #>
 
    [array]$deviceNames = Get-ADComputer -Filter * | select -ExpandProperty 'Name'  
    Foreach($device in $deviceNames){
    if(Test-Connection $device -Count 1 -Quiet){
        Write-Host "$device is connected"
        }
    else{
        Write-Host "$device is not connected"
        }
    } 
} 
