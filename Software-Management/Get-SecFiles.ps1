function Get-SecFiles
{
 

    [string]$computer = Get-Content env:ComputerName
    [string]$filename = Get-DateISO8601 -Prefix ".\$computer-Files" -Suffix ".xml" 

    [string]$searchParameters = Get-ChildItem $env:SystemRoot -Recurse -Include *.dll,*.exe
 
    Write-Output $searchParameters | Export-Clixml $filename

    
    if(-NOT(Test-Path ".\Baselines\$computer-Files-Baseline.xml"))
    {
        Rename-Item $filename "$computer-Files-Baseline.xml"
        Move-Item "$computer-Files-Baseline.xml" .\Baselines
         Write-Warning "The baseline file for this computer has been created, now running the script again."
        Invoke-Expression $MyInvocation.MyCommand
	    
    }

    else
    {
        Compare-SecFiles
    }
     
     	<#
	.SYNOPSIS
        Finds all executables and .dlls and constructs a list of those resources
	
	.DESCRIPTION
	Designed to search through the files and find any .dlls or .exes and then construct a list of those resources.
        Calls itself recursively and allows it to search through all directories
        Then calls Compare function to provide exception report

	.EXAMPLE
	PS C:\> Get-SecFiles

	.LINK
	www.poshsec.com
	
	.LINK
	github.com/poshsec
	
	#>
 

}
