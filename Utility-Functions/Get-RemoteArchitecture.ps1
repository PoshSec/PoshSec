<#    
.SYNOPSIS
  Gets the architecture for a remote system.
.DESCRIPTION
  This function will return a psobject with the
  architecture (x86 or x64) of the remote system.
  
AUTHOR
  Ben0xA
  
.PARAMETER computer
  The remote system on which to run the command.
  
.EXAMPLE
  PS> $arch = Get-RemoteArchitecture -computer REMOTEPC

.LINK
   www.poshsec.com
.NOTES
  This function is a utility function for the PoshSec module.
#>

function Get-RemoteArchitecture {
  Param(
    [Parameter(Mandatory=$true,Position=1)]
    [string]$computer
  )
  
  $remarch = $null
  $os = Get-RemoteOS $computer
  $remarch = New-Object PSObject
  $remarch | Add-Member -MemberType NoteProperty -Name "Computer" -Value $computer
  if($os.OSArchitecture) {
    $remarch | Add-Member -MemberType NoteProperty -Name "Architecture" -Value $os.OSArchitecture
  }
  else {
    $remarch | Add-Member -MemberType NoteProperty -Name "Architecture" -Value "32-bit"
  }
  
  if($os) {    
    $remarch | Add-Member -MemberType NoteProperty -Name "OperatingSystem" -Value $os.Caption
  }
  else {
    $remarch | Add-Member -MemberType NoteProperty -Name "OperatingSystem" -Value "Unknown"
  }  
  
  return $remarch
}