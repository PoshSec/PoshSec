function Get-SecDNSLogStatus {
  
    <#    
    .SYNOPSIS
        This command checks to see if DNS logging is enabled.
    .DESCRIPTION
        This command checks to see if DNS logging is enabled on the localhost.
    .EXAMPLE
        Get-SecDNSLogStatus

    .LINK
        http://www.poshsec.com/
    .NOTES
        This function should be ran locally or using the PoshSec Framework.
    #>

  $rootpath = '$env:systemroot\System32\Dns\' 

  if (Test-Path -Path $rootpath) {
    foreach ($f in Get-ChildItem $rootpath)
    {
	    foreach ($i in Get-ChildItem $f)
	    {
		    if (Test-Path $i -include Dns.log)
		    {
		  	  Write-Output($i.name + '           DNS Logging Enabled')
		    }
		    else
		    {
		  	  Write-Output($i.name + ' ***DNS Logging NOT Enabled***')
		    }
	    }
    }
  } else {
    Write-Error -Message 'DNS does not appear to be installed on this machine.'
  }



}