function Get-NonVolatileData {

param(
		[Parameter(Mandatory=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
		[string]$target="localhost"
		)

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
## end Region OS architecture detection
## ----------------------------------------------------------------------------------------------------------------------------------------

## Configure Folders for data collection - sets up folders based on computer's name and timestamp of artifact collection
## ----------------------------------------------------------------------------------------------------------------------------------------

	Write-Host -Fore Green "Configuring Folders...."

		New-PSDrive -Name X -PSProvider filesystem -Root \\$target\c$ | Out-Null  

		$date = Get-Date -format yyyy-MM-dd_HHmm_
		$artFolder = $date + $target + "Non-Volatile"
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
	$dirList = ("$dest\autoruns","$dest\logs","$dest\reg","$dest\MBR","$dest\Group_Policy")
	New-Item -Path $dest -ItemType Directory
	New-Item -Path $dirList -ItemType Directory | Out-Null

## Windows OS Version - Malware Forensics page 19
## ----------------------------------------------------------------------------------------------------------------------------------------

		$VERSION = (gwmi win32_OperatingSystem).Version 
		(gwmi win32_OperatingSystem).Version  > $dest\SystemInfo_1_os-version.txt
		
## ----------------------------------------------------------------------------------------------------------------------------------------
## GET BIOS INFO 
## ----------------------------------------------------------------------------------------------------------------------------------------
		
		gwmi win32_BIOS |ft Manufacturer, Name, ReleaseDate, SerialNumber, Version -a > $dest\BIOS-INFO.txt

## HTML File setup 
## ----------------------------------------------------------------------------------------------------------------------------------------## HTML Logfile Header
## ----------------------------------------------------------------------------------------------------------------------------------------
	
	ConvertTo-Html -Head $head -Title "Live Response script for $CompName" -Body " Live Forensics Script <p> Computer Name : $CompName &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp </p> " > $OutLevel1
	
# Record start time of collection
## ----------------------------------------------------------------------------------------------------------------------------------------

	date | select DateTime | ConvertTo-html -Body "Current Date and Time " >> $OutLevel1
	gwmi win32_BIOS | ConvertTo-html -Body "<H2> Bios Info <H2>" >> $OutLevel1
	
## Start Logging
## ----------------------------------------------------------------------------------------------------------------------------------------	

	#BOOT RECORD INFORMATION
## ----------------------------------------------------------------------------------------------------------------------------------------

		#Partition Information 
		date | select DateTime | ConvertTo-html -Body "<H2> Partition Information </H2>" >> $OutLevel1
		$command = '$global:PoshSecToolsPath\mmls.exe \\.\PHYSICALDRIVE0 >> $dest\MBR\partition-info.txt'
		iex "& $command"
				
		#Image the MBR in Sector 0  
		date | select DateTime | ConvertTo-html -Body "<H2> Image MBR in Sector 0 </H2>" >> $OutLevel1
		$command = '$global:PoshSecToolsPath\dd.exe if=\\.\PHYSICALDRIVE0 of=$dest\MBR\mbr.bin bs=512 count=1'
		iex "& $command"
				
		#Imaging the sectors before the first partition 
		
		date | select DateTime | ConvertTo-html -Body "<H2> Image sectors before the first partition </H2>" >> $OutLevel1
		If ($Version -gt '5.3')
			{
			$command = '$global:PoshSecToolsPath\dd.exe if=\\.\PHYSICALDRIVE0 of=$dest\mbr\win7_2008-2048-bytes.bin bs=512 count=2048'
			iex "& $command"
			}
		Else
			{
			$command = '$global:PoshSecToolsPath\dd.exe if=\\.\PHYSICALDRIVE0 of=$dest\mbr\winXP_2003-63-bytes.bin bs=512 count=63'
			iex "& $command"
			}

	#COLLECT REGISTRY FILES  
## ----------------------------------------------------------------------------------------------------------------------------------------
	
		Write-Host -Fore Green "Pulling registry files...."
		date | select DateTime | ConvertTo-html -Body "<H2> Pulling Registry Files </H2>" >> $OutLevel1
		$regLoc = "c:\windows\system32\config\"
		
		If ($OSArch -eq "64")
				{
				$command = '$global:PoshSecToolsPath\RawCopy64.exe $regLoc\SOFTWARE $dest\reg'
				iex "& $command"
								
				$command = '$global:PoshSecToolsPath\RawCopy64.exe $regLoc\SYSTEM $dest\reg'
				iex "& $command"
								
				$command = '$global:PoshSecToolsPath\RawCopy64.exe $regLoc\SAM $dest\reg'
				iex "& $command"
								
				$command = '$global:PoshSecToolsPath\RawCopy64.exe $regLoc\SECURITY $dest\reg'
				iex "& $command"
								
				}
		Else
		{
				$command = '$global:PoshSecToolsPath\RawCopy.exe $regLoc\SOFTWARE $dest\reg'
				iex "& $command"
								
				$command = '$global:PoshSecToolsPath\RawCopy.exe $regLoc\SYSTEM $dest\reg'
				iex "& $command"
								
				$command = '$global:PoshSecToolsPath\RawCopy.exe $regLoc\SAM $dest\reg'
				iex "& $command"
								
				$command = '$global:PoshSecToolsPath\RawCopy.exe $regLoc\SECURITY $dest\reg'
				iex "& $command"
		}
		If ($Version -lt '5.4')
		{
		New-Item -Path $dest\reg\regback -ItemType Directory
				If ($OSArch -eq "64")
		{
					$command = '$global:PoshSecToolsPath\RawCopy64.exe $regLoc\RegBack\SOFTWARE $dest\reg\regback'
					iex "& $command"
					
					$command = '$global:PoshSecToolsPath\RawCopy64.exe $regLoc\RegBack\SAM $dest\reg\regback'
					iex "& $command"
					
					$command = '$global:PoshSecToolsPath\RawCopy64.exe $regLoc\RegBack\SECURITY $dest\reg\regback'
					iex "& $command"
					
					$command = '$global:PoshSecToolsPath\RawCopy64.exe $regLoc\RegBack\SYSTEM $dest\reg\regback'
					iex "& $command"
					
					$command = '$global:PoshSecToolsPath\RawCopy64.exe $regLoc\RegBack\DEFAULT $dest\reg\regback'
					iex "& $command"
										
		}
				Else
		{
					$command = '$global:PoshSecToolsPath\RawCopy.exe $regLoc\RegBack\SOFTWARE $dest\reg\regback'
					iex "& $command"
					
					$command = '$global:PoshSecToolsPath\RawCopy.exe $regLoc\RegBack\SYSTEM $dest\reg\regback'
					iex "& $command"
					
					$command = '$global:PoshSecToolsPath\RawCopy.exe $regLoc\RegBack\SAM $dest\reg\regback'
					iex "& $command"
					
					$command = '$global:PoshSecToolsPath\RawCopy.exe $regLoc\RegBack\SECURITY $dest\reg\regback'
					iex "& $command"
					
					$command = '$global:PoshSecToolsPath\RawCopy.exe $regLoc\RegBack\DEFAULT $dest\reg\regback'
					iex "& $command"
		}
		
		}
				
		Write-Host "  Done..."
		
##  COLLECT EACH USERS REGISTRY FILES
## ----------------------------------------------------------------------------------------------------------------------------------------
		#Set User path variable
		
		If ($Version -lt "5.4")
		{
		$userpath = "C:\Documents and Settings"
		}
		Else
		{
		$userpath = "C:\Users"
		}
		
		If ($Version -gt "5.3")
		{
				Write-Host -Fore Green "Pulling USRCLASS.DAT files...."
				date | select DateTime | ConvertTo-html -Body "<H2> Pulling USRCLASS.DAT files.... </H2>" >> $OutLevel1
				
				$localprofiles = Get-WMIObject Win32_UserProfile -filter "Special != 'true'" -ComputerName $target | Where {$_.LocalPath -and ($_.ConvertToDateTime($_.LastUseTime)) -gt (get-date).AddDays(-15) }
				foreach ($localprofile in $localprofiles){
					$temppath = $localprofile.localpath
					$source = $temppath + "\appData\local\microsoft\windows\usrclass.dat"
					$eof = $temppath.Length
					$last = $temppath.LastIndexOf('\')
					$count = $eof - $last
					$user = $temppath.Substring($last,$count)
					$destination = "$dest\users" + $user
					New-Item -Path $dest\users\$user -ItemType Directory  | Out-Null
					
				If ($OSArch -eq '32')
					{
					$command = '$global:PoshSecToolsPath\RawCopy.exe $source $destination'
					iex "& $command"
					}
				ElseIf ($OSArch -eq '64')
					{
					$command = '$global:PoshSecToolsPath\RawCopy64.exe $source $destination'
					iex "& $command"
				}
				}
		}
##  COLLECTING NTFS ARTIFACTS
## ----------------------------------------------------------------------------------------------------------------------------------------
	
		#Collecting the MFT Record
		Write-Host -Fore Green "Pulling the MFT...."
		date | select DateTime | ConvertTo-html -Body "<H2> Pulling the MFT.... </H2>" >> $OutLevel1
		
		If ($OSArch -eq "64")
			{
			$command = '$global:PoshSecToolsPath\RawCopy64.exe c:0 $dest'
			iex "& $command"
			do {(Write-Host -ForegroundColor Yellow "  waiting for MFT copy to complete..."),(Start-Sleep -Seconds 5)}
			until ((Get-WMIobject -Class Win32_process -Filter "Name='RawCopy64.exe'" -ComputerName $target | where {$_.Name -eq "RawCopy64.exe"}).ProcessID -eq $null)
			}
		Else
			{
			$command = '$global:PoshSecToolsPath\RawCopy.exe c:0 $dest'
			iex "& $command"
			do {(Write-Host -ForegroundColor Yellow "  waiting for MFT copy to complete..."),(Start-Sleep -Seconds 5)}
			until ((Get-WMIobject -Class Win32_process -Filter "Name='RawCopy.exe'" -ComputerName $target | where {$_.Name -eq "RawCopy.exe"}).ProcessID -eq $null)
			}
		Write-Host "  Done..."
	
		#Collect LogFile Records  
		
		date | select DateTime | ConvertTo-html -Body "<H2> Log File Records </H2>" >> $OutLevel1
		If ($OSArch -eq "64")
			{
			$command = '$global:PoshSecToolsPath\RawCopy64.exe c:2 $dest'
			iex "& $command"
			}
		Else
			{
			$command = '$global:PoshSecToolsPath\RawCopy.exe c:2 $dest'
			iex "& $command"
			}
			
##  COLLECTING AUTOSTARTING LOCATIONS  
## ----------------------------------------------------------------------------------------------------------------------------------------
	
		date | select DateTime | ConvertTo-html -Body "<H2> AutoStarting Locations </H2>" >> $OutLevel1
		
		#List system autostart locations - Malware Forensics page 69 or WFA page 44
		$command = '$global:PoshSecToolsPath\autorunsc.exe -a /accepteula >> $dest\autoruns\$target-autostarting-locations.txt'
		iex "& $command"
		

		#List system autostart locations in csv format - Malware Forensics page 69 or WFA page 44
		Get-WMIObject Win32_Service -Computername $target | Select processid,name,state,displayname,pathname,startmode | Export-CSV $dest\autoruns\target-autostarting-locations.csv -NoTypeInformation | Out-Null
			
		#Collect at.exe scheduled task information  
		at.exe > $dest\autoruns\$target-at_info.txt
	
		#Scheduled Task Information 
		$command = 'schtasks.exe /query >> $dest\autoruns\$target-schtasks_info.txt'
		iex "& $command"
				
		#Collect Scheduled Task Log and/or Folder
		If ($Version -lt "5.4") 
		{
			If ($OSArch -eq "64")
				{
				$command = '$global:PoshSecToolsPath\RawCopy64.exe $env:WINDIR\Tasks\SchedLgU.txt $dest\autoruns\'
				iex "& $command"
				}
			Else
				{
				$command = '$global:PoshSecToolsPath\RawCopy.exe $env:WINDIR\SchedLgU.txt $dest\autoruns\'
				iex "& $command"
				}}
		Else  
			{
			$command = '$global:PoshSecToolsPath\robocopy.exe $env:WINDIR\Tasks $dest\autoruns\ /ZB /copy:DAT /r:0 /ts /FP /np /log:$dest\autoruns\tasks-robocopy-log.txt'
			iex "& $command"
			}
		
#List all installed device drivers and their properties 
## ----------------------------------------------------------------------------------------------------------------------------------------

		date | select DateTime | ConvertTo-html -Body "<H2> Installed Drivers </H2>" >> $OutLevel1
		driverquery.exe /fo csv /si >> $dest\autoruns\$target-driverquery_info.txt 
		
##Copy Log Files
## ----------------------------------------------------------------------------------------------------------------------------------------

		Write-Host -Fore Green "Pulling event logs...."
		date | select DateTime | ConvertTo-html -Body "<H2> Event Logs </H2>" >> $OutLevel1
		
		$VERSION = (gwmi win32_OperatingSystem).Version 
		If ($Version -lt "5.4") 
			{
			$logLoc = "x:\System32\config"
			$loglist = @("$logLoc\AppEvent.evt","$logLoc\SecEvent.evt","$logLoc\SysEvent.evt")
			}
		Else
			{
			$logLoc = "x:\windows\system32\Winevt\Logs"
			$loglist = @("$logLoc\application.evtx","$logLoc\security.evtx","$logLoc\system.evtx","$logLoc\Microsoft-Windows-User Profile Service%4Operational.evtx","$logLoc\Microsoft-Windows-TaskScheduler%4Operational.evtx")
			}
		Copy-Item -Path $loglist -Destination $dest\logs\ -Force
		
	## Collect log folders for non-Legacy Windows System 
		If ($Version -gt "5.3")
			{
			$command = '$global:PoshSecToolsPath\robocopy.exe C:\Windows\Logs\ $dest\logs\ /ZB /copy:DAT /r:0 /ts /FP /np /E /log:$dest\logs\logs-robocopy-log.txt'
			iex "& $command"		
			}
		
#Collecting the AV log and quarantine folder - Will need to modify for AV used
## ----------------------------------------------------------------------------------------------------------------------------------------
	
	date | select DateTime | ConvertTo-html -Body "<H2> AV Logs </H2>" >> $OutLevel1
	
	##Copy Microsoft Endpoint Quarantine Files (default location)##
			$QuarQ = "C:\ProgramData\Microsoft\Microsoft Antimalware\Quarantine"
			if (Test-Path -Path "$QuarQ\*.vbn") {
				Write-Host -Fore Green "Pulling Microsoft AV Quarantine files...."
				New-Item -Path $dest\MicrosoftAVQuarantine -ItemType Directory  | Out-Null
				Copy-Item -Path "$QuarQ\*.*" $dest\MicrosoftAVQuarantine -Force -Recurse
			}
			else
				{
				Write-Host -Fore Red "No Microsoft Quarantine files...."
				}

	##Copy Microsoft Endpoint Log Files (default location)##
			$EndLog = "C:\ProgramData\Microsoft\Microsoft Antimalware\Support"
			if (Test-Path -Path "$EndLog\*.log") {
				Write-Host -Fore Green "Pulling Microsoft AV Log files...."
				New-Item -Path $dest\MicrosoftAVLogs -ItemType Directory  | Out-Null
				Copy-Item -Path "$EndLog\*.Log" $dest\MicrosoftAVLogs -Force -Recurse
			}
			else
				{
				Write-Host -Fore Red "No Microsoft Log files...."
				}
		
#Group Policy Information - Malware Forensics page 73  
## ----------------------------------------------------------------------------------------------------------------------------------------
	
	date | select DateTime | ConvertTo-html -Body "<H2> Group Policy Info </H2>" >> $OutLevel1
	gp -ea 0 hklm:\Software\Microsoft\Windows\CurrentVersion\policies\system | select * -ExcludeProperty PS* | ConvertTo-html -Body "<H2> Important Registry keys - UAC Group Policy Settings </H2>" >> $OutLevel1
	$command = '$global:PoshSecToolsPath\gplist.exe > $dest\group_policy\group-policy-listing.txt'
	iex "& $command"
			
#GPResult.exe Results - Malware Forensics page 73
## ----------------------------------------------------------------------------------------------------------------------------------------

	$command = 'gpresult /Z >> $dest\group_policy\$target-group-policy-RSoP.txt'
	iex "& $command"
			
##Copy Internet History files##
## ----------------------------------------------------------------------------------------------------------------------------------------
	
	date | select DateTime | ConvertTo-html -Body "<H2> Internet History Files </H2>" >> $OutLevel1
	
	##	Microsoft Internet Explorer

		Write-Host -Fore Green "Pulling Internet History files...."
		New-Item -Path $dest\users\$user\InternetHistory\IE -ItemType Directory | Out-Null
		$inethist = Get-ChildItem X:\users\$user\AppData\Local\Microsoft\Windows\History -ReCurse -Force | foreach {$_.Fullname}
		foreach ($inet in $inethist) {
			Copy-Item -Path $inet -Destination $dest\users\$user\InternetHistory\IE -Force -Recurse
		}

	##Copy FireFox History files##
		$foxpath = "X:\users\$user\AppData\Roaming\Mozilla\"
		if (Test-Path -Path $foxpath) {
			Write-Host -Fore Green "Pulling FireFox Internet History files...."
			New-Item -Path $dest\users\$user\InternetHistory\Firefox -ItemType Directory  | Out-Null
		$ffinet = Get-ChildItem X:\users\$user\AppData\Roaming\Mozilla\Firefox\Profiles\ -Filter "places.sqlite" -Force -Recurse | foreach {$_.Fullname}
		Foreach ($ffi in $ffinet) {
			Copy-Item -Path $ffi -Destination $remoteIRfold\$artFolder\users\$user\InternetHistory\Firefox
		$ffdown = Get-ChildItem X:\Users\$user\AppData\Roaming\Mozilla\Firefox\Profiles\ -Filter "downloads.sqlite" -Force -Recurse | foreach {$_.Fullname}
		Foreach ($ffd in $ffdown) {
			Copy-Item -Path $ffd -Destination $dest\users\$user\InternetHistory\Firefox
				}
			}
		}
		else
			{
				Write-Host -Fore Red "No FireFox Internet History files...."
			}

	##Copy Chrome History files##
		$chromepath = "X:\users\$user\AppData\Local\Google\Chrome\User Data\Default"
		if (Test-Path -Path $chromepath) 
		{
			Write-Host -Fore Green "Pulling Chrome Internet History files...."
			New-Item -Path $dest\users\$user\InternetHistory\Chrome -ItemType Directory  | Out-Null
			$chromeInet = Get-ChildItem "X:\users\$user\AppData\Local\Google\Chrome\User Data\Default" -Filter "History" -Force -Recurse | foreach {$_.Fullname}
		Foreach ($chrmi in $chromeInet) 
			{
			Copy-Item -Path $chrmi -Destination $dest\users\$user\InternetHistory\Chrome
			}
		}
		else
		{
		Write-Host -Fore Red "No Chrome Internet History files...."
		}
}
		