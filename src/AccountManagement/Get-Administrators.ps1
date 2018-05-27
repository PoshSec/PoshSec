function Get-Administrators {
    <#
    .SYNOPSIS
    Obtains the list of users in a domain Administrators group.

    .DESCRIPTION
    Obtains the list of the users in the domain based Administrators group for the current or specified domain.

    .EXAMPLE
    PS> Get-Administrators
            DisplayName     SamAccountName      DistinguishedName
            ----------      -------------       -----------------'
            TestAccount     TestAccount         cn=TestAccount,OU=PoshSec,DC=PoshSec,DC=Com
            Bob Uncle       Bob.Uncle           cn=Bob Uncle,OU=PoshSec,DC=PoshSec,DC=Com

    .NOTES
    Part of the PoshSec PowerShell Module
    #>

    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns','',Justification='Group name is Administrators')]
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage="Name of domain to run query against.")]
        [string]$Domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
    )

    $CurrentDomain = [ADSI]"LDAP://$Domain"
    Write-Debug -Message "Set ADSI Connection to $CurrentDomain"
    $DN = $CurrentDomain.DistinguishedName
    Write-Debug -Message "Set Distinguished Name to $DN"
    $Administrators = [ADSI]"LDAP://cn=Administrators,cn=Builtin,$DN"
    Write-Debug -Message "Set Domain Admin string to $Administrators"

    Foreach($Member in $Administrators.Member) {
        $MemberDN = [ADSI]"LDAP://$Member"
        Write-Debug -Message "MemberDN: $MemberDN"
        $HashTable = [PSCustomObject]@{
            DisplayName = $MemberDN.DisplayName | ForEach-Object {$_}
            SamAccountName = $MemberDN.SamAccountName | ForEach-Object {$_}
            DistinguishedName = $MemberDN.DistinguishedName | ForEach-Object {$_}
        }
        Write-Output $HashTable
    }
    Write-Verbose -Message "Displaying members of $Administrators.SamAccountName"
}