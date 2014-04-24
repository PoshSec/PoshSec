<<<<<<< HEAD
Function Get-SecOpenPort {
<#
    .Synopsis
        Checks a local (non-remote) computer for open ports, then exports into an xml file. If a baseline does not exist, establishes baseline
    
    .Description
        Baselines the open ports to an XML file.
        
        CSIS 20 Critical Security Controls for Effective Cyber Defense excerpt:
 	    Limitation and control of network ports, protocols and services
    
    .Example
        Get-SecOpenPort

    .Link
        https://github.com/organizations/PoshSec

    .NOTES
        Name: Get-SecOpenPort.ps1
        Author: PoshSec
        Last Edit: 4-19-2014
#>

[Cmdletbinding()]
Param (

    # Computer parameter (default is localhost)
    [Parameter(Mandatory=$False)]
    [String]$Computer = $env:Computername
)

# Start Begin statement
Begin {
    
    # Empty array to store discovered ports
    [Array]$PortTable=@()

    # Define XML output location
    [String]$Filename = Get-DateISO8601 -Prefix ".\$Computer-Ports" -Suffix ".xml"

} # End Begin statement

# Start Process statement
Process {
    
    # Collects local open ports and stores into PortTable
    $IPGP = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties()
    $Listens = $IPGP.GetActiveTcpListeners()
    $Listens | ForEach-Object {$PortTable += $_.Port}
  
    # Displays open ports to console and exports XML file to output location
    Return $PortTable | Export-Clixml -Path $Filename   
             
} # End Process statement

# Start End statement
End {
    
    # If baseline does not exist, then start a new baseline
    If (-NOT( Test-Path ".\Baselines\$Computer-Ports-Baseline.xml" )) {
        
        # Takes current XML and moves it to the baselines output
        Rename-Item $Filename "$Computer-Ports-Baseline.xml"
        Move-Item "$Computer-Ports-Baseline.xml" .\Baselines
        Write-Warning  "The baseline file for this computer has been created, now running the script again."
        Invoke-Expression $MyInvocation.MyCommand
   
    } Else {
        
        # Run compare against last known ports
        Compare-SecOpenPorts

    } # End If/Else

} # End End statement


} # End Function Get-SecOpenPort
=======
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
  
  $lines = $netstat | Select-String -Pattern '\s+(TCP)'
  $lines += $netstat | Select-String -Pattern '\s+(UDP)'
  
  $lines | ForEach-Object {
   
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
>>>>>>> development
