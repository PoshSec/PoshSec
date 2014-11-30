function Get-SecLocalSID {
  param(
	  [Parameter(Mandatory=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
		[string]$username 
	)	

  $objUser = New-Object System.Security.Principal.NTAccount($username)
  $strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
  $strSID.Value

  
    <#    
    .SYNOPSIS
        Gets the local SID for the specified username.
    .DESCRIPTION
        Obtains the local Security Identifier (SID) for the specified username
    .EXAMPLE
        Get-SecLocalSID -Username 'Matt'

    .LINK
        www.poshsec.com
    #>

}