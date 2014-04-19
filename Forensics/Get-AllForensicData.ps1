Function Get-AllForensicData {
<#
		.SYNOPSIS
			Captures all Forensic Data for a target
	
		.DESCRIPTION
			Grabs memory image, volatile and non-volatile data and user data for target
	
		.PARAMETER  Target
			The targeted host for forensics
	
		.EXAMPLE
			PS C:\> Get-AllForensicData "computer13L"
	
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
	
	param(
			[Parameter(Mandatory=$true,Position=0)]
			[ValidateNotNullOrEmpty()]
			[string]$target

		$global:PoshSecEvidenceTarget = $target

	
		Get-MemImage
		Get-VolatileData
		Get-NonVolatileData
		Get-UserInfo
	}