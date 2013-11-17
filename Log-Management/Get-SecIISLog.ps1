<#
.Synopsis
  Utility function which parses IIS log records into an object form and outputs to the pipeline.  Log information can then be easily accessed by other functions as necessary.

.PARAMETER Date
  The date of the log file to parse.  Defaults to the current day

.PARAMETER Path
  Path to the IIS log files.  Default is C:\inetpub\logs\LogFiles\W3SVC1\
  
.PARAMETER Filter
  A string to search for to limit the log files returned

.PARAMETER Limit
  An integer value to indicate how many records to return from the log file.  Default is the most recent 100.

.EXAMPLE
  To show visits from 127.0.0.1 in the last 1000 records from the current day's log:
  Get-SecIISLog -limit 1000 | Where-Object ($_.cIP -eq "127.0.0.1"}

#>

function Get-SecIISLog{
param(
[datetime]$date = (Get-date),
$path = "C:\inetpub\logs\LogFiles\W3SVC1\",
[string]$filter = "",
[Int]$limit = 100
)


$logform = "u_ex" + (Get-date $date.ToUniversalTime() + ".log"

$logs = @()

try 
{
Get-Content ("$path" + "$logform") -tail $limit | ForEach-Object {
if($filter){
if($_.ToString().Contains($filter)){
[string[]]$fields = $_.ToString().Split(' ')

$iislog = New-Object PSObject

$iislog | Add-Member -membertype NoteProperty -Name "LogDate" -Value ($fields[0] + ' ' + $fields[1]) 
$iislog | Add-Member -membertype NoteProperty -Name "URL" -Value $fields[4]
$iislog | Add-Member -membertype NoteProperty -Name "sIP" -Value $fields[2]
$iislog | Add-Member -membertype NoteProperty -Name "Verb" -Value $fields[3]
$iislog | Add-Member -membertype NoteProperty -Name "Port" -Value $fields[6]
$iislog | Add-Member -membertype NoteProperty -Name "cIP" -Value $fields[8]
$iislog | Add-Member -membertype NoteProperty -Name "Agent" -Value $fields[9]
$iislog | Add-Member -membertype NoteProperty -Name "Status" -Value $fields[10]
$logs += $iislog
}
}

else{
  [string[]]$fields = $_.ToString().Split(' ')

$iislog = New-Object PSObject

$iislog | Add-Member -membertype NoteProperty -Name "LogDate" -Value ($fields[0] + ' ' + $fields[1]) 
$iislog | Add-Member -membertype NoteProperty -Name "URL" -Value $fields[4]
$iislog | Add-Member -membertype NoteProperty -Name "sIP" -Value $fields[2]
$iislog | Add-Member -membertype NoteProperty -Name "Verb" -Value $fields[3]
$iislog | Add-Member -membertype NoteProperty -Name "Port" -Value $fields[6]
$iislog | Add-Member -membertype NoteProperty -Name "cIP" -Value $fields[8]
$iislog | Add-Member -membertype NoteProperty -Name "Agent" -Value $fields[9]
$iislog | Add-Member -membertype NoteProperty -Name "Status" -Value $fields[10]
$logs += $iislog
}
}
}
catch [System.Exception]
{
  Write-Error $_.Exception.toString()
}



Write-Output $logs
}



