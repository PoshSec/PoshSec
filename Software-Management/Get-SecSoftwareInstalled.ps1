function Get-SecSoftwareInstalled
{
    <#
    .Synopsis
        Baselines the installed software to an XML file.
    .Description
        Baselines the installed software to an XML file.
        
        CSIS 20 Critical Security Controls for Effective Cyber Defense excerpt:
		Devise a list of authorized software that is required in the enterprise for each type of system, including servers, workstations, and laptops of various kinds and uses. This list should be tied to file integrity checking software to validate that the software 
    .Example
        Get-InstalledSoftware
    .Link
        https://github.com/organizations/PoshSec
    #>
	

    [string]$computer = Get-Content env:ComputerName

    [string]$filename = Get-DateISO8601 -Prefix ".\$computer-Software" -Suffix ".xml"
    

    Get-ItemProperty  HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |Select @{name="ComputerName";expression={"$env:computername"}}, DisplayName, DisplayVersion, Publisher, InstallDate, HelpLink, UninstallString | Export-Clixml $filename

   

    if(-NOT(Test-Path ".\Baselines\$computer-Installed-Baseline.xml"))
    {
	    Rename-Item $filename "$computer-Installed-Baseline.xml"
	    Move-Item ".\$computer-Installed-Baseline.xml" .\Baselines
	    Write-Warning "The baseline file for this computer has been created, now running the script again."
        Invoke-Expression $MyInvocation.MyCommand
	    
    }

}
