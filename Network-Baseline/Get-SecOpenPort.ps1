 function Get-SecOpenPorts
{
  Param(
    [Parameter(Mandatory=$false,Position=1)]
    [string]$computer=""
  )
  
  $netstat = $null
  $remote = $false
  
  if($computer -eq "") {
    $computer = Get-Content env:ComputerName
    $netstat = netstat -ano
  }
  else {
    $netstat = $(Invoke-RemoteWmiProcess $computer "netstat -ano").Details
    $remote = $true
  }
   
  $properties = @()
  
  $netstat | Select-String -Pattern '\s+(TCP)' | ForEach-Object {
   
    $item = $_.line.split(" ",[System.StringSplitOptions]::RemoveEmptyEntries)
     
    if (($la = $item[1] -as [ipaddress]).AddressFamily -eq 'InterNetworkV6')
    {
      $localAddress = $($item[1].split(']')[0] + ']')
    }
    else
    {
      $localAddress = $item[1].split(':')[0]
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
    if($remote) {
      $props | Add-Member -MemberType NoteProperty -Name "ProcessName" -Value $item[-1]
    }
    else {
      $props | Add-Member -MemberType NoteProperty -Name "ProcessName" -Value $((Get-Process -Id $item[-1] -ErrorAction SilentlyContinue).Name)
    }    
    $properties += $props
  }
  Write-Output $properties
} 