Get-ChildItem $PSScriptRoot\PoshSec | Where-Object { $_.PSIsContainer -and $_.Name -ne 'PoshSec.PowerShell.Commands' -and $_.Name -ne 'PoshSec.PowerShell.Commands 3.5' -and $_.Name -ne 'Tests' } | ForEach-Object { Import-Module $_.FullName }

Import-Module $PSScriptRoot\PoshSec\PoshSec.PowerShell.Commands\PoshSec.PowerShell.Commands\bin\Release\PoshSec.PowerShell.Commands.dll
