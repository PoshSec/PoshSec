Import-Module $PSScriptRoot\..\poshsec.psd1 | Out-Null

Describe 'PoshSec Module Load' {
  It 'There should be 56 commands.' {
    $Commands = @(Get-Command -Module 'PoshSec' | Select-Object -ExpandProperty Name)
    $Commands.Count | Should Be 56
  }
}

Describe 'Get-DateISO8601 works correctly' {
	It 'Should produce correct output' {
		$Command = @(Get-DateISO8601 -Prefix 'Pester' -Suffix 'Tests')
    $Command | Should Be "Pester-$(Get-Date -f yyyy-MM-dd-HH-mm)Tests"
	}
}
