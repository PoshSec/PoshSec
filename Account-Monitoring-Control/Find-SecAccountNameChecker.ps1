function Find-SecAccountNameChecker
{
    
    $admin = Get-ADGroupMember -Identity administrators 
        
    foreach ($f in $admin){
        $name = Get-ADUser -Identity $f | select -Property Name 
        if ($name -match "dmin")
        {
            Write-Warning "There are one or more accounts that can be associated with special privileges."
            Write-Output $name
        }

    }
    <#    
    .SYNOPSIS
        Creates a list of accounts that could be linked to any special privileges or processes.
    .DESCRIPTION
        Searches for any account names associated with privileges or processes. Functionality must be added for an individual organization's needs.
    .EXAMPLE
        PS> Find-SecAccountNameChecker
           "There are one or more accounts that can be associated with special privileges."
           CN=MattAdmin
    .LINK
        www.poshsec.com
    .NOTES
        This function is a PoshSec module.
    #>
   
 
}
