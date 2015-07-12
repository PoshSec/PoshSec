function Get-SecAdminAccount
{
    
    <#
      Synopsis
      Gets a list of accounts that are members of various administrator groups, then compares it to the baseline list
    
    #>
    
    $filename = Get-DateISO8601 -Prefix "Admin-Report" -Suffix ".xml"
    
    Get-ADGroupMember -Identity administrators | Export-Clixml $filename
    if(-NOT(Test-Path ".\Baselines\Admin-Baseline.xml"))
    {
	    Rename-Item $filename "$computer-Integrity-Baseline.xml"
	    Move-Item ".\$computer-Integrity-Baseline.xml" .\Baselines
	    if(Test-Path ".\Baselines\Admin-Baseline.xml"){
   	        Write-Warning "The admin baseline has been created, running the script again."
            Invoke-Expression $MyInvocation.MyCommand
        }
	    
    }
    
    [System.Array]$current = Import-Clixml $filename
    [System.Array]$approved = Import-Clixml ".\Baselines\Admin-Baseline.xml"
    
    Move-Item $filename .\Reports
    
    $exception = Get-DateISO8601 -Prefix "Admin-Exception" -Suffix ".xml"

    Compare-Object -ReferenceObject $approved -DifferenceObject $current -CaseSensitive | Export-Clixml  ".\Exception-Reports\$exception"
    

}
