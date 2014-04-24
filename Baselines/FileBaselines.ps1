
function Set-SECFileStore{
<#
.SYNOPSIS
Creates a table of selected files and records hash values, file owner, and file permissions.  

.DESCRIPTION
Creates a table of selected files and records hash values, file owner, and file permissions, saved as an xml file.
Used in concert with Get-SECFileStore to monitor critical files for any unapproved changes.

.PARAMETER path
File(s) to be added and/or updated.  Can be a single file or a directory, in which case all files in the folder will be added or updated.

.PARAMETER xmlpath
Location to write xml to.  Defaults to ./PoshsecFiles.xml

.EXAMPLE

Set-SECFileStore C:\myImportantStuff\

Adds all files in C:\myImportantStuff to the table and saves xml to the default location.

.LINK

PoshSec: https://github.com/PoshSec/PoshSec

#>

param(
[parameter(Mandatory=$true)]
[String] $path,
[parameter(Mandatory=$true)]
[String] $xmlpath = "./PoshsecFiles.xml" 
)
if (Test-path $xmlpath ){
$SECtable = Import-Clixml $xmlpath
}
else{
$SECtable = @()
}

$newrecord = $TRUE

if (Test-Path $path -pathtype Container){

Get-ChildItem $path | ForEach-Object{

  foreach($row in $SECtable){
  Write-Host $row[0]
  if ($row[0] -eq $_.fullname){
  $row[1] = (Get-SEChash $_.fullname)
  $row[2] = (Get-Acl $_.fullname).Owner
  $row[3] = (Get-Acl $_.fullname).sddl  
  $newrecord = $false
  }
}
 if ($newrecord){
  $SECtable += ,@($_.fullname, (Get-SEChash $_.fullname),(Get-Acl $_.fullname).Owner,(Get-Acl $_.fullname).sddl  )
  }


}

}
elseif (Test-Path $path -PathType Leaf){

$file = Get-ChildItem $path

 foreach($row in $SECtable){
  if ($row[0] -eq $file.fullname){
  $row[1] =  (Get-SEChash $file)
  $row[2] = (Get-Acl $file).Owner
  $row[3] = (Get-Acl $file).sddl  
  $newrecord = $false
  }
}
 if ($newrecord){
  $SECtable += ,@($file.fullname, (Get-SEChash $file),(Get-Acl $file).Owner,(Get-Acl $file).sddl  )
  }
}
else {
 Write-Error "Invalid Parameter: $path" -ErrorAction Stop
}


Export-Clixml -path $xmlpath  -InputObject $SECtable

}



function Get-SECFileStore{
<#
.SYNOPSIS
Checks all files in the table for modifications. 

.DESCRIPTION
Retrieves a table previously created through Set-SECFileStore.
Compares the current state of the critical files for any unapproved changes.

.PARAMETER xmlpath
Location of the file table.  Defaults to ./PoshsecFiles.xml

.EXAMPLE

Get-SECFileStore 

Checks all files in the table saved at the default location

.LINK

PoshSec: https://github.com/PoshSec/PoshSec

#>

param(
[parameter(Mandatory=$true)]
[String]$xmlpath = "./PoshsecFiles.xml"
)
if (Test-Path $xmlpath){
$xmltable = Import-clixml $xmlpath

foreach($row in $xmltable){
$file = $row[0]
$hash = $row[1]
$owner = $row[2]
$sddl = $row[3]

if (Test-Path $file){


if ((Get-SECHash $file) -ne $hash){
Write-Error "$file - WRONG HASH"
}

if (((Get-Acl $file).Owner) -ne $owner ){
Write-Error "$file - WRONG OWNER"
}

if (((Get-Acl $file).sddl) -ne $sddl ){
Write-Error "$file - WRONG SDDL"
}
}
else{
Write-Error "$file not found. May have been deleted, renamed, or moved."

}



}

}
else{
Write-Error "No file found at $xmlpath"

}
}



