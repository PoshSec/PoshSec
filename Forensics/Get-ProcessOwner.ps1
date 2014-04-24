#requires -version 2.0

<#
 -----------------------------------------------------------------------------
 Script: Get-ProcessOwner.ps1
 Version: 2.0
 Author: Jeffery Hicks
    http://jdhitsolutions.com/blog
    http://twitter.com/JeffHicks
    http://www.ScriptingGeek.com
 Date: 8/22/2011
 Keywords: WMI, Process
 Comments:

 "Those who forget to script are doomed to repeat their work."

  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************
 -----------------------------------------------------------------------------
 #>
 
Function Get-ProcessOwner {

<#
.SYNOPSIS
Get a process owner using WMI.
.DESCRIPTION
Using WMI, get the owner of a Win32_Process object. Typically you will pipe a Get-WMIObject 
expression to this function. On the back side you will need to explicitly select the Owner 
property. This function also adds a property called Computername that renames the CSNAME 
property.
.PARAMETER Inputobject
A Win32_Process object
.EXAMPLE
PS C:\> get-wmiobject win32_Process -computer SERVER01 | get-processowner | Select name,handle,owner,computername

.NOTES
NAME        :  Get-ProcessOwner
VERSION     :  2.0   
LAST UPDATED:  8/25/2011
AUTHOR      :  Jeffery Hicks
.LINK
http://jdhitsolutions.com/blog/2011/08/get-process-owner/
.LINK
Get-WMIObject 
Add-Member 
.INPUTS
Win32_Process
.OUTPUTS
customized Win32_Process
#>

[cmdletbinding()]

Param(
[Parameter(Position=0,ValuefromPipeline=$True)]
[ValidateScript({$_.__CLASS -eq "Win32_Process"})]
[System.Management.ManagementObject]$Inputobject
)

Begin {
    Write-Verbose "Starting $($myinvocation.mycommand)"
}

Process {
 Try {
    Write-Verbose ("Process ID {0} {1}" -f $_.processID,$_.name)
    $owner=$_.GetOwner()
    if ($owner.user) {
        #did we get a value back?
        $ownername="{0}\{1}" -f $owner.Domain, $owner.User
        Write-Verbose ("Adding owner {0}" -f $ownername)
    }
    else {
        $ownername=$null
    }
 }
 Catch {
 write-warning "oops"
    Write-Warning ("Failed to get an owner for process ID {0} {1}" -f $_.ProcessID,$_.name)
    $ownername=$NULL
 }
 Finally {
    $_ | Add-Member -MemberType "Noteproperty" -name "Computername" -value $_.CSName
    $_ | Add-Member -MemberType "Noteproperty" -name "Owner" -value $ownername -passthru
 }
}

End {
    Write-Verbose "Ending $($myinvocation.mycommand)"
}

} #end function

#set an optional alias
#Set-Alias -Name gpo -Value Get-ProcessOwner