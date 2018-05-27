function Get-AccountsThatNeverLoggedIn {
    param(
        [Parameter(HelpMessage="Days for last logon.")]
        [int]$LastLogon = 30,
        [Parameter(HelpMessage="Search size limit")]
        [int]$SizeLimit = 3000
    )

    $DateTime =  ((get-date).adddays($lastlogon)).ToFileTime()
    $TimeStamp = "{0:yyyyMMddHHmmss}.0Z" -f (get-date).adddays($lastlogon)

    $Root = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name
    $ADSISearcher = New-Object DirectoryServices.DirectorySearcher($Root)
    $ADSISearcher.Filter = "(&(objectCategory=person)(objectClass=user)(!(userAccountControl:1.2.840.113556.1.4.803:=2))(&(whenCreated<="+$TimeStamp+")(!lastlogontimestamp=*)))"
    $ADSISearcher.SizeLimit = $SizeLimit
    $ADSISearcher.FindAll()| ForEach-Object {
        $HashTable = [PSCustomObject]@{
            DisplayName = ([ADSI]$_.path).DisplayName | ForEach-Object {$_}
            SamAccountName = ([ADSI]$_.path).SamAccountName | ForEach-Object {$_}
            DistinguishedName = ([adsi]$_.path).DistinguishedName | ForEach-Object {$_}
        }
        Write-Output $HashTable
    }

    <#
    .SYNOPSIS
    Gets current list of active accounts that have not logged into Active Directory.

    .DESCRIPTION
    Gets current list of active accounts that have not logged into Active Directory

    .PARAMETER LastLogon
    Days for last logon into the domain. Default is 30.

    .PARAMETER SizeLimit
    Size limit of objects to return in query

    .EXAMPLE
    PS> Get-AccountsThatNeverLoggedIn
            DisplayName     SamAccountName      DistinguishedName
            ----------      -------------       -----------------'
            TestAccount     TestAccount         cn=TestAccount,OU=PoshSec,DC=PoshSec,DC=Com
            Bob Uncle       Bob.Uncle           cn=Bob Uncle,OU=PoshSec,DC=PoshSec,DC=Com

    .NOTES
    Part of the PoshSec PowerShell Module
    #>
}