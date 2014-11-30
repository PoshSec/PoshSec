function Get-SecADSid {

  param(
		[Parameter(Mandatory=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
		[string]$domain,
		[Parameter(Mandatory=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
		[string]$username 
		)	

  $objUser = New-Object System.Security.Principal.NTAccount($domain,$username)
  $strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
  $strSID.Value
  
  
    <#    
    .SYNOPSIS
        Gets the Active Directory SID for the specified domain and username.
    .DESCRIPTION
        Obtains the Active Directory Security Identifier (SID) for the specified domain and username.
    .EXAMPLE
        Get-SecADSid -Domain 'Test' -Username 'Matt'

    .LINK
        www.poshsec.com
    #>


}