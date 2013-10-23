<#    
.SYNOPSIS
  Gets the Win32 OS of the remote system.
.DESCRIPTION
  This function will return the Win32 Operating System
  of the remote machine.
  
AUTHOR
  Ben0xA
  
.PARAMETER computer
  The remote system on which to run the command.
  
.EXAMPLE
  PS> Get-RemoteOS -computer REMOTEPC

.LINK
   www.poshsec.com
.NOTES
  This function is a utility function for the PoshSec module.
#>

function Get-RemoteOS {
  Param(
    [Parameter(Mandatory=$true,Position=1)]
    [string]$computer
  )
  
  $rtn = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer

  return $rtn
}