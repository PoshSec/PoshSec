<#    
.SYNOPSIS
  Gets the process WMI object for a remote system.
.DESCRIPTION
  This function will return a WMI object of the Win32_Process
  for a remote system.
  
AUTHOR
  Ben0xA
  
.PARAMETER computer
  The remote system on which to run the command.
  
.EXAMPLE
  PS> $process = Get-RemoteProcess -computer REMOTEPC

.EXAMPLE
  PS> $process = Get-RemoteProcess REMOTEPC

.LINK
   www.poshsec.com
.NOTES
  This function is a utility function for the PoshSec module.
#>

function Get-RemoteProcess {
  Param(
    [Parameter(Mandatory=$true,Position=1)]
    [string]$computer
  )
  
  return Get-WmiObject -Class Win32_Process -List -Namespace root\cimv2 -ComputerName $computer -ErrorAction SilentlyContinue
}