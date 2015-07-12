function Get-SecNewProcessCreation {
  [CmdletBinding()]
  param(
    [Parameter(ValueFromPipeline=$true,
               HelpMessage='Please enter a computer name to query.')]
    [alias('Computer', 'CN', 'MachineName')]
    [String[]]$ComputerName = $env:COMPUTERNAME
  )

  begin{
    Write-Verbose -Message 'Starting Get-SecNewProcessCreation'    
  }
  process{

    Write-Verbose -Message 'Setting the parameters for the WMI Query'
    $local:params = @{
      'Class'='Win32_NTLogEvent';
      'filter'="(logfile='Application') AND (EventCode='4688')";
      'ComputerName'=$ComputerName
    }

    Write-Verbose -Message "Testing connection to $ComputerName."
    if (Test-Connection -ComputerName $ComputerName -Count 1 | Out-Null) {
      Write-Verbose -Message "Getting WMI Results from $ComputerName"
      Get-WmiObject @local:params
    } else {
      Write-Verbose "Error connecting to $ComputerName."
      Write-Error "Cannot connect to $ComputerName."
    }
  }
  end{
    Write-Verbose -Message 'Ending Get-SecNewProcessCreation'
  }
<#
.SYNOPSIS
This function grabs event ID related to new process creation.
Author: Matthew Johnson (@mwjcomputing)
Project: PoshSec/Auditing
License: BSD-3
Required Dependencies: None
Optional Dependencies: None
.DESCRIPTION
This function gets Event Log entries in the Applicaiton log for event code 4688. It can be ran locally or remotely.
.INPUTS
System.String. Get-SecNewProcessCreation accepts a computer name as input.
.OUTPUTS
PSObject. Get-SecNewProcessCreation returns a PSObject of all event logs returns.
.EXAMPLE
Get-SecNewProcessCreation
.EXAMPLE
Get-SecNewProcessCreation -ComputerName 'DC1.POSHSEC.LOCAL'
.NOTES
This function is part of the PoshSec PowerShell Module's Auditing submodule. 

Auditing needs to be turned on via the local policy or group policy to see these events.
.LINK
http://www.poshsec.com/
.LINK
https://github.com/PoshSec
#>
}