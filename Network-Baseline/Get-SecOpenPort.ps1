<<<<<<< HEAD:Network-Baseline/Get-SecOpenPort.ps1
 function Get-SecOpenPort
{ 
    [string]$computer = Get-Content env:ComputerName
    [string]$filename = Get-DateISO8601 -Prefix ".\$computer-Ports" -Suffix ".xml"

    $properties = @()

    netstat -ano | Select-String -Pattern '\s+(TCP)' | ForEach-Object { 

        $item = $_.line.split(" ",[System.StringSplitOptions]::RemoveEmptyEntries) 

        if($item[1] -notmatch '^\[::') 
        {            
            if (($la = $item[1] -as [ipaddress]).AddressFamily -eq 'InterNetworkV6') 
            { 
               $localAddress = Get-NetIPAddress 
               $localPort = Get-NetTCPConnection -LocalPort 
            } 
            else 
            { 
                $localAddress = $item[1].split(':')[0] 
                $localPort = $item[1].split(':')[-1] 
            }  

            if (($ra = $item[2] -as [ipaddress]).AddressFamily -eq 'InterNetworkV6') 
            { 
               $remoteAddress = Get-NetTCPConnection -RemoteAddress 
               $remotePort = Get-NetTCPConnection -RemotePort 
            } 
            else 
            { 
               $remoteAddress = $item[2].split(':')[0] 
               $remotePort = $item[2].split(':')[-1] 
            }  

            $props = New-Object PSObject
            $props | Add-Member -MemberType NoteProperty -Name "Protocol" -Value $item[0]
            $props | Add-Member -MemberType NoteProperty -Name "LocalAddress" -Value $localAddress
            $props | Add-Member -MemberType NoteProperty -Name "LocalPort" -Value $localPort
            $props | Add-Member -MemberType NoteProperty -Name "RemoteAddress" -Value $remoteAddress
            $props | Add-Member -MemberType NoteProperty -Name "RemotePort" -Value $remotePort
            $props | Add-Member -MemberType NoteProperty -Name "State" -Value $(if($item[0] -eq 'tcp') {$item[3]} else {$null})
            $props | Add-Member -MemberType NoteProperty -Name "ProccessName" -Value $((Get-Process -Id $item[-1] -ErrorAction SilentlyContinue).Name)
            #$props | Add-Member -MemberType NoteProperty -Name "PID" -Value $item[-1] 
             
            $properties += $props
            }
           
        }
        Export-Clixml -InputObject $properties -Path $filename
    if(-NOT(Test-Path ".\Baselines\$computer-Ports-Baseline.xml"))
=======
 function Get-SecOpenPorts
{
  [string]$computer = Get-Content env:ComputerName
   
  $properties = @()
   
  netstat -ano | Select-String -Pattern '\s+(TCP)' | ForEach-Object {
   
    $item = $_.line.split(" ",[System.StringSplitOptions]::RemoveEmptyEntries)
     
    if (($la = $item[1] -as [ipaddress]).AddressFamily -eq 'InterNetworkV6')
>>>>>>> Updating Get-SecOpenPorts:Network-Baseline/Get-SecOpenPorts.ps1
    {
      $localAddress = $($item[1].split(']')[0] + ']')
    }
    else
    {
<<<<<<< HEAD:Network-Baseline/Get-SecOpenPort.ps1
        Compare-SecOpenPort
=======
      $localAddress = $item[1].split(':')[0]
>>>>>>> Updating Get-SecOpenPorts:Network-Baseline/Get-SecOpenPorts.ps1
    }
    
    $localPort = $item[1].split(':')[-1]
     
    if (($ra = $item[2] -as [ipaddress]).AddressFamily -eq 'InterNetworkV6')
    {
      $remoteAddress = $($item[1].split(']')[0] + ']')
    }
    else
    {
      $remoteAddress = $item[2].split(':')[0]      
    }
    $remotePort = $item[2].split(':')[-1]
     
    $props = New-Object PSObject
    $props | Add-Member -MemberType NoteProperty -Name "Protocol" -Value $item[0]
    $props | Add-Member -MemberType NoteProperty -Name "LocalAddress" -Value $localAddress
    $props | Add-Member -MemberType NoteProperty -Name "LocalPort" -Value $localPort
    $props | Add-Member -MemberType NoteProperty -Name "RemoteAddress" -Value $remoteAddress
    $props | Add-Member -MemberType NoteProperty -Name "RemotePort" -Value $remotePort
    $props | Add-Member -MemberType NoteProperty -Name "State" -Value $(if($item[0] -eq 'tcp') {$item[3]} else {$null})
    $props | Add-Member -MemberType NoteProperty -Name "ProcessName" -Value $((Get-Process -Id $item[-1] -ErrorAction SilentlyContinue).Name)
    $properties += $props
  }
  Write-Output $properties
} 
