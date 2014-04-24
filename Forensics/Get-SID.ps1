function GET-SID {

param(
		[Parameter(Mandatory=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
		[string]$username 
		)	

$objUser = New-Object System.Security.Principal.NTAccount($username)
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
$strSID.Value
