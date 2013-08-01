function Get-SecConnectivity { 
  <#
  Designed to check each device currently available on the network and see whether they are responsive.
  #>
 
    $computer = Get-Content env:ComputerName 
    [array]$deviceNames = Get-ADComputer -Filter * | select -ExpandProperty 'Name'  
    Foreach($device in $deviceNames){
    if(Test-Connection $device -Count 1 -Quiet){
        Write-Host "$device is connected"
        }
    else{
        Write-Host "$device is not connected"
        # The script can be emailed for review or processing in the ticketing system:
        # Send-MailMessage -To -Subject "Connectivity Alert" -Body "$computer cannot communicate with $device" 
        }
    } 
} 
