function Compare-SecOpenPort
{

   <#
    .Synopsis
    Compares a reference object from Get-SecOpenPort to a difference object from Get-SecOpenPorts
    
    .Description
        Custom compare function that will compare a reference object to a difference object.
        Compare-Object does not work well with custom PSObjects and will not return accurate
        results.
    
    .Link
        https://github.com/organizations/PoshSec
        
    .Author
        Ben0xA
    #>

    Param(
        [Parameter(Mandatory=$true,Position=1)]
        [PSObject]$ReferenceObject,
        
        [Parameter(Mandatory=$true,Position=2)]
        [PSObject]$DifferenceObject,
        
        [Parameter(Mandatory=$false,Position=3)]
        [boolean]$IncludeEqual
    )
    
    $rslts = @()
    
    if(($ReferenceObject.Count -gt 0) -and ($DifferenceObject.Count -gt 0))
    {
        foreach($do in $DifferenceObject)
        {
            [int]$roidx = 0
            [boolean]$found = $False
            do
            {
                $ro = $ReferenceObject[$roidx]
                [string]$rostr = $ro.Protocol + $ro.LocalAddress + $ro.LocalPort + $ro.RemoteAddress + $ro.RemotePort + $ro.State + $ro.ProcessName
                [string]$dostr = $do.Protocol + $do.LocalAddress + $do.LocalPort + $do.RemoteAddress + $do.RemotePort + $do.State + $do.ProcessName
                if($rostr -eq $dostr)
                {
                    $found = $True
                }
                $roidx++
            } while(($roidx -lt $ReferenceObject.Count) -and (-not $found))
            if($found)
            {
                if($IncludeEqual)
                {
                    $rslt = New-Object PSObject
                    $rslt | Add-Member -MemberType NoteProperty -Name "InputObject" -Value $do
                    $rslt | Add-Member -MemberType NoteProperty -Name "SideIndicator" -Value "=="
                    
                    $rslts += $rslt
                }
            }
            else
            {
                $rslt = New-Object PSObject
                $rslt | Add-Member -MemberType NoteProperty -Name "InputObject" -Value $do
                $rslt | Add-Member -MemberType NoteProperty -Name "SideIndicator" -Value "=>"
                
                $rslts += $rslt
            }
        }
        
        foreach($ro in $ReferenceObject)
        {
            [int]$doidx = 0
            [boolean]$found = $False
            do
            {
                $do = $DifferenceObject[$doidx]
                [string]$rostr = $ro.Protocol + $ro.LocalAddress + $ro.LocalPort + $ro.RemoteAddress + $ro.RemotePort + $ro.State + $ro.ProcessName
                [string]$dostr = $do.Protocol + $do.LocalAddress + $do.LocalPort + $do.RemoteAddress + $do.RemotePort + $do.State + $do.ProcessName
                if($rostr -eq $dostr)
                {
                    $found = $True
                }
                $doidx++
            } while(($doidx -lt $DifferenceObject.Count) -and (-not $found))
            if(-not $found)
            {
                $rslt = New-Object PSObject
                $rslt | Add-Member -MemberType NoteProperty -Name "InputObject" -Value $ro
                $rslt | Add-Member -MemberType NoteProperty -Name "SideIndicator" -Value "<="
                
                $rslts += $rslt
            }
        }
    }
    
    Write-Output $rslts
}
