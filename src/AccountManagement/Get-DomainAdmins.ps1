function Get-DomainAdmins {
    <#
    .SYNOPSIS
    Obtains the list of domain admins.

    .DESCRIPTION
    Obtains the list of domain admins for the current or specified domain.

    .EXAMPLE
    PS> Get-DomainAdmins
            DisplayName     SamAccountName      DistinguishedName
            ----------      -------------       -----------------'
            TestAccount     TestAccount         cn=TestAccount,OU=PoshSec,DC=PoshSec,DC=Com
            Bob Uncle       Bob.Uncle           cn=Bob Uncle,OU=PoshSec,DC=PoshSec,DC=Com

    .NOTES
    Part of the PoshSec PowerShell Module
    #>

    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns','',Justification='Group name is Domain Admins')]
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage="Name of domain to run query against.")]
        [string]$Domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
    )

    $CurrentDomain = [ADSI]"LDAP://$Domain"
    Write-Debug -Message "Set ADSI Connection to $CurrentDomain"
    $DN = $CurrentDomain.DistinguishedName
    Write-Debug -Message "Set Distinguished Name to $DN"
    $DomainAdmins = [ADSI]"LDAP://cn=Domain Admins,cn=Users,$DN"
    Write-Debug -Message "Set Domain Admin string to $DomainAdmins"

    Foreach($Member in $DomainAdmins.Member) {
        $MemberDN = [ADSI]"LDAP://$Member"
        Write-Debug -Message "MemberDN: $MemberDN"
        $HashTable = [PSCustomObject]@{
            DisplayName = $MemberDN.DisplayName | ForEach-Object {$_}
            SamAccountName = $MemberDN.SamAccountName | ForEach-Object {$_}
            DistinguishedName = $MemberDN.DistinguishedName | ForEach-Object {$_}
        }
        Write-Output $HashTable
    }
    Write-Verbose -Message "Displaying members of $DomainAdmins.SamAccountName"
}