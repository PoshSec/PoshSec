<#    
.SYNOPSIS
  Executes a process on a remote system.
.DESCRIPTION
  This function will use the process call create
  to execute a process on a remote system.
  
AUTHOR
  Ben0xA
  
.PARAMETER computer
  The remote system on which to start the process.
  
.PARAMETER command
  The application or command to execute on the remote system.
  
.PARAMETER commandpath
  The unc or full path to the executable or application.
  
.PARAMETER arguments
  The command arguments.
  
.EXAMPLE
  PS> $output = Execute-RemoteProcess -computer REMOTEPC -command "C:\Windows6.1-KB2506143-x64.msu" -arguments "/quiet /norestart"
  
.EXAMPLE
  PS> $output = Execute-RemoteProcess REMOTEPC "C:\Windows6.1-KB2506143-x64.msu" "/quiet /norestart"

.LINK
   www.poshsec.com
.NOTES
  This function is a utility function for the PoshSec module.
#>

function Execute-RemoteProcess{
  Param(
    [Parameter(Mandatory=$true,Position=1)]
    [string]$computer,
    
    [Parameter(Mandatory=$true,Position=2)]
    [string]$command,
    
    [Parameter(Mandatory=$false,Position=3)]
    [string]$arguments
  )
  
  $process = Get-RemoteProcess $computer
  
  if($process) {
    if($arguments) {
      $command = $command + " " + '"' + $arguments + '"'
    }
    
    return $process.Create($command)
  }
}