

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

[OutputType([string])]
param(
[parameter(Mandatory=$true,HelpMessage='Please enter file type')]
[String] $file
)
$result = 'Error.'
if (Test-Path -Path $file) {

[Byte[]] $header = Get-Content -Encoding Byte -Path $file -TotalCount 8

foreach($byte in $header){
$a= [Convert]::ToString($byte,16).PadLeft(2,'0')
 $hex += $a
}

switch -regex ($hex){

'^4d5a'{$result = ('{0} is an EXE' -f $file)}
'^504b0304'{$result = ('{0} is a ZIP' -f $file)}
'^89504e47'{$result = ('{0} is a PNG' -f $file)}
'^ffd8ffe0'{$result = ('{0} is a JPG' -f $file)}
'^47494638'{$result = ('{0} is a GIF' -f $file)}
'^7f454c46'{$result = ('{0} is an ELF Binary' -f $file)}

default {$result = ('File type unknown for {0}' -f $file)}

}

}

return $result
}


