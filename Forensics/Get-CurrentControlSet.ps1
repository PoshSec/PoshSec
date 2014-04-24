Function Get-CurrentControlSet {

	Get-ItemProperty HKLM:\system\select\ -Name "Current"
	
	}
	