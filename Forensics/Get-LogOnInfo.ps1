Function Get-LogOnInfo {

Get-WmiObject -class Win32_NetworkLoginProfile | Where {($_.NumberOfLogons -gt 0) -and ($_.NumberOfLogons -lt 65535)} | Select-Object  Name,BadPasswordCount,@{label='LastLogon';expression={$_.ConvertToDateTime($_.LastLogon)}},NumberOfLogons 

}