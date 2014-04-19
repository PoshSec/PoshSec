Function Get-VolatileandNVData {

		param(
					[Parameter(Mandatory=$true,Position=0)]
					[ValidateNotNullOrEmpty()]
					[string]$target=$global:PoshSecEvidenceTarget)

		$global:PoshSecEvidenceTarget = $target
	

		Get-VolatileData
		Get-NonVolatileData
		
	}