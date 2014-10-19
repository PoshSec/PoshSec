Function Get-SecCurrentControlSet {
	Get-ItemProperty HKLM:\system\select\ -Name 'Current'

    <#    
    .SYNOPSIS
        Gets the current control set the machine is using.
    .DESCRIPTION
        Gets the current control set the machine is using.
    .EXAMPLE
        Get-SecCurrentControlSet

    .LINK
        www.poshsec.com
    #>
}
	