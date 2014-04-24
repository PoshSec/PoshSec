function Get-SecAllAccount {

    [CmdletBinding()]
    param(
        [switch]$CreateBaseline
    )

     if (Get-Module -Name "ActiveDirectory" -ErrorAction SilentlyContinue) {
        Write-Verbose -Message "Using Active Directory Cmdlets"
        $list = Get-ADUser
    } else {

        $list = @()
        $root = [ADSI]""            
        $search = [adsisearcher]$root            
        $search.Filter = "(&(objectclass=user)(objectcategory=user))"             
        $search.SizeLimit = 3000            
        $search.FindAll() | foreach {
           $list = $list + ([adsi]$_.path).DistinguishedName
        } 
    }

     if ($CreateBaseline) {
        $filename = Get-DateISO8601 -Prefix "All-Accounts" -Suffix ".xml"
        Write-Verbose -Message "Creating baseline. Filename is $filename"
        $list | Export-Clixml $filename
    } else {
        $list
    }


    <#    
    .SYNOPSIS
        Gets list of all accounts.
    .DESCRIPTION
        Gets list of all accounts in the domain.
    .EXAMPLE
        PS> Get-SecAllAccount
            CN=Matt Johnson,OU=IS,DC=PoshSec,DC=com
            CN=Rich Cassara,OU=IS,DC=PoshSec,DC=com
            ..
    .LINK
        www.poshsec.com
    .NOTES
        This function is a PoshSec module.
    #>
}