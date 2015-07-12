@{

# Script module or binary module file associated with this manifest.
ModuleToProcess = 'Malware-Detection.psm1'

# Version number of this module.
ModuleVersion = '2.0.0'

# ID used to uniquely identify this module
GUID = '3631650d-5f48-42f2-92de-5f0b3531dc4b'

# Author of this module
Author = 'PoshSec'

# Copyright statement for this module
Copyright = 'BSD 3-Clause'

# Description of the functionality provided by this module
Description = 'This is the PoshSec PowerShell Modules Malware Detection submodule'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '2.0'

# Cmdlets to export from this module
CmdletsToExport = '*'

# Functions to export from this module
FunctionsToExport = '*'

# List of all modules packaged with this module.
ModuleList = @(@{ModuleName = 'Malware-Detection'; ModuleVersion = '2.0.0'; GUID = '3631650d-5f48-42f2-92de-5f0b3531dc4b'})

# List of all files packaged with this module
FileList = 'Malware-Detection.psd1', 'Malware-Detection.psm1', 'Get-SecConnectionInfo.ps1', 'Find-SecADS.ps1'

}

