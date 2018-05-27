function Get-InactiveAccount {
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage = "Number of days to check for")]
        [int]$LastLogonLimit = 90,
        [Parameter(HelpMessage="Search size limit")]
        [int]$SizeLimit = 3000

    )

    $Root = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name
    $ADSISearcher = New-Object DirectoryServices.DirectorySearcher($Root)
    $ADSISearcher.SizeLimit = $SizeLimit
    $ADSISearcher.Filter = "(&(objectCategory=person)(objectClass=user)(!(userAccountControl:1.2.840.113556.1.4.803:=2))(lastLogonTimeStamp<=$LastLogonLimit))"

    $ADSISearcher.FindAll() | ForEach-Object {
        $HashTable = [PSCustomObject]@{
            DisplayName = ([ADSI]$_.path).DisplayName | ForEach-Object {$_}
            SamAccountName = ([ADSI]$_.path).SamAccountName | ForEach-Object {$_}
            DistinguishedName = ([adsi]$_.path).DistinguishedName | ForEach-Object {$_}
        }
        Write-Output $HashTable
    }
    <#
    .SYNOPSIS
    Gets current list of inactive accounts in Active Directory.

    .DESCRIPTION
    Gets current list of inactive accounts in Active Directory

    .PARAMETER LastLogonLimit
    Number of days to check for

    .PARAMETER SizeLimit
    Search size of query

    .EXAMPLE
    PS> Get-DisabledAccount
            DisplayName     SamAccountName      DistinguishedName
            ----------      -------------       -----------------
            TestAccount     TestAccount         cn=TestAccount,OU=PoshSec,DC=PoshSec,DC=Com
            Bob Uncle       Bob.Uncle           cn=Bob Uncle,OU=PoshSec,DC=PoshSec,DC=Com

    .EXAMPLE
    PS> Get-DisabledAccount -LastLogonLimit 90
            DisplayName     SamAccountName      DistinguishedName
            ----------      -------------       -----------------
            Bob Uncle       Bob.Uncle           cn=Bob Uncle,OU=PoshSec,DC=PoshSec,DC=Com

    .NOTES
    Part of the PoshSec PowerShell Module
    #>
}