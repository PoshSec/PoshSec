function Get-SecDriver
{

    $computer = Get-Content env:ComputerName
    $filename = Get-DateISO8601 -Prefix ".\$computer-Drivers" -Suffix ".xml"
   
   
    Get-WindowsDriver -Online -All | Export-Clixml $filename

     if(-NOT(Test-Path ".\Baselines\$computer-Drivers-Baseline.xml"))
       {
            Rename-Item $filename "$computer-Drivers-Baseline.xml"
            Move-Item ".\$computer-Drivers-Baseline.xml" .\Baselines
            Write-Warning  "The baseline file for this computer has been created, now running the script again."
            Invoke-Expression $MyInvocation.MyCommand
        }

       else
    {
        Compare-SecDriver
    }

}
