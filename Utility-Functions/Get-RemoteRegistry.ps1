<#    
.SYNOPSIS
  Gets the registry WMI object for a remote system.
.DESCRIPTION
  This function will return a WMI object of the StdRegProv
  for a remote system.
  
AUTHOR
  Ben0xA
  
.PARAMETER computer
  The remote system on which to run the command.
  
.EXAMPLE
  PS> $reg = Get-RemoteRegistry -computer REMOTEPC

.LINK
   www.poshsec.com
.NOTES
  This function is a utility function for the PoshSec module.
#>

function Get-RemoteRegistry {
  Param(
    [Parameter(Mandatory=$true,Position=1)]
    [string]$computer
  )
  
  return Get-WmiObject -Class StdRegProv -List -Namespace root\default -ComputerName $computer
}