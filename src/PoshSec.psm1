# Implement your module commands in this script.
. $PSScriptRoot\AccountManagement\Get-DomainAdmins.ps1

# Export only the functions using PowerShell standard verb-noun naming.
Export-ModuleMember -Function *-*
