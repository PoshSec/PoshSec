function Out-Baseline {
  #requires -Modules PoshSec
  param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, HelpMessage='Object for baseline.')]
    [psobject]$Object,
    [Parameter(Mandatory=$true, HelpMessage='Path for the baseline output.')]
    [String]$Path,
    [Parameter(Mandatory=$true, HelpMessage='Filename Prefix.')]
    [String]$Prefix
  )

  $filename = Get-DateISO8601 -Prefix $Prefix -Suffix '.xml'
  Export-Clixml -InputObject $Object -Path "$Path\$filename"
  
    <#    
    .SYNOPSIS
        This function outputs baseline files.
    .DESCRIPTION
        This function outputs baseline files for the object that is passed to it.
    .EXAMPLE
        Get-Process | Out-Baseline -Path 'C:\Baselines' -Prefix 'Process'

    .LINK
        github.com/poshsec
    .NOTES
        This function requires the Get-DateISO8601 cmdlet from the PoshSec module.
    #>

}