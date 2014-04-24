function Get-SecAccountThatDontExpire {
    [CmdletBinding()]
    param(
        [switch]$CreateBaseline
    )

     if (Get-Module -Name "ActiveDirectory" -ErrorAction SilentlyContinue) {
        Write-Verbose -Message "Using Active Directory Cmdlets"
        $list = Search-ADAccount -PasswordNeverExpires
    } else {

        $list = @()
        $root = [ADSI]""
        $search = [adsisearcher]$root
        $search.Filter = "(&(objectclass=user)(objectcategory=user)(accountExpires=9223372036854775807))"
        $search.SizeLimit = 3000
        $search.FindAll() | foreach {
            $list = $list + ([adsi]$_.path).DistinguishedName
        } 
    }

     if ($CreateBaseline) {
        $filename = Get-DateISO8601 -Prefix "Never-Expire" -Suffix ".xml"
        Write-Verbose -Message "Creating baseline. Filename is $filename"
        $list | Export-Clixml $filename
    } else {
        $list
    }
﻿
    

    <#    
    .SYNOPSIS
        Gets a list of the accounts that don't expire.
    .DESCRIPTION
        Gets a list of the accounts from the active directory domain that don't expire.
    .EXAMPLE
        PS> Get-SecAccountThatDontExpire
            CN=Matt Johnson,OU=IS,DC=PoshSec,DC=com
            CN=Rich Cassara,OU=IS,DC=PoshSec,DC=com
    .LINK
        www.poshsec.com
    .NOTES
        This function is a PoshSec module.
    #>
      
    
}
