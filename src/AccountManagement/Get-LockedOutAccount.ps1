function Get-LockedOutAccount {
    [CmdletBinding()]
    param ()

    $Root = "LDAP://rootdse"
    $ADSISearcher = New-Object DirectoryServices.DirectorySearcher($Root)
    $ADSISearcher.Filter = "ObjectCategory=User"

    $ADSISearcher.FindAll() | ForEach-Object {
        If(([adsi]$_.path).psbase.invokeGet("IsAccountLocked")) {
            $PSObject = [PSCustomObject]@{
                DisplayName = ([ADSI]$_.path).DisplayName | ForEach-Object {$_}
                SamAccountName = ([ADSI]$_.path).SamAccountName | ForEach-Object {$_}
                DistinguishedName = ([ADSI]$_.path).DistinguishedName | ForEach-Object {$_}
            }
            Write-Output -InputObject $PSObject
        }
    }
    <#
    .SYNOPSIS
    Gets current list of locked out accounts in Active Directory.

    .DESCRIPTION
    Gets current list of locked out accounts in Active Directory

    .EXAMPLE
    PS> Get-LockedOutAccount
            DisplayName     SamAccountName      DistinguishedName
            ----------      -------------       -----------------'
            TestAccount     TestAccount         cn=TestAccount,OU=PoshSec,DC=PoshSec,DC=Com
            Bob Uncle       Bob.Uncle           cn=Bob Uncle,OU=PoshSec,DC=PoshSec,DC=Com

    .NOTES
    Part of the PoshSec PowerShell Module
    #>
}