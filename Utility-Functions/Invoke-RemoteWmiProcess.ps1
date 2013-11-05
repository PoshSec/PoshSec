<#    
.SYNOPSIS
  Executes a wmi win32_process on a remote system.
.DESCRIPTION
  This function will use the process call create
  to execute a process on a remote system.
  
AUTHOR
  Ben0xA
  
.PARAMETER computer
  The remote system on which to start the process.
  
.PARAMETER command
  The application or command to execute on the remote system.
  
.PARAMETER noredirect
  Will not redirect the output to a temporary file.
  
.PARAMETER nowait
  Will not wait for the process to exit before returning.
  
.EXAMPLE
  PS> $output = Invoke-RemoteWmiProcess -computer REMOTEPC -command "C:\Windows6.1-KB2506143-x64.msu /quiet /norestart" -noredirect
  
.EXAMPLE
  PS> $output = Invoke-RemoteWmiProcess REMOTEPC "C:\Windows6.1-KB2506143-x64.msu /quiet /norestart" -noredirect -nowait
  
.EXAMPLE
  PS> $output = Invoke-RemoteWmiProcess REMOTEPC "netstat -on"

.LINK
   www.poshsec.com
.NOTES
  This function is a utility function for the PoshSec module.
#>

function Invoke-RemoteWmiProcess{
  Param(
    [Parameter(Mandatory=$true,Position=1)]
    [string]$computer,
    
    [Parameter(Mandatory=$true,Position=2)]
    [string]$command,
    
    [Parameter(Mandatory=$false,Position=3)]
    [switch]$noredirect,
    
    [Parameter(Mandatory=$false,Position=4)]
    [switch]$nowait
  )
  
  $rtn = New-Object PSObject
  $rtn | Add-Member -MemberType NoteProperty -Name "Computer" -Value $computer
  $rtn | Add-Member -MemberType NoteProperty -Name "Command" -Value $command
  $rtn | Add-Member -MemberType NoteProperty -Name "ExecuteMethod" -Value "Win32_Process"
  
  $process = Get-RemoteProcess $computer
  $timestamp = $(Get-Date -format 'MMddyyyyhhmmss')
  $tmpfile = "C:\Windows\Temp\erwpoutput_$timestamp.txt"
  $rmtfile = "\\$computer\c$\Windows\Temp\erwpoutput_$timestamp.txt"
  $content = ""
  $errors = ""
  
  if(-not $noredirect) {
    $command = "cmd /c $command > $tmpfile"
  }  
  if($process) {
    $rslt = $process.Create($command)
    if($rslt.ReturnValue -eq 0) {
      $content = "The command executed successfully."
      $procid = $rslt.ProcessId
      $running = $true
      $taskrslt = ""
      
      if(-not $nowait) {
        #Wait for the cmd /c process to exit before getting results from the file
        do
        {
          #does a tasklist for the remote machine with the pid provided by process
          #keeps looping with a sleep while the process exists
          $taskrslt = tasklist /s $computer /fi "PID eq $procid"
          Start-Sleep -m 200
        } while ($taskrslt -like "Image*")
      }      
    }
    else {
      $errors = "Process error: "
      switch ($rslt.ReturnValue)
      {
        2 { $errors += "Access Denied " }
        3 { $errors += "Insufficient Privilege " }
        8 { $errors += "Unknown failure " }
        9 { $errors += "Path Not Found " }
        21 { $errors += "Invalid Parameter " }
      }
    }
    if(Test-Path $rmtfile) {
      $cont = Get-Content $rmtfile
      if(($cont -ne "") -and ($cont -ne $null)){
        $content = $cont
      }
      try {
        #remove the temporary file
        Remove-Item $rmtfile
      }
      catch {
        $errors += "Unable to delete temporary file $rmtfile"
      }
    }
  }
  else {
    $errors += "Unable to create a remote process on $computer"
  }
  
  $rtn | Add-Member -MemberType NoteProperty -Name "Details" -Value $content
  $rtn | Add-Member -MemberType NoteProperty -Name "Errors" -Value $errors
  
  return $rtn
}