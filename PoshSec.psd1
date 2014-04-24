@{

# Script module or binary module file associated with this manifest.
ModuleToProcess = 'poshsec.psm1'

# Version number of this module.
ModuleVersion = '1.0.0.0'

# ID used to uniquely identify this module
GUID = 'ea78dc3e-3da2-4e06-ad7f-b9fcadc84a51'

# Author of this module
Author = 'PoshSec'

# Company or vendor of this module
CompanyName = ''

# Copyright statement for this module
Copyright = 'BSD 3-Clause'

# Description of the functionality provided by this module
Description = 'PoshSec Security Module'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '2.0'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of the .NET Framework required by this module
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module
FunctionsToExport = '*'

# Cmdlets to export from this module
CmdletsToExport = '*'

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module
AliasesToExport = '*'

# List of all modules packaged with this module.
ModuleList = @(@{ModuleName = 'account-monitoring-control'; ModuleVersion = '1.0.0.0'; GUID = '2cf86856-3550-4150-8aaa-b72e83f819b0'},
               @{ModuleName = 'authorized-devices'; ModuleVersion = '1.0.0.0'; GUID = 'd026637b-ddf4-46d0-baa5-08e93a11b682'},
               @{ModuleName = 'baselines'; ModuleVersion = '1.0.0.0'; GUID = '1cf19d58-94ef-47c3-a558-23417ea90681'},
               @{ModuleName = 'log-management'; ModuleVersion = '1.0.0.0'; GUID = 'b4e3aeb9-d19c-4fe6-84fd-3f23bf698833'},
               @{ModuleName = 'network-baseline'; ModuleVersion = '1.0.0.0'; GUID = 'dc438100-013e-42aa-98c0-81b8833d5e7a'},
               @{ModuleName = 'software-management'; ModuleVersion = '1.0.0.0'; GUID = 'e6f46747-8f3c-4703-aea1-d534eba663d4'},
               @{ModuleName = 'utility-functions'; ModuleVersion = '1.0.0.0'; GUID = '7f701b23-9af6-4871-b2f2-985f4609cc58'},
			   @{ModuleName = 'Forensics'; ModuleVersion = '1.0.0.0'; GUID = 'f6e91c7d-3d0a-41db-9324-9f9f5bb7142d'}
)

# List of all files packaged with this module
FileList = 'poshsec.psm1', 'poshsec.psd1'

# Private data to pass to the module specified in RootModule/ModuleToProcess
# PrivateData = ''

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

