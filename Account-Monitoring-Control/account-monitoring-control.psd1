@{

# Script module or binary module file associated with this manifest.
ModuleToProcess = 'account-monitoring-control.psm1'

# Version number of this module.
ModuleVersion = '2.0.0'

# ID used to uniquely identify this module
GUID = '2cf86856-3550-4150-8aaa-b72e83f819b0'

# Author of this module
Author = 'PoshSec'

# Copyright statement for this module
Copyright = 'BSD 3-Clause'

# Description of the functionality provided by this module
Description = 'This is the PoshSec PowerShell Modules Account Monitoring and Control submodule'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '2.0'

# Cmdlets to export from this module
CmdletsToExport = '*'

# Functions to export from this module
FunctionsToExport = '*'

# List of all modules packaged with this module.
ModuleList = @(@{ModuleName = 'account-monitoring-control'; ModuleVersion = '2.0.0'; GUID = '2cf86856-3550-4150-8aaa-b72e83f819b0'})

# List of all files packaged with this module
FileList = 'account-monitoring-control.psm1', 'account-monitoring-control.psd1', 'Get-SecAccountThatDontExpire.ps1',
     'Get-SecAccountThatExpire.ps1', 'Get-SecAllADAccount.ps1', 'Get-SecDisabledAccount.ps1',
     'Get-SecLockedOutAccount.ps1', 'Get-SecPasswordOverExpireDate.ps1', 'Show-SecDisabledAccountAccess.ps1', 
     'Get-SecInactiveAccount.ps1', 'Find-SecAccountNameChecker.ps1', 'Get-SecAdminAccount.ps1', 'Enable-SecVulnAccount.ps1'
}

