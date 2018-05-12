function Get-EnterpriseAdmins {
    <#
    .SYNOPSIS
    Obtains the list of Enterprise admins.

    .DESCRIPTION
    Obtains the list of Enterprise admins for the current or specified domain.

    .EXAMPLE
    PS> Get-SecEnterpriseAdmins

    .NOTES
    Part of the PoshSec PowerShell Module
    #>

    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns','',Justification='Group name is Enterprise Admins')]
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage="Name of domain to run query against.")]
        [string]$Domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
    )


    #Domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
    $CurrentDomain = [ADSI]"LDAP://$Domain"
    Write-Debug -Message "Set ADSI Connection to $CurrentDomain"
    $DN = $CurrentDomain.DistinguishedName
    Write-Debug -Message "Set Distinguished Name to $DN"
    $EnterpriseAdmins = [ADSI]"LDAP://cn=Enterprise Admins,cn=Users,$DN"
    Write-Debug -Message "Set Domain Admin string to $DomainAdmins"

    Foreach($Member in $DomainAdmins.Member) {
        $MemberDN = [ADSI]"LDAP://$Member"
        Write-Debug -Message "MemberDN: $MemberDN"
        $HashTable = [PSCustomObject]@{
            SamAccountName = $MemberDN.SamAccountName | ForEach-Object {$_}
            DisplayName = $MemberDN.DisplayName | ForEach-Object {$_}
        }
        Write-Output $HashTable
    }
}