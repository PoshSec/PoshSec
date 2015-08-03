function Get-SecDomainAdmins {
  <#
      .SYNOPSIS
        Gets members of the Domain Admins group.
      .DESCRIPTION
        This grabs the members of the current domain's Domain Admins group.
      .NOTES
        This is a member of the PoshSec Account Monitoring and Control module
      .EXAMPLE
        Get-SecDomainAdmins

        CN=Matt Johnson, OU=Users, DC=PoshSec, DC=COM          
        CN=Ben Ten, OU=Users, DC=PoshSec, DC=COM
        CN=Bob Newhart, OU=Users, DC=PoshSec, DC=COM
    #>

  [CmdletBinding()]
  param()
  
  Write-Verbose -Message '******* ENTERING GET-SECDOMAINADMINS *******'
  Write-Verbose -Message 'Getting current forest.'
  $Forest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
  Write-Verbose -Message 'Getting current domain.'
  $Domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
  Write-Verbose "Current domain is $Domain"
  $RootDomain = [string]($Domain.Name)

  Write-Verbose -Message 'Converting fully qualified domain name to a distinguished name.'
  $DomainDN = Convert-FQDNtoDN -domainFQDN $RootDomain
  
  Write-Verbose -Message 'Locating global catalog server'
  $GlobalCatalog = $Forest.FindGlobalCatalog()
  Write-Verbose -Message "------- Global catalog server is: $GlobalCatalog"
  $ActiveDirectoryObj = [adsi]"GC://$DomainDN"
  Write-Verbose -Message 'Determining the domain SID'
  $DomainSID = New-Object System.Security.Principal.SecurityIdentifier($ActiveDirectoryObj.objectSid[0],0)
  $DomainSID = $DomainSID.ToString()
  Write-Verbose -Message "------- The domain SID is: $DomainSID"
  $DomainAdminSid = "$DomainSID-512"
  Write-Verbose -Message "------- The domain admin sid is: $DomainAdminSid"
  Write-Verbose -Message 'Creating Global Catalog Searcher'
  $Searcher = $GlobalCatalog.GetDirectorySearcher()
  Write-Verbose -Message 'Setting filter to find domain admins group'
  $Searcher.Filter = "(objectSID=$DomainAdminSid)"
  Write-Verbose -Message 'Locating the domain admins group.'
  $Results = $Searcher.FindAll()
  Write-Verbose -Message 'Looping through results of search.'
  Foreach($Result in $Results) {
    $Group = $Result.properties.distinguishedname 
  }

  Write-Verbose -Message 'Obtaining Domain Admins Group'
  $ADObject = [adsi]"LDAP://$Group"
  Write-Verbose -Message 'Getting Domain Admins Group Membership list'
  $Members = $ADObject.Properties.item('member')
  Write-Verbose -Message 'Exporting membersip list.'
  ForEach ($Member in $Members) {
    Write-Output $Member
  }

  Write-Verbose -Message '******* EXITING GET-SECDOMAINADMINS *******'
}
