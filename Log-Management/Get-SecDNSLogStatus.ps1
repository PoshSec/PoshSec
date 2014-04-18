function Get-SecDNSLogStatus 
{

$rootpath = "systemroot\System32\Dns\" 

foreach ($f in Get-ChildItem $rootpath)
{
	foreach ($i in Get-ChildItem $f)
	{
		if (Test-Path $i -include Dns.log)
		{
			echo($i.name + "           DNS Logging Enabled")
		}
		else
		{
			echo($i.name + " ***DNS Logging NOT Enabled***")
		}
	}
}

	<#
	.SYNOPSIS
        Verifies that DNS log files exist that can then be used for inventory purposes
	
	.EXAMPLE
	PS C:\> Get-SecDNSLogStatus
        "DNS Logging Enabled"

	.LINK
	www.poshsec.com
	
	.LINK
	github.com/poshsec
	
	#> 

}
