function Get-VolatileData {

param(
		[Parameter(Mandatory=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
		[string]$target=$global:PoshSecEvidenceTarget 
		)	
	$target = $global:PoshSecEvidenceTarget


## ----------------------------------------------------------------------------------------------------------------------------------------
## Region OS architecture detection
## ----------------------------------------------------------------------------------------------------------------------------------------
		$proc = get-wmiobject win32_processor -ComputerName $target | where {$_.deviceID -eq "CPU0"}
			If ($proc.addresswidth -eq '64')
				{
				$OSArch = '64'
				}
			ElseIf ($proc.addresswidth -eq '32')
				{
				$OSArch = '32'
				}
				
## ----------------------------------------------------------------------------------------------------------------------------------------				
## end Region OS architecture detection
## ----------------------------------------------------------------------------------------------------------------------------------------
## Configure Folders for data collection - sets up folders based on computer's name and timestamp of artifact collection
## ----------------------------------------------------------------------------------------------------------------------------------------

	Write-Host -Fore Green "Configuring Folders...."

		New-PSDrive -Name X -PSProvider filesystem -Root \\$target\c$ | Out-Null  

		$date = Get-Date -format yyyy-MM-dd_HHmm_
		$artFolder = $date + $target + "Volatile"
		$dest = "$global:PoshSecEvidencePath\$artFolder"
		
## ----------------------------------------------------------------------------------------------------------------------------------------

	$CompName = $target

	$UserDirectory = (gi env:\userprofile).value 

	$User = (gi env:\USERNAME).value  #this pulls logged user and should be adjusted 

	$Date = (Get-Date).ToString('MM.dd.yyyy')

	$head = '<style> BODY{font-family:caibri; background-color:Aliceblue;} 
	TABLE{border-width: 1px;border-style: solid;border-color: black;bordercollapse: collapse;} TH{font-size:1.1em; border-width: 1px;padding: 2px;borderstyle: solid;border-color: black;background-color:PowderBlue} TD{border-width: 
	1px;padding: 2px;border-style: solid;border-color: black;backgroundcolor:white} </style>'

	$OutLevel1 = "$dest\$CompName-$Date.html"
			
	$TList = @(tasklist /V /FO CSV | ConvertFrom-Csv)

	$ExecutableFiles = @("*.EXE","*.COM","*.BAT","*.BIN",
	"*.JOB","*.WS",".WSF","*.PS1",".PAF","*.MSI","*.CGI","*.CMD","*.JAR","*.JSE","*
	.SCR","*.SCRIPT","*.VB","*.VBE","*.VBS","*.VBSCRIPT","*.DLL")

## Create Artifact Directories
## ----------------------------------------------------------------------------------------------------------------------------------------
	Write-Host -Fore Green "Creating Artifact Directories...."
	$dirList = ("$dest\network","$dest\prefetch","$dest\AppCompat","$dest\users")
	New-Item -Path $dest -ItemType Directory
	New-Item -Path $dirList -ItemType Directory | Out-Null
	
## Windows OS Version - Malware Forensics page 19
## ----------------------------------------------------------------------------------------------------------------------------------------

		$VERSION = (gwmi win32_OperatingSystem).Version 
		(gwmi win32_OperatingSystem).Version  > $dest\SystemInfo_1_os-version.txt	
		
## Copy Prefetch files  - Powershell can copy without the use of robocopy
## ----------------------------------------------------------------------------------------------------------------------------------------
	
	Write-Host -Fore Green "Pulling prefetch files...."
	Copy-Item x:\windows\prefetch\*.pf $dest\prefetch -recurse
	gci -path X:\windows\prefetch\*.pf -ea 0 | select Name,LastAccessTime,CreationTime | sort LastAccessTime | ConvertTo-html -Body "<H2> Prefetch Files </H2>" >> $OutLevel1
		
		
## Copy RecentFileCache
## ----------------------------------------------------------------------------------------------------------------------------------------
				
		Copy-Item -force "$env:WINDIR\AppCompat\Programs\RecentFileCache.bcf" | Out-file $dest\AppCompat\RecentFileCache.bcf
		Write-Host -Fore Green "Copying Recent File Cache."
		date | select DateTime | ConvertTo-html -Body "<H2> Recent File Cache Copied. </H2>" >> $OutLevel1	

Write-Host -Fore Green "Pulling Process Information...."
	date | select DateTime | ConvertTo-html -Body "<H2> Process Information Extraction Started </H2>" >> $OutLevel1
	
	#Process Information - Malware Forensics page 35 or WFA page 26
	Get-Process | Out-File $dest\ProcessInfo_1_running-process.txt
	date | select DateTime | ConvertTo-html -Body "<H2> Running Processes </H2>" >> $OutLevel1
	
	#TastList Information - Malware Forensics page 36 and WFA page 26
	Tasklist.exe -v /fo table > $dest\ProcessInfo_1_running-process-memory-usage.txt
	date | select DateTime | ConvertTo-html -Body "<H2> Tasklist Information </H2>" >> $OutLevel1
		
	#Process to exe mapping - Malware Forensics page 37
	gwmi win32_process |ft Name, ProcessID, ParentProcessID -a > $dest\ProcessInfo_2_process-to.exe-mapping.txt
	date | select DateTime | ConvertTo-html -Body "<H2> Process to EXE Mapping </H2>" >> $OutLevel1
	
	#Process to user mapping #REFINE Malware Forensics page 38
	get-wmiobject win32_process | Get-ProcessOwner | Select Name,CreationDate,Priority,ProcessID,ParentProcessID,Path,Owner,Computername |Out-File $dest\ProcessInfo_3_process-to-user-mapping.txt
	date | select DateTime | ConvertTo-html -Body "<H2> Process to User Mapping </H2>" >> $OutLevel1	
	
	#Process to user mapping tab delimited Malware Forensics page 38
	get-wmiobject win32_process | Get-ProcessOwner | Select Name,CreationDate,Priority,ProcessID,ParentProcessID,Path,Owner,Computername |Export-CSV $dest\ProcessInfo_3_process-to-user-mapping.csv
	date | select DateTime | ConvertTo-html -Body "<H2> Process to User Mapping CSV </H2>" >> $OutLevel1
	
	#Child Processes - Malware Forensics page 40 or WFA page 26
	date | select DateTime | ConvertTo-html -Body "<H2> Child Processes </H2>" >> $OutLevel1
			
			Function Show-ProcessTree
		{
			Function Get-ProcessChildren($P,$Depth=1)
			{
				$procs | Where-Object {$_.ParentProcessId -eq $p.ProcessID -and $_.ParentProcessId -ne 0} | ForEach-Object {
					"{0}|--{1}" -f (" "*3*$Depth),"$($_.Name),$($_.ProcessID)"
					Get-ProcessChildren $_ (++$Depth)
					$Depth--
				}
			}

			$filter = {-not (Get-Process -Id $_.ParentProcessId -ErrorAction SilentlyContinue) -or $_.ParentProcessId -eq 0}
			$procs = Get-WmiObject Win32_Process
			$top = $procs | Where-Object $filter | Sort-Object ProcessID
			foreach ($p in $top)
			{
				Write-Output "$($p.Name),$($p.ProcessID)"
				Get-ProcessChildren $p
			}
		}

		Show-ProcessTree | Out-File $dest\ProcessInfo_4_child-processes.txt	
	
	#Process File Handles - Malware Forensics page 42 or WFA page 27  -COMMENTED OUT FOR NOW
	#date | select DateTime | ConvertTo-html -Body "<H2> Process File Handles </H2>" >> $OutLevel1
	#$command = '$tools\handle.exe /accepteula >> $dest\ProcessInfo_5_process-file-handles.txt'
	#iex "& $command"
	
	#Process Dependencies - Malware Forensics page 44 or WFA page 26
	date | select DateTime | ConvertTo-html -Body "<H2> Process Dependencies </H2>" >> $OutLevel1
	Get-Process | select ProcessName -expand Modules -ea 0 | Format-Table Processname, modulename, filename -Groupby Processname | Out-File $dest\ProcessInfo_6_process-dependencies.txt
## ----------------------------------------------------------------------------------------------------------------------------------------	

#NETWORK INFORMATION
	Write-Host -Fore Green "Pulling network information...."
	
	date | select DateTime | ConvertTo-html -Body "<H2> Gathering Network Information </H2>" >> $OutLevel1
	Get-WMIObject Win32_NetworkAdapterConfiguration -ComputerName $target -Filter "IPEnabled='TRUE'" | select DNSHostName,ServiceName,MacAddress,@{l="IPAddress";e={$_.IPAddress -join ","}},@{l="DefaultIPGateway";e={$_.DefaultIPGateway -join ","}},DNSDomain,@{l="DNSServerSearchOrder";e={$_.DNSServerSearchOrder -join ","}},Description | Export-CSV $dest\network\netinfo.csv -NoTypeInformation | Out-Null
	
		#Active Network Connection - Malware Forensics page 26 or WFA page 21
		date | select DateTime | ConvertTo-html -Body "<H2> Active Network Connections </H2>" >> $OutLevel1
		netstat.exe -ano > $dest\network\NetworkInfo_1_Active_Connections.txt
	
		#DNS Queries Cache - Malware Forensics page 27
		date | select DateTime | ConvertTo-html -Body "<H2> DNS Queries Cache </H2>" >> $OutLevel1
		ipconfig /displaydns | select-string 'Record Name' | Sort | ConvertTo-html -Body "Results">> $OutLevel1
		ipconfig /displaydns | Out-file $dest\network\NetworkInfo_2_dns-queries-cache.txt
				
		#NetBios Sessions - Malware Forensics page 29
		date | select DateTime | ConvertTo-html -Body "<H2> NetBios Sessions </H2>" >> $OutLevel1
		nbtstat.exe -s > $dest\network\NetworkInfo_3_netbios-sessions.txt
				
		#Netbios Cache - Malware Forensics page 30 or WFA page 20
		date | select DateTime | ConvertTo-html -Body "<H2> NetBios Cache </H2>" >> $OutLevel1
		nbtstat.exe -c > $dest\network\NetworkInfo_4_netbios-cache.txt
				
		#Recently Transferred Files over Netbios - Malware Forensics page 30
		date | select DateTime | ConvertTo-html -Body "<H2> Recently Transferred Files </H2>" >> $OutLevel1
		net.exe file > $dest\network\NetworkInfo_5_file-transfer-over-netbios.txt
				
		#ARP Cache - Malware Forensics page 31
		date | select DateTime | ConvertTo-html -Body "<H2> Arp Cache </H2>" >> $OutLevel1
		arp.exe -a > $dest\NetworkInfo_6_arp-cache.txt
		
		#Routing Table - WFA page 23
		date | select DateTime | ConvertTo-html -Body "<H2> Routing Table </H2>" >> $OutLevel1
		netstat.exe -r > $dest\network\NetworkInfo_7_routing-table.txt
				
		#Open Ports - Malware Forensics page 49
		date | select DateTime | ConvertTo-html -Body "<H2> Open Ports </H2>" >> $OutLevel1
		netstat.exe -a > $dest\network\Networking_8_port-to-process-mapping-group.txt
				
		#Port to Process Mapping - WFA page 32
		
			date | select DateTime | ConvertTo-html -Body "<H2> Port to Process Mapping </H2>" >> $OutLevel1
		
			function Get-NetworkStatistics # Credit to Shay Levy for this function http://blogs.microsoft.co.il/blogs/scriptfanatic/archive/2011/02/10/How-to-find-running-processes-and-their-port-number.aspx
					{ 
						$properties = 'Protocol','LocalAddress','LocalPort' 
						$properties += 'RemoteAddress','RemotePort','State','ProcessName','PID' 

						netstat -ano | Select-String -Pattern '\s+(TCP|UDP)' | ForEach-Object { 

							$item = $_.line.split(" ",[System.StringSplitOptions]::RemoveEmptyEntries) 

							if($item[1] -notmatch '^\[::') 
							{            
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

								New-Object PSObject -Property @{ 
									PID = $item[-1] 
									ProcessName = (Get-Process -Id $item[-1] -ErrorAction SilentlyContinue).Name 
									Protocol = $item[0] 
									LocalAddress = $localAddress 
									LocalPort = $localPort 
									RemoteAddress =$remoteAddress 
									RemotePort = $remotePort 
									State = if($item[0] -eq 'tcp') {$item[3]} else {$null} 
								} | Select-Object -Property $properties 
							} 
						} 
					}

		Get-NetworkStatistics | Format-Table | Out-File $dest\network\network_9_port-to-process-mapping-csv.txt

## ----------------------------------------------------------------------------------------------------------------------------------------		
##	LOGGED ON USER INFORMATION
## ----------------------------------------------------------------------------------------------------------------------------------------	

		#Locally/Remotely Logged on Users - Malware Forensics page 24 or WFA page 17
		
			date | select DateTime | ConvertTo-html -Body "<H2> Logged On Users </H2>" >> $OutLevel1
		
			function get-loggedonuser ($target){ 
					 
					#mjolinor 3/17/10 http://gallery.technet.microsoft.com/scriptcenter/0e43993a-895a-4afe-a2b2-045a5146048a
					 
					$regexa = '.+Domain="(.+)",Name="(.+)"$' 
					$regexd = '.+LogonId="(\d+)"$' 
					 
					$logontype = @{ 
					"0"="Local System" 
					"2"="Interactive" #(Local logon) 
					"3"="Network" # (Remote logon) 
					"4"="Batch" # (Scheduled task) 
					"5"="Service" # (Service account logon) 
					"7"="Unlock" #(Screen saver) 
					"8"="NetworkCleartext" # (Cleartext network logon) 
					"9"="NewCredentials" #(RunAs using alternate credentials) 
					"10"="RemoteInteractive" #(RDP\TS\RemoteAssistance) 
					"11"="CachedInteractive" #(Local w\cached credentials) 
					} 
					 
					$logon_sessions = @(gwmi win32_logonsession -ComputerName $target) 
					$logon_users = @(gwmi win32_loggedonuser -ComputerName $target) 
					 
					$session_user = @{} 
					 
					$logon_users |% { 
					$_.antecedent -match $regexa > $nul 
					$username = $matches[1] + "\" + $matches[2] 
					$_.dependent -match $regexd > $nul 
					$session = $matches[1] 
					$session_user[$session] += $username 
					} 
					 
					 
					$logon_sessions |%{ 
					$starttime = [management.managementdatetimeconverter]::todatetime($_.starttime) 
					 
					$loggedonuser = New-Object -TypeName psobject 
					$loggedonuser | Add-Member -MemberType NoteProperty -Name "Session" -Value $_.logonid 
					$loggedonuser | Add-Member -MemberType NoteProperty -Name "User" -Value $session_user[$_.logonid] 
					$loggedonuser | Add-Member -MemberType NoteProperty -Name "Type" -Value $logontype[$_.logontype.tostring()] 
					$loggedonuser | Add-Member -MemberType NoteProperty -Name "Auth" -Value $_.authenticationpackage 
					$loggedonuser | Add-Member -MemberType NoteProperty -Name "StartTime" -Value $starttime 
					 
					$loggedonuser 
					} 
					 
					}

					Get-loggedonuser ($target) | Out-file $dest\users\UserInfo_1_locally-remotely-logged-on-users.txt
					
		#Remote Users IP Addresses - WFA page 17
		date | select DateTime | ConvertTo-html -Body "<H2> Remote Users IP Addresses </H2>" >> $OutLevel1
		net.exe sessions > $dest\users\UserInfo_2_remote-users-ip-addresses.txt
				
		#Active Logon Sessions - Malware Forensics page 25 or WFA page 18
		date | select DateTime | ConvertTo-html -Body "<H2> Active Logon Sessions </H2>" >> $OutLevel1
		Get-LoggedOnUser $target | Out-File $dest\users\UserInfo_3_active-logon-sessions.txt 

## ----------------------------------------------------------------------------------------------------------------------------------------		
	#OPENED FILES INFORMATION
## ----------------------------------------------------------------------------------------------------------------------------------------
	
		#Open Files on the Computer  #NOT WORKING Due to Architecture - Malware Forensics page 25 or WFA page 18
		#date | select DateTime | ConvertTo-html -Body "<H2> Open files </H2>" >> $OutLevel1
		#$command = '$tools\openedfilesview.exe /stext $dest\OpenedFilesInfo_1_opened-files.txt'
		#iex "& $command"
				
		#Remotely Opened Files - Malware Forensics page 59 or WFA page 19
		date | select DateTime | ConvertTo-html -Body "<H2> Remotely Opened Files </H2>" >> $OutLevel1
		openfiles.exe /query | Out-file $dest\OpenedFilesInfo_2_remotely-opened-files.txt		

##  MISC INFORMATION	
## ----------------------------------------------------------------------------------------------------------------------------------------
		
		#Clipboard Contents - Malware Forensics page 63 and WFA page 37
		date | select DateTime | ConvertTo-html -Body "<H2> Clipboard Contents </H2>" >> $OutLevel1
		$text = & {powershell -sta {add-type -a system.windows.forms; [windows.forms.clipboard]::GetText()}} | Out-file $dest\MiscInfo_1_clipboard-contents.txt
		
##  SYSTEM INFORMATION
## ----------------------------------------------------------------------------------------------------------------------------------------

		Write-Host -Fore Green "Pulling system information...."
	
		date | select DateTime | ConvertTo-html -Body "<H2> Start System Information </H2>" >> $OutLevel1
		#Operating System Version Done when version captured at start
					
		#System Uptime  - Malware Forensics page 21
		date | select DateTime | ConvertTo-html -Body "<H2> System Uptime </H2>" >> $OutLevel1
		SystemUpTime | Out-file $dest\System_2_system-uptime.txt
		SystemUpTime | ConvertTo-html -Body "Results" >> $OutLevel1
		
		#Network Configuration - Malware Forensics page 19 and WFA page 34
		date | select DateTime | ConvertTo-html -Body "<H2> Network Configuration </H2>" >> $OutLevel1
		ipconfig.exe /all > $dest\SystemInfo_3_network-configuration.txt
				
		#Enabled Network Protocols - Malware Forensics page 20
		#date | select DateTime | ConvertTo-html -Body "<H2> Network Protocols </H2>" >> $OutLevel1
		#$command = '$tools\urlprotocolview.exe /stext $dest\SystemInfo_4_enabled-network-protocols.txt'
		#iex "& $command"
		
		#Enabled Network Protocols - Malware Forensics page 20
		#$command = '$tools\urlprotocolview.exe /stab $dest\SystemInfo_4_enabled-network-protocols_tab.csv'
		#iex "& $command"
				
		#Network Adapters in Promiscuous mode - Malware Forensics page 19 and WFA page 35
		#date | select DateTime | ConvertTo-html -Body "<H2> Promiscuous Adapters </H2>" >> $OutLevel1
		#$command = '$tools\promiscdetect.exe >> $dest\SystemInfo_5_promiscuous-adapters.txt'
		#iex "& $command"
				
		#MISC SYSTEM INFO 
		Get-WMIObject Win32_LogicalDisk -ComputerName $target | Select DeviceID,DriveType,@{l="Drive Size";e={$_.Size / 1GB -join ""}},@{l="Free Space";e={$_.FreeSpace / 1GB -join ""}} | Export-CSV $dest\diskInfo.csv -NoTypeInformation | Out-Null
		Get-WMIObject Win32_ComputerSystem -ComputerName $target | Select Name,UserName,Domain,Manufacturer,Model,PCSystemType | Export-CSV $dest\systemInfo.csv -NoTypeInformation | Out-Null
		Get-WmiObject Win32_UserProfile -ComputerName $target | select Localpath,SID,LastUseTime | Export-CSV $dest\users\users.csv -NoTypeInformation | Out-Null
		
		Write-Host -Fore Green "Volatile Data Collection Complete...."
		date | select DateTime | ConvertTo-html -Body "<H2> Volatile Data Collection Complete </H2>" >> $OutLevel1

	}	