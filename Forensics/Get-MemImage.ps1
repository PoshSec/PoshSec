function Get-MemImage {

param(
		[Parameter(Mandatory=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
		[string]$target="localhost"
		)	


Write-Host -Fore Green "Creating Memory Image Directory"

New-PSDrive -Name X -PSProvider filesystem -Root \\$target\c$ | Out-Null  

		$date = Get-Date -format yyyy-MM-dd_HHmm_
		$artFolder = $date + $target + "RAM"
		$dest = "$global:PoshSecEvidencePath\$artFolder"

	$dirList = ("$dest\memoryimage")
	New-Item -Path $global:PoshSecEvidencePath -ItemType Directory
	New-Item -Path $dirList -ItemType Directory | Out-Null


Write-Host -Fore Green "Gathering RAM image...."
	
		$command = '$global:PoshSecToolsPath\winpmem.exe $global:PoshSecEvidencePath\memoryimage\memimage.bin'
		iex "& $command"

	Wait-Process -name winpmem.exe
}	