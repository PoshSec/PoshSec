

function Get-Filetype{
<#
.SYNOPSIS
Takes an unknown file input and tries to determine what kind of file it is by inspecting the first 8 bytes
.DESCRIPTION
Compares the first 8 bytes of a file to a switch statement to determine file type.  Easily customizable to add new file headers (magic numbers) 

.PARAMETER File
The path to the file.
.EXAMPLE
PS C:\> Get-Filetype mysteryfile.???
.INPUTS
System.String
.OUTPUTS
String
.NOTES
AUTHOR: Rich Cassara
This is a part of the PoshSec Utility-Functions module.
.LINK
www.poshsec.com
.LINK
github.com/poshsec
#>


[CmdletBinding()]
param(
[parameter(Mandatory=$true)]
[String] $file
)

if (Test-Path $file) {

[Byte[]] $header = Get-Content -Encoding Byte -Path $file -TotalCount 8

foreach($byte in $header){
$a= [Convert]::ToString($byte,16).PadLeft(2,'0')
 $hex += $a
}

#Write-Host $hex
#Write-Host $hex.length

switch -regex ($hex){

'^4d5a'{$result = "$file is an EXE"}
'^504b0304'{$result = "$file is a ZIP"}
'^89504e47'{$result = "$file is a PNG"}
'^ffd8ffe0'{$result = "$file is a JPG"}
'^47494638'{$result = "$file is a GIF"}
'^7f454c46'{$result = "$file is an ELF Binary}

default {"File type unknown for $file"}

}
Write-Host $result
}


}


