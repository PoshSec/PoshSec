function Get-Netstat {             
		           
		param ( 
		   [Parameter(Mandatory=$true,Position=0)]
		   [string]$computer = $env:COMPUTERNAME, 
		   [Parameter(Mandatory=$true,Position=1)]
		   [array]$IpAddresses            
			   )             
	  
BEGIN{}#begin             
	
	PROCESS{   
	# Calls Netstat and looks for IP string
	ForEach ($IpAddress in $IpAddresses)  #calls the process for each IP
		{	
          	Write-Verbose "Run netstat"            
			Invoke-Command -ScriptBlock {netstat -ona} -ComputerName $computer |            
			Select-String -Pattern $IpAddress | 
			
	#  For each IP String identified it cleans up the data		
	foreach	{            
             Write-Verbose "Split data - remove empties"            
			 $item = $_.line.split(" ",[System.StringSplitOptions]::RemoveEmptyEntries)             
				
			 Write-Verbose "Accept Only TCP/UDP"            
				if($item[1] -notmatch '^\[::') 
					{            
					   Write-Verbose "Get local IP address"            
						if (($la = $item[1] -as [ipaddress]).AddressFamily -eq 'InterNetworkV6') 
							{             
							   $localAddress = $la.IPAddressToString             
							   $localPort = $item[1].split('\]:')[-1]             
							}             
						
						else 
							{             
							  $localAddress = $item[1].split(':')[0]             
							  $localPort = $item[1].split(':')[-1]             
							}              
						
						Write-Verbose "Get remote IP address"             
						if (($ra = $item[2] -as [ipaddress]).AddressFamily -eq 'InterNetworkV6') 
							{             
							  $remoteAddress = $ra.IPAddressToString             
							  $remotePort = $item[2].split('\]:')[-1]             
							}             
						else 
							{             
							  $remoteAddress = $item[2].split(':')[0]             
							  $remotePort = $item[2].split(':')[-1]             
							}              
					
					 New-Object -TypeName PSObject -Property @{             
						  PID = $item[-1]             
						  ProcessName = (Get-Process -Id $item[-1] -ErrorAction SilentlyContinue).Name             
						  Protocol = $item[0]             
						  LocalAddress = $localAddress             
						  LocalPort = $localPort             
						  RemoteAddress =$remoteAddress             
						  RemotePort = $remotePort             
						  State = if($item[0] -eq 'tcp') {$item[3]} else {$null}   }|
													
						select Protocol, LocalAddress, LocalPort, RemoteAddress, RemotePort, State, ProcessName, PID | Format-Table Protocol, LocalAddress, LocalPort, RemoteAddress, RemotePort, State, ProcessName, PID
						        
			 
								
							
					}   			
	} # foreach  

		}				
				}#process   
	
			
	
END{}#end            
}


		



	