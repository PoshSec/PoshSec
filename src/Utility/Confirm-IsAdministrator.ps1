 function Confirm-IsAdministrator {

 	<#
    .SYNOPSIS
    Checks to see if user is running as administrator
    .DESCRIPTION
    This function checks to see if the user is currently running as an administrator
    .EXAMPLE
    PS> Confirm-IsAdministrator
    False
    .EXAMPLE
    PS> if (Confirm-IsAdministrator) { Write-Host "You are an admin" }
    You are an admin
    .NOTES
    Part of the PoshSec PowerShell Module
    #>

	[CmdletBinding()]
	[OutputType([System.Boolean])]
    param()

    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")){

    	Write-Verbose -Message "You do not have Administrator rights to run this script! Please re-run this script as an Administrator!"

        return $false
    } else {
		  return $true
	}
}