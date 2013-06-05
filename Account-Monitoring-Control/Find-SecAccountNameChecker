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
    #Search for names associated with processes
    #Output that list
    
    
    <#
    Creates a list of accounts that could be linked to any special privileges or processes.
    #>
}
