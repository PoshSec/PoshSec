Import-Module $PSScriptRoot\..\poshsec.psd1 | Out-Null

Describe 'PoshSec Module Load' {
  It 'There should be 56 commands.' {
    $Commands = @(Get-Command -Module 'PoshSec' | Select-Object -ExpandProperty Name)
    $Commands.Count | Should Be 56
  }
}
