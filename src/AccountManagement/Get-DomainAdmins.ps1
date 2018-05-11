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

    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns','',Justification='Group name is Domain Admins')]
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
    $DomainAdmins = [ADSI]"LDAP://cn=Domain Admins,cn=Users,$DN"
    Write-Debug -Message "Set Domain Admin string to $DomainAdmins"

    $ItemCount = $DomainAdmins.Count
    #Write-Verbose -Message "Total number of members: $ItemCount"

    Foreach($Member in $DomainAdmins.Member) {
        $MemberDN = [ADSI]"LDAP://$Member"
        Write-Debug -Message "MemberDN: $MemberDN"
        $HashTable = [PSCustomObject]@{
            SamAccountName = $MemberDN.SamAccountName
            DisplayName = $MemberDN.DisplayName
        }
        Write-Output $HashTable
    }
    Write-Verbose -Message "Displaying members of $DomainAdmins.SamAccountName"
}