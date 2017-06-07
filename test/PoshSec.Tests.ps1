[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $true
. $PSScriptRoot\Shared.ps1

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath
        $? | Should Be $true
    }
}

Describe 'Utility Functions' {
    Context 'Convert-FQDNtoDN' {
        It 'Runs without errors' {
            { Convert-FQDNtoDN -domainFQDN 'poshsec.ad' } | Should Not Throw
        }
        It 'Properly converts a FQDN to a DN with named parameter' {
            Convert-FQDNtoDN -domainFQDN 'poshsec.ad' | Should be "dc=poshsec,dc=ad"
        }
        It 'Propery converts a FQDN to a DN without a named parameter' {
            Convert-FQDNtoDN 'poshsec.ad' | Should be 'dc=poshsec,dc=ad'
        }
    }
}

Describe 'PoshSec Module Help Tests' {
    $FunctionsList = (Get-Command -Module 'PoshSec' | Where-Object -FilterScript {
        $_.CommandType -eq 'Function'
    }).Name

    foreach ($Function in $FunctionsList) {
        $Help = Get-Help -Name $Function -Full

        Context "HELP - $Function" {
            It 'Synopsis' { $Help.Synopsis | Should not BeNullOrEmpty }
            It 'Description' { $Help.Description | Should not BeNullOrEmpty }
            It 'Examples' { $Help.Examples | Should not BeNullOrEmpty }
        }
    }
}