function Get-SecAllADAccount {
  [CmdletBinding()]
  param(
    [int]$SizeLimit = 3000
  )
  Write-Verbose -Message 'Starting Get-SecAllADAccount'
  
  Write-Verbose -Message 'Creating an empty array'
  $list = @()
  
  Write-Verbose -Message 'Connecting to domain root.'
  $root = [ADSI]''
  
  Write-Verbose -Message 'Setting Searcher Root'            
  $search = [adsisearcher]$root
  
  Write-Verbose -Message 'Setting search LDAP filter.'
  $search.Filter = '(&(objectclass=user)(objectcategory=user))'
  
  Write-Verbose -Message "Setting search size limit to $SizeLimit"             
  $search.SizeLimit = $SizeLimit
  
  Write-Verbose -Message 'Getting all the results and looping through each result'
  $search.FindAll() | foreach {
    Write-Verbose "Adding $(([adsi]$_.path).DistinguishedName) to the array."
    $list = $list + ([adsi]$_.path).DistinguishedName
  } 
  
  Write-Verbose -Message "Exporting $($list.Length) objects."
  Write-Output -InputObject $list

  Write-Verbose -Message 'Ending Get-SecAllADAccount'
  <#    
    .SYNOPSIS
        Gets list of all accounts.
        Author: Matthew Johnson (@mwjcomputing)
        Project: PoshSec/Account-Monitoring-Control
        License: BSD-3
        Required Dependencies: None
        Optional Dependencies: None
    .DESCRIPTION
        Gets list of all accounts in the domain.
    .INPUTS
        System.Int32. Get-SecAllADAccounts accepts the size of the search to conduct.
    .EXAMPLE
        PS> Get-SecAllAccount
            CN=Matt Johnson,OU=IS,DC=PoshSec,DC=com
            CN=Rich Cassara,OU=IS,DC=PoshSec,DC=com
            ..
    .LINK
        www.poshsec.com
    .LINK
        https://github.com/PoshSec
    .NOTES
        This is part of the PoshSec PowerShell Module's Account Monitoring and Control submodule.
    #>
}