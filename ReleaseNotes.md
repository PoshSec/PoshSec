# PoshSec PowerShell Module

- Release 2.0-Pre
- License BSD 3-Clause

** PoshSec 2.0 is expected to be released October 2017. **

## New in this release

### New Features

- Get-SecADComputerInventory - Gets all computer objects inside users Active Directory domain.
- Get-SecAllADAccount - Gets all accounts in an Active Directory domain.
- Get-SecDomainAdmins - Gets domain admins from current or specified domain.
- New Auditing Sub Module. Commands include
  - Get-SecNewProcessCreation - Checks the Security Event Log for Process Creation Events.
  - New Intrusion Detection Sub Module
    - New-HoneyToken - Inject artificial credentials into LSASS.

## Quality of life improvements

- All commands have full and updated help.
- New module structure. Release includes Pester test files.
- Removed PowerShell 2.0 Support

## Features removed in this release

- Get-SecAllAccounts - Changed name and rewrote as Get-SecAllADAccount
- Forensics Functions - With the amazing [PowerForensics](https://github.com/Invoke-IR/PowerForensics) module, we hope that if you want to add items related to forensics you would submit a pull request to that project.

## Installing PoshSec

1. Download module
1. Unblock .zip file
1. Extract module files to $env:userprofile\Documents\WindowsPowerShell\Modules
1. Launch PowerShell
1. Import Module

```PowerShell
Import-Module -Name PoshSec -Force
```

## Project Information

The project maintains a Kanban board that anyone can view. You can view the board at [https://tree.taiga.io/project/PoshSec/kanban](https://tree.taiga.io/project/PoshSec/kanban). You can get features added to the board by emailing [Matt Johnson](mailto:mwjcomputing@gmail.com) or filing an issue on our [Github page](https://github.com/PoshSec/PoshSec/issues).
