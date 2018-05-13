function Confirm-Windows8Plus {
	<#
	.SYNOPSIS
	Checks to see if the computer is using Windows 8 or above.
	.DESCRIPTION
	Checks to see if the computer is using Windows 8 or above.
	.EXAMPLE
	PS C:\> Confirm-Windows8Plus
    True
    .NOTES
	Part of the PoshSec PowerShell Module
	#>

	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", '',Justification='Plus is not plural.')]

	[CmdletBinding()]
	[OutputType([System.Boolean])]
    param()

	if(([System.Environment]::OSVersion.Version.Major -le 6) -and ([System.Environment]::OSVersion.Version.Minor -lt 2) ) {
		$false
	} else {
		$true
    }
}