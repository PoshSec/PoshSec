function Get-UserInfo {

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
		$artFolder = $date + $target + "Users"
		$dest = "$global:PoshSecEvidencePath\$artFolder"
		New-Item -Path $dest -ItemType Directory
		
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



## ----------------------------------------------------------------------------------------------------------------------------------------
## Perform Operations on user files 
## ----------------------------------------------------------------------------------------------------------------------------------------

		Write-Host -Fore Green "Pulling NTUSER.DAT files...."
		date | select DateTime | ConvertTo-html -Body "<H2> NTUSER.DAT Files Pulled </H2>" >> $OutLevel1
		
		$localprofiles = Get-WMIObject Win32_UserProfile -filter "Special != 'true'" -ComputerName $target | Where {$_.LocalPath -and ($_.ConvertToDateTime($_.LastUseTime)) -gt (get-date).AddDays(-15) }
		foreach ($localprofile in $localprofiles){
			$temppath = $localprofile.localpath
			$source = $temppath + "\ntuser.dat"
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
	
	
## User Information  - Only pulls Users that have logged in within the last 15 days
## ----------------------------------------------------------------------------------------------------------------------------------------

Write-Host -Fore Green "Writing User info to file...."
date | select DateTime | ConvertTo-html -Body "<H2> User Info </H2>" >> $OutLevel1

$VERSION = (gwmi win32_OperatingSystem).Version
	$localprofiles = Get-WMIObject Win32_UserProfile -filter "Special != 'true'" -ComputerName $target | Where {$_.LocalPath -and ($_.ConvertToDateTime($_.LastUseTime)) -gt (get-date).AddDays(-15) }  #Can modify for number of days or all users
		foreach ($localprofile in $localprofiles)
		{
			$temppath = $localprofile.localpath
			$eof = $temppath.Length
			$last = $temppath.LastIndexOf('\')
			$count = $eof - $last
			$user = $temppath.Substring($last,$count)
						
			#create user data folders
			
			$UserData = "$dest\users\$user"
			$dirList = ("$UserData\Recent","$UserData\Office_Recent","$UserData\Network_Recent","$UserData\temp","$UserData\Temporary_Internet_Files","$UserData\PrivacIE","$UserData\Cookies","$UserData\Java_Cache")
			New-Item -Path $dirList -ItemType Directory | Out-Null
			
		#Collecting Recent Folder
		If ($Version -lt "5.4")
			{
			$userpath = "C:\Documents and Settings"
			$command = '$global:PoshSecToolsPath\robocopy.exe $userpath\$user\Recent $UserData\Recent /ZB /copy:DAT /r:0 /ts /FP /np /E /log:$dest\users\$user\robocopy-log_recent.txt'
			iex "& $command"
			}
		Else 
			{
			$userpath = "C:\Users"
			$command = '$global:PoshSecToolsPath\robocopy.exe $userpath\$user\AppData\Roaming\Microsoft\Windows\Recent $UserData\Recent /ZB /copy:DAT /r:0 /ts /FP /np /E /log:$dest\users\$user\robocopy-log_recent.txt'
			iex "& $command"
			}
		
		# Collecting Office Recent Folder 
		If ($Version -lt "5.4") 
			{
			$userpath = "C:\Documents and Settings"
			$command = '$global:PoshSecToolsPath\robocopy.exe "$userpath\$user\Application Data\Microsoft\Office\Recent" $UserData\Recent /ZB /copy:DAT /r:0 /ts /FP /np /E /log:$dest\users\$user\robocopy-log_office-recent.txt'
			iex "& $command"
			}
		Else 
			{
			$userpath = "C:\Users"
			$command = '$global:PoshSecToolsPath\robocopy.exe $userpath\$user\AppData\Roaming\Microsoft\Office\Recent $UserData\Office_Recent /ZB /copy:DAT /r:0 /ts /FP /np /E /log:$dest\users\$user\robocopy-log_office-recent.txt'
			iex "& $command"
			}
		
		# Collecting Network Shares Recent Folder 
		If ($Version -lt "5.4") 
			{
			$userpath = "C:\Documents and Settings"
			$command = '$global:PoshSecToolsPath\robocopy.exe $userpath\$user\Nethood $UserData\Network_Recent /ZB /copy:DAT /r:0 /ts /FP /np /E /log:$dest\users\$user\robocopy-log_network-recent.txt'
			iex "& $command"
			}
		Else 
			{
			$userpath = "C:\Users"
			$command = '$global:PoshSecToolsPath\robocopy.exe "$userpath\$user\AppData\Roaming\Microsoft\Windows\Network Shortcuts" $UserData\Network_Recent /ZB /copy:DAT /r:0 /ts /FP /np /E /log:$dest\users\$user\robocopy-log_network-recent.txt'
			iex "& $command"
			}
		
		# Collecting Temporary Folder 
		If ($Version -lt "5.4") 
			{
			$userpath = "C:\Documents and Settings"
			$command = '$global:PoshSecToolsPath\robocopy.exe "$userpath\$user\Local Settings\Temp" $UserData\temp /ZB /copy:DAT /r:0 /ts /FP /np /E /log:$dest\users\$user\robocopy-log_temp.txt'
			iex "& $command"
			}
		Else 
			{
			$userpath = "C:\Users"
			$command = '$global:PoshSecToolsPath\robocopy.exe $userpath\$user\AppData\Local\Temp $UserData\temp /ZB /copy:DAT /r:0 /ts /FP /np /E /log:$dest\users\$user\robocopy-log_temp.txt'
			iex "& $command"
			}
		
		# Collecting Temporary Internet Files Folder 
			If ($Version -lt "5.4") 
			{
			$userpath = "C:\Documents and Settings"
			$command = '$global:PoshSecToolsPath\robocopy.exe "$userpath\$user\Local Settings\Temporary Internet Files" $UserData\Temporary_Internet_Files /ZB /copy:DAT /r:0 /ts /FP /np /E /log:$dest\users\$user\robocopy-log_tif.txt'
			iex "& $command"
			
			}
		Else 
			{
			$userpath = "C:\Users"
			$command = '$global:PoshSecToolsPath\robocopy.exe "$userpath\$user\AppData\Local\Microsoft\Windows\Temporary Internet Files" $UserData\Temporary_Internet_Files /ZB /copy:DAT /r:0 /ts /FP /np /E /log:$dest\users\$user\robocopy-log_tif.txt'
			iex "& $command"		
			}
					
		# Collecting the PrivacIE folder 
			If ($Version -lt "5.4") 
			{
			$userpath = "C:\Documents and Settings"
			$command = "$global:PoshSecToolsPath\robocopy.exe $userpath\$user\PrivacIE $UserData\PrivacIE /ZB /copy:DAT /r:0 /ts /FP /np /E /log:$dest\users\$user\robocopy-log_privacie.txt"
			iex "& $command"	
			}
		Else 
			{
			$userpath = "C:\Users"
			$command = "$global:PoshSecToolsPath\robocopy.exe $userpath\$user\AppData\Roaming\Microsoft\Windows\PrivacIE $UserData\PrivacIE /ZB /copy:DAT /r:0 /ts /FP /np /E /log:$dest\users\$user\robocopy-log_privacie.txt"
			iex "& $command"	
			}
		
		# Collecting the Cookies 
			If ($Version -lt "5.4") 
			{
			$userpath = "C:\Documents and Settings"
			$command = "$global:PoshSecToolsPath\robocopy.exe $userpath\$user\Cookies $UserData\Cookies /ZB /copy:DAT /r:0 /ts /FP /np /E /log:$dest\users\$user\robocopy-log_cookies.txt"
			iex "& $command"
			}
		Else 
			{
			$userpath = "C:\Users"
			$command = "$global:PoshSecToolsPath\robocopy.exe $userpath\$user\AppData\Roaming\Microsoft\Windows\Cookies $UserData\Cookies /ZB /copy:DAT /r:0 /ts /FP /np /E /log:$dest\users\$user\robocopy-log_cookies.txt"
			iex "& $command"
			}
		
		# Collecting the Java Cache folder
		If ($Version -lt "5.4") 
			{
			$userpath = "C:\Documents and Settings"
			$command = "$global:PoshSecToolsPath\robocopy.exe $userpath\$user\Application'Data\Sun\Java\Deployment\cache $UserData\Java_Cache /ZB /copy:DAT /r:0 /ts /FP /np /E /log:$dest\users\$user\robocopy-log_java.txt"
			iex "& $command"
			}
		Else 
			{
			$userpath = "C:\Users"
			$command = "$global:PoshSecToolsPath\robocopy.exe $userpath\$user\AppData\LocalLow\Sun\Java\Deployment\cache $UserData\Java_Cache /ZB /copy:DAT /r:0 /ts /FP /np /E /log:$dest\users\$user\robocopy-log_java.txt"
			iex "& $command"
			}
		}		
}		
