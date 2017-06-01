function Get-DomainAdmins {
    <#
    .SYNOPSIS
    Obtains the list of domain admins.

    .DESCRIPTION
    Obtains the list of domain admins for the current or specified domain.

    .EXAMPLE
    PS> Get-SecDomainAdmins

    .NOTES
    Part of the PoshSec PowerShell Module
    #>

    $Entries = @()

    $CurrentDomain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
    $Domain = [ADSI]"LDAP://$CurrentDomain"
    $DN = $Domain.DistinguishedName
    $DomainAdmins = [ADSI]"LDAP://cn=Domain Admins,cn=Users,$DN"

    Foreach($Member in $DomainAdmins) {
        $MemberDN = [ADSI]"LDAP://$Member"
        $HashTable = [PSCustomObject]@{
            SamAccountName = $MemberDN.SamAccountName
            DisplayName = $MemberDN.DisplayName
        }
        $Entries = $Entries + $HashTable
    }

    Write-Verbose -Message "Displaying members of $DomainAdmins.SamAccountName"
}