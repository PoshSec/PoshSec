function Out-Baseline {
	[CmdletBinding()]
	param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [PSObject]$Object,
        [Parameter(Mandatory=$true, Position=1)]
        [string]$Prefix,
		[Parameter(ParameterSetName='Baseline')]
		[string]$Path
	)
    
    begin{
        ## Baseline Variables
        $local:BaselineFileErrorMessage = "The path specified does not exist. The baseline was not saved."
    }

    process{
        $Object = $local:object
    }

    end{
        $local:Filename = Get-DateISO8601 -Prefix $local:Prefix -Suffix ".xml"
            
    	if ($Path) {
            if (Test-Path -Path $Path) {
                $local:FilePath = Join-Path -Path $Path -ChildPath $local:Filename 
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
            $local:FilePath = Join-Path -Path $env:USERPROFILE\Documents -ChildPath $local:Filename 
        } 
        
        $local:object | Export-Clixml $local:FilePath
            
    } 

    <# 
        .Synopsis 
            This generates a baseline using the object passed to it via the pipeline. The object that is generated is a CliXML file.
        .Example 
            Get-Process | Out-Baseline -Prefix "Process"
        .Example
            Get-Process | Out-Baseline -Prefix "Process" -Path "C:\Temp"
        .Parameter Prefix
            This is the beginning of the file name for the exported data.
        .Parameter Path
            This is the location to save the specified object as a baseline.
        .Notes 
            NAME: Out-Baseline
            AUTHOR: Matt Johnson
            KEYWORDS: PoshSec
        .Link 
            http://www.poshsec.com
        .Link
            http://github.com/PoshSec
    #> 
}