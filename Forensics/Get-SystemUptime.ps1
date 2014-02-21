#############################################################################
# Get-Uptime.ps1
# This script will report uptime of given computer since last reboot.
# 
# Pre-Requisites: Requires PowerShell 2.0 and WMI access to target computers (admin access).
#
# Usage syntax:
# For local computer where script is being run: .\Get-Uptime.ps1.
# For list of remote computers: .\Get-Uptime.ps1 -ComputerList "c:\temp\computerlist.txt"
#
# Usage Examples:
#
# .\Get-Uptime.ps1 -Computer ComputerName
# .\Get-Uptime.ps1 -ComputerList "c:\temp\computerlist.txt" | Export-Csv uptime-report.csv -NoTypeInformation
#
# Last Modified: 3/20/2012
#
# Created by 
# Bhargav Shukla
# http://blogs.technet.com/bshukla
# http://www.bhargavs.com
# 
# DISCLAIMER
# ==========
# THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE 
# RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#############################################################################
#Requires -Version 2.0
Function Get-SystemUpTime{
param
(
 [Parameter(Position=0,ValuefromPipeline=$true)][string][alias("cn")]$computer,
    [Parameter(Position=1,ValuefromPipeline=$false)][string]$computerlist
)

If (-not ($computer -or $computerlist))
{
    $computers = $Env:COMPUTERNAME
}
 
If ($computer)
{
    $computers = $computer
}
 
If ($computerlist)
{
    $computers = Get-Content $computerlist
}

foreach ($computer in $computers) 
{
    $Computerobj = "" | select ComputerName, Uptime, LastReboot
    $wmi = Get-WmiObject -ComputerName $computer -Query "SELECT LastBootUpTime FROM Win32_OperatingSystem"
    $now = Get-Date
    $boottime = $wmi.ConvertToDateTime($wmi.LastBootUpTime)
    $uptime = $now - $boottime
    $d =$uptime.days
    $h =$uptime.hours
    $m =$uptime.Minutes
    $s = $uptime.Seconds
    $Computerobj.ComputerName = $computer
    $Computerobj.Uptime = "$d Days $h Hours $m Min $s Sec"
    $Computerobj.LastReboot = $boottime
    $Computerobj   
}
}
