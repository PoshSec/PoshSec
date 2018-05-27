function Get-AccountsThatDontExpire {
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage="Number of objects to return in results.")]
        [int] $SizeLimit = 3000
    )

    $root = [ADSI]""
    $search = [adsisearcher]$root
    $search.Filter = "(&(objectclass=user)(objectcategory=user)(accountExpires=9223372036854775807))"
    $search.SizeLimit = $SizeLimit
    $search.FindAll() | ForEach-Object {
        $HashTable = [PSCustomObject]@{
            DisplayName = ([ADSI]$_.path).DisplayName | ForEach-Object {$_}
            SamAccountName = ([ADSI]$_.path).SamAccountName | ForEach-Object {$_}
            DistinguishedName = ([adsi]$_.path).DistinguishedName | ForEach-Object {$_}
        }
        Write-Output $HashTable
    }
    <#
    .SYNOPSIS
        Gets a list of the accounts that don't expire.
    .DESCRIPTION
        Gets a list of the accounts from the active directory domain that don't expire.
    .PARAMETER SizeLimit
        Number of objects to return in results.
    .EXAMPLE
        PS> Get-AccountThatDontExpire
            DisplayName     SamAccountName      DistinguishedName
            ----------      -------------       -----------------'
            TestAccount     TestAccount         cn=TestAccount,OU=PoshSec,DC=PoshSec,DC=Com
            Bob Uncle       Bob.Uncle           cn=Bob Uncle,OU=PoshSec,DC=PoshSec,DC=Com

    .NOTES
        Part of the PoshSec PowerShell Module
    #>


}