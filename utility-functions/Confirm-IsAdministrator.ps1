 function Confirm-IsAdministrator {
    param(
        [Switch]$WriteMessage
    )
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")){
        if ($WriteMessage){
                Write-Host -ForegroundColor Yellow "You do not have Administrator rights to run this script! Please re-run this script as an Administrator!"
        }
        return $false
    }
}