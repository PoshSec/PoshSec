function Get-SecDNSLogStatus {

Add-CommentHelp -Description GET-SecDNSLogStatus -Synopsis "Get-SecDNSLogStatus verifies that DNS log files exist that can then be used for inventory purposes."

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
}