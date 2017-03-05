#region Tags
$Utility = 'Utility'
$Global = 'Global'
#endregion Tags

$null = Import-Module -Name $PSScriptRoot\..\poshsec.psd1

#region Global Tests
Describe -Name 'PoshSec Module Load' -Tag $Global -Fixture {
  Context -Name 'Input' -Fixture {
  }
  Context -Name 'Execution' -Fixture {
    It -Name 'There should be 57 commands.' -test {
      $Commands = @(Get-Command -Module 'PoshSec' | Select-Object -ExpandProperty Name)
      $Commands.Count | Should Be 57
    }
  }
  Context -Name 'Output' -Fixture {
  }
}
#endregion 

#region Utility Tests
Describe -Name 'Get-DateISO8601' -Tags $Utility -Fixture {
  Context -Name 'Input' -Fixture {
    It -name 'Should not throw' -test {
      { Get-DateISO8601 -Prefix 'Pester' -Suffix 'Tests' } | SHould Not Throw
    }
    It -name 'Should throw' -Pending -test {
      { Get-DateISO8601 } | Should Throw
    }
  }
  Context -Name 'Execution' -Fixture {}
  Context -Name 'Output' -Fixture {
	  It -Name 'Should produce correct output' -test {
		  $Command = @(Get-DateISO8601 -Prefix 'Pester' -Suffix 'Tests')
      $Command | Should Be "Pester-$(Get-Date -Format yyyy-MM-dd-HH-mm)Tests"
	  }
  }
}

Describe -Name 'Convert-FQDNtoDN' -Tags $Utility -Fixture {
  Context -Name 'Input' -Fixture {}
  Context -Name 'Execution' -Fixture {}
  Context -Name 'Output' -Fixture {
    It -name 'Should produce a correct distinguished name' -test {
      $Command = @(Convert-FQDNtoDN -domainFQDN 'dev.poshsec.com')
      $Command | Should Be 'DC=dev,DC=poshsec,dc=com'
    }
  }
}

#endregion