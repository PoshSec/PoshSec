Describe 'PoshSec Module Load' {
  It 'Should load the PoshSec Module' {
    Import-Module 'PoshSec'
    Get-Module 'PoshSec'
  }
}
