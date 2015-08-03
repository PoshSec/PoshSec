function Get-SecDomainAdmins {
  <#
      .SYNOPSIS
        Gets members of the Domain Admins group.
      .DESCRIPTION
        This grabs the members of the current domain's Domain Admins group.
      .NOTES
        This is a member of the PoshSec Account Monitoring and Control module.

        You MUST have access into the domain you are enumerating.
      .EXAMPLE
        Get-SecDomainAdmins -CurrentDomain

        CN=Matt Johnson,OU=Users,DC=PoshSec,DC=COM          
        CN=Ben Ten,OU=Users, DC=PoshSec, DC=COM
        CN=Bob Newhart,OU=Users,DC=PoshSec,DC=COM
      .EXAMPLE
        Get-SecDomainAdmins -Domain dev.poshsec.com -forest poshsec.com

        CN=MWJ Dev,OU=Users,DC=DEV,DC=POSHSEC,DC=COM
        CN=BT Dev,OU=Users,DC=DEV,DC=POSHSEC,DC=COM
    #>

  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true,ParameterSetName = 'CurrentDomain')]
    [switch]$CurrentDomain,
    [Parameter(Mandatory=$true,ParameterSetName = 'TypedInfo')]
    [String]$Forest,
    [Parameter(Mandatory=$true,ParameterSetName = 'TypedInfo')]
    [string]$Domain
  )
  
  Write-Verbose -Message '******* ENTERING GET-SECDOMAINADMINS *******'

  if ($Forest -and $Domain) {
    Write-Verbose -Message "Setting Forest Context to: $Forest"
    $ForestType = [System.DirectoryServices.ActiveDirectory.DirectoryContextType]::Forest
    $ForestContext = New-Object -TypeName System.DirectoryServices.ActiveDirectory.DirectoryContext -ArgumentList $ForestType, $Forest
    $SetForest = [System.DirectoryServices.ActiveDirectory.Forest]::GetForest($ForestContext)
    
    Write-Verbose -Message "Setting Domain Context to: $Domain"
    $DomainType = [System.DirectoryServices.ActiveDirectory.DirectoryContextType]::Domain
    $DomainContext = New-Object -TypeName System.DirectoryServices.ActiveDirectory.DirectoryContext -ArgumentList $DomainType, $Domain
    $SetDomain = [System.DirectoryServices.ActiveDirectory.Domain]::GetDomain($DomainContext)
  }
  else {
    Write-Verbose -Message 'Getting current forest.'
    $SetForest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
    Write-Verbose -Message 'Getting current domain.'
    $SetDomain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
  }

  Write-Verbose "Current domain is $Domain"
  $RootDomain = [string]($SetDomain.Name)

  Write-Verbose -Message 'Converting fully qualified domain name to a distinguished name.'
  $DomainDN = Convert-FQDNtoDN -domainFQDN $RootDomain
  
  Write-Verbose -Message 'Locating global catalog server'
  $GlobalCatalog = $SetForest.FindGlobalCatalog()
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
