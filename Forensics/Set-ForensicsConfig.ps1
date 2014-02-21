Function Set-ForensicsConfig
{
	<#
		.SYNOPSIS
			Configures Forensic paths
	
		.DESCRIPTION
			Sets parent path for forensic evidence - target specific folders are created in the evidence collection functions
			Sets parent path for tools for memory colletion and file copy tool
	
		.PARAMETER  Dest
			The path to the parent destination folder.
	
		.PARAMETER  Tools
			The path to the tools folder.
	
		.EXAMPLE
			PS C:\> Configure-Forensics -dest "C:\Evidence" -tools "C:\tools"
	
		.INPUTS
			System.String
	
		.NOTES
			AUTHOR: Jeff Rotenberger
			This is a part of the PoshSec Forensics module.
	
		.LINK
			www.poshsec.com
	
		.LINK
			github.com/poshsec
	
	#>
	[CmdletBinding()]
	
	param(
		[Parameter(Mandatory=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
		[string]$dest,
		[Parameter(Mandatory=$true,Position=1)]
		[ValidateNotNullOrEmpty()]
		[string]$tools
		
			)
			
	$global:PoshSecEvidencePath = $dest
	$global:PoshSecToolsPath = $tools
	

	
}