# PoshSec PowerShell Module
- Release 2.0-Pre
- License BSD 3-Clause

##### New in this release
**New Features**
- Get-SecADComputerInventory - Gets all computer objects inside users Active Directory domain.
- Get-SecAllADAccount - Gets all accounts in an Active Directory domain.
- New Auditing Sub Module. Commands include
	* Get-SecNewProcessCreation - Checks the Security Event Log for Process Creation Events.
- New Intrusion Detection Sub Module 
	* New-HoneyToken - Inject artificial credentials into LSASS.

**Quality of life improvements**
- All commands have full and updated help.

##### Features removed in this release
Get-SecAllAccounts - Changed name and rewrote as Get-SecAllADAccount

##### Installing PoshSec
1. Download module
2. Unblock .zip file
3. Extract module files to $env:userprofile\Documents\WindowsPowerShell\Modules
4. Launch PowerShell
5. Import Module
```PowerShell
Import-Module -Name PoshSec -Force
```

##### Project Information

The project maintains a Kanban board that anyone can view. You can view the board at [https://tree.taiga.io/project/PoshSec/kanban](https://tree.taiga.io/project/PoshSec/kanban). You can get features added to the board by emailing [Matt Johnson](mailto:mjohnson@poshsec.com) or filing an issue on our [Github page](https://github.com/PoshSec/PoshSec/issues).

***Pester Tests***

[![Build status](https://ci.appveyor.com/api/projects/status/3p9ssqte9a905qm8/branch/PoshSec?svg=true)](https://ci.appveyor.com/project/mwjcomputing/poshsec/branch/PoshSec)

***Issues Status***

[![Stories in Ready](https://badge.waffle.io/poshsec/poshsec.svg?label=In%20Progress&title=InProgress)](http://waffle.io/poshsec/poshsec)


##### Community Information
- Mailing list: [https://groups.google.com/forum/#!forum/poshsec] (https://groups.google.com/forum/#!forum/poshsec)
- Twitter: [@poshsec] (https://twitter.com/poshsec) or [#poshsec] (https://twitter.com/search?q=%23poshsec&src=typd)
- IRC: #poshsec on Freenode.net

##### Contact
* [www.poshsec.com](http://www.poshsec.com)
* You can offer your support by emailing [team@poshsec.com] (team@poshsec.com)
* Twitter: [@poshsec] (https://twitter.com/poshsec)
