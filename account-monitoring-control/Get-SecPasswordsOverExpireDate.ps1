function Get-SecPasswordsOverExpireDate {
    param (
        [Parameter(Mandatory=$true)]
        [int]$days
    )
    $list = @()
    $root = [ADSI]""            
    $search = [adsisearcher]$root            
    $search.Filter = "(&(objectclass=user)(objectcategory=user))"             
    $search.SizeLimit = 3000            
    $search.FindAll() | foreach {
        $pwdset = [datetime]::fromfiletime($_.properties.item("pwdLastSet")[0])
        $age = (New-TimeSpan $pwdset).Days

        if ($age -gt $days) {
            $list = $list + ([adsi]$_.path).DistinguishedName
        }
    } 

    Write-Output $list

    <#    
    .SYNOPSIS
        Gets current that passwords are older than a certian date.
    .DESCRIPTION
        Gets current that passwords are older than a certian date that is specified.
    .INPUTS
        System.Int32
    .PARAMETER days
        This is the number of days to check to see if an accounts passwords is older than.
    .EXAMPLE
        PS> Get-SecPasswordsOverExpireDate -days 60
            CN=Matt Johnson,OU=IS,DC=PoshSec,DC=com
            CN=Rich Cassara,OU=IS,DC=PoshSec,DC=com
    .LINK
        www.poshsec.com
    .NOTES
        This function is a PoshSec module.
    #>
}