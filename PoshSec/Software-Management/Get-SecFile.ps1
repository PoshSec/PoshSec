function Get-SecFile
{
	<#
		.SYNOPSIS
			Search through the path specified's files and find any .dlls or .exes and then construct a list of those resources.
	
		.DESCRIPTION
			Search through the path specified's files and find any .dlls or .exes and then construct a list of those resources. This only searches for .exe and .dll files.
	
		.PARAMETER  Path
			The path of the folder you would like to collect files from.
	
		.PARAMETER  Baseline
			Triggers the creation of a baseline.
	
		.PARAMETER  BaselinePath
			Designates a location for the baseline to be saved.
	
		.EXAMPLE
			PS C:\> Get-SecFile -Path $env:systemroot
	
		.EXAMPLE
			PS C:\> Get-SecFile -Path "C:\Program Files\" -Baseline
	
		.INPUTS
			System.String, System.Boolean
	
		.OUTPUTS
			PSObject
	
		.NOTES
			AUTHOR: Nick Jacob, Matt Johnson
			This is part of the PoshSec Software-Management module.
	
		.LINK
			www.poshsec.com
	
		.LINK
			github.com/poshsec
	
	#>
	
 	[CmdletBinding()]
	param(
		[Parameter(Position=0)]
		[string] $Path = "$env:SystemRoot",
        ## Baseline Parmerter Set
        [Parameter(ParameterSetName='Baseline')]
		[switch]$Baseline,
		[Parameter(ParameterSetName='Baseline')]
		[string]$BaselinePath
	)
    
    begin{
        ## Script Variables
        $local:BaselinePrefix = "Files"
        $local:BaselineFileErrorMessage = "The path specified does not exist. The baseline was not saved."
		
		 if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")){
			Write-Error -Message "You must be an administrator to run this feature."
			break
		}
    }
    process{
        $local:object = Get-ChildItem $Path -Recurse -Include *.dll,*.exe
    }
    end{
        if($Baseline) {
            $local:Filename = Get-DateISO8601 -Prefix $local:BaselinePrefix -Suffix ".xml"
             
    	    if ($BaselinePath) {
                if (Test-Path -Path $BaselinePath) {
                    $local:FilePath = Join-Path -Path $BaselinePath -ChildPath $local:Filename 
                } else {
                    Write-Warning -Message $local:BaselineFileErrorMessage
                    break
                }
    	    } elseif ($global:PoshSecBaselinePath) {
                if (Test-Path -Path $global:PoshSecBaselinePath) {
                    $local:FilePath = Join-Path -Path $global:PoshSecBaselinePath -ChildPath $local:Filename 
                } else {
                    Write-Warning -Message $local:BaselineFileErrorMessage
                    break
                }
    	    } else {
                if ([System.Environment]::OSVersion.Version.Major -le 5){
					$local:FilePath = Join-Path -Path "$env:USERPROFILE\My Documents" -ChildPath $local:Filename
				} else {
					$local:FilePath = Join-Path -Path $env:USERPROFILE\Documents -ChildPath $local:Filename
				} 
            } 

           $local:object | Export-Clixml $local:FilePath
            
        } else {
            Write-Output $local:object
        }
    }
}
