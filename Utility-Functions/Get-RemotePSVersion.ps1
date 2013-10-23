<#    
.SYNOPSIS
  Gets the PowerShell version from the remote system.
  
.DESCRIPTION
  This function will return the PowerShell versions that
  are installed on the remote system.
  
AUTHOR
  Ben0xA
  
.PARAMETER computer
  The remote system on which to run the command.
  
.EXAMPLE
  PS> $versions = Get-RemotePSVersion -computer REMOTEPC
  
.EXAMPLE
  PS> $versions = Get-RemotePSVersion REMOTEPC

.LINK
   www.poshsec.com
.NOTES
  This function is a utility function for the PoshSec module.
#>

function Get-RemotePSVersion {
  Param(
    [Parameter(Mandatory=$true,Position=1)]
    [string]$computer
  )
  
  return Get-RemoteRegistryKey $computer 3 "Software\Microsoft\PowerShell"
}