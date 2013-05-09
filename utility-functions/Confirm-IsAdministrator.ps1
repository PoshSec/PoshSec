 function Confirm-IsAdministrator {
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")){
        Write-Warning "You do not have Administrator rights to run this script! Please re-run this script as an Administrator!"
        Break
    }
}