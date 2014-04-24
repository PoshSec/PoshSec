Function Get-RegistryHives {

##Pulls all Registry Hives
param(
		[Parameter(Mandatory=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
		[string]$target=$global:PoshSecEvidenceTarget 
		)	
	$target = $global:PoshSecEvidenceTarget
	$dest = $global:PoshSecEvidencePath

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

	New-Item -Path $dest -ItemType Directory
	New-Item -Path $dest\reg -ItemType Directory | Out-Null


	#COLLECT REGISTRY FILES  
## ----------------------------------------------------------------------------------------------------------------------------------------
	
		Write-Host -Fore Green "Pulling registry files...."
		
		$regLoc = "c:\windows\system32\config\"
		
		If ($OSArch -eq "64")
				{
				$command = '$tools\RawCopy64.exe $regLoc\SOFTWARE $dest\reg'
				iex "& $command"
								
				$command = '$tools\RawCopy64.exe $regLoc\SYSTEM $dest\reg'
				iex "& $command"
								
				$command = '$tools\RawCopy64.exe $regLoc\SAM $dest\reg'
				iex "& $command"
								
				$command = '$tools\RawCopy64.exe $regLoc\SECURITY $dest\reg'
				iex "& $command"
								
				}
		Else
		{
				$command = '$tools\RawCopy.exe $regLoc\SOFTWARE $dest\reg'
				iex "& $command"
								
				$command = '$tools\RawCopy.exe $regLoc\SYSTEM $dest\reg'
				iex "& $command"
								
				$command = '$tools\RawCopy.exe $regLoc\SAM $dest\reg'
				iex "& $command"
								
				$command = '$tools\RawCopy.exe $regLoc\SECURITY $dest\reg'
				iex "& $command"
		}
		If ($Version -lt '5.4')
		{
		New-Item -Path $dest\reg\regback -ItemType Directory
				If ($OSArch -eq "64")
		{
					$command = '$tools\RawCopy64.exe $regLoc\RegBack\SOFTWARE $dest\reg\regback'
					iex "& $command"
					
					$command = '$tools\RawCopy64.exe $regLoc\RegBack\SAM $dest\reg\regback'
					iex "& $command"
					
					$command = '$tools\RawCopy64.exe $regLoc\RegBack\SECURITY $dest\reg\regback'
					iex "& $command"
					
					$command = '$tools\RawCopy64.exe $regLoc\RegBack\SYSTEM $dest\reg\regback'
					iex "& $command"
					
					$command = '$tools\RawCopy64.exe $regLoc\RegBack\DEFAULT $dest\reg\regback'
					iex "& $command"
										
		}
				Else
		{
					$command = '$tools\RawCopy.exe $regLoc\RegBack\SOFTWARE $dest\reg\regback'
					iex "& $command"
					
					$command = '$tools\RawCopy.exe $regLoc\RegBack\SYSTEM $dest\reg\regback'
					iex "& $command"
					
					$command = '$tools\RawCopy.exe $regLoc\RegBack\SAM $dest\reg\regback'
					iex "& $command"
					
					$command = '$tools\RawCopy.exe $regLoc\RegBack\SECURITY $dest\reg\regback'
					iex "& $command"
					
					$command = '$tools\RawCopy.exe $regLoc\RegBack\DEFAULT $dest\reg\regback'
					iex "& $command"
		}
		
		}
				
		Write-Host "  Done..."
		}