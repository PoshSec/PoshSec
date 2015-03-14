function Get-Filetype{
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


