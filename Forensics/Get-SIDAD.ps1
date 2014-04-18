function GET-SIDAD {

param(
		[Parameter(Mandatory=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
		[string]$domain
		[Parameter(Mandatory=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
		[string]$username 
		)	

$objUser = New-Object System.Security.Principal.NTAccount($domain,$username)
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
$strSID.Value