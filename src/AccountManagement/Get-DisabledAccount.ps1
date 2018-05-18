function Get-DisabledAccount {
    [CmdletBinding()]
    param ()

    $Root = "LDAP://rootdse"

    $ADSISearcher = New-Object DirectoryServices.DirectorySearcher($Root)
    $ADSISearcher.Filter = "(&(objectClass=user)(objectCategory=person))"

    $ADSISearcher.FindAll() | ForEach-Object {
        $Disabled = ([adsi]$_.path).psbase.invokeGet("useraccountcontrol")
        if ($Disabled -band '0x2') {
            $PSObject = [PSCustomObject]@{
                DisplayName = ([ADSO]$_.path).DisplayName | ForEach-Object {$_}
                SamAccountName = ([ADSO]$_.path).SamAccountName | ForEach-Object {$_}
                DistinguishedName = ([ADSO]$_.path).DistinguishedName | ForEach-Object {$_}
            }
            Write-Output -InputObject $PSObject
        }
    }
    <#
    .SYNOPSIS
    Gets current list of disabled accounts in Active Directory.

    .DESCRIPTION
    Gets current list of disabled accounts in Active Directory

    .EXAMPLE
    PS> Get-DisabledAccount
            DisplayName     SamAccountName      DistinguishedName
            ----------      -------------       -----------------'
            TestAccount     TestAccount         cn=TestAccount,OU=PoshSec,DC=PoshSec,DC=Com
            Bob Uncle       Bob.Uncle           cn=Bob Uncle,OU=PoshSec,DC=PoshSec,DC=Com

    .NOTES
    Part of the PoshSec PowerShell Module
    #>
}