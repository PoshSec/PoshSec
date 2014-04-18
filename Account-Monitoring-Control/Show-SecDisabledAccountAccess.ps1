function Show-SecDisabledAccountAccess 
{
    

    [CmdletBinding()]
    param (
        [Parameter(Position=1, Mandatory=$false)]
        [string]$computerName = $env:COMPUTERNAME
    )
    begin {
        if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
        {
            Write-Warning "You do not have Administrator rights to run this script! Please re-run this script as an Administrator!"
            Break
        }
    }
    process {
        Get-EventLog -LogName 'Security' -ComputerName $computerName | Where-Object {($_.EventID -like 4625) -and ($_.ReplacementStrings[4] -eq '0xC0000072')} | Select-Object timegenerated, message, @{n='UserName';e={$_.ReplacementStrings[0]}} 
    }

    <#    
    .SYNOPSIS
        Shows attempts at accessing an account that is disabled.
    .DESCRIPTION
        Shows attempts at accessing an account that is disabled via the security log. You must be an administrator to run.
    .INPUTS
        System.String
    .PARAMETER computerName
        Name of computer from which to collect invalid access attempts.
    .EXAMPLE
        PS> Show-SecDisabledAccountAccess -computerName DC1
            CN=Matt Johnson,OU=IS,DC=PoshSec,DC=com
            CN=Rich Cassara,OU=IS,DC=PoshSec,DC=com
    .LINK
        www.poshsec.com
    .NOTES
        This function is a PoshSec module.
    #>
    
} 
