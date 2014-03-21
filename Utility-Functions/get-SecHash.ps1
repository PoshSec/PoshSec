

function Get-SECHash
{
<#  
.SYNOPSIS
    
Generates a hash value for a file. 
    
.DESCRIPTION
    
Creates XML files to upload/compare the current DRS configuration and verify related registry settings on remote servers. 
Optionally report on the status for each server through a HTML formated report. 
    
.PARAMETER Path
File to be hashed

.PARAMETER HashType
Hashing algorithm to be used, default is SHA-1.  Can also be set to SHA-256, SHA-512, or MD5. 
    
.EXAMPLE
 Get-SECHash C:\windows\notepad.exe -hashType SHA256   

Generates a SHA-256 hash of notepad.exe's binary.

.LINK
Poshsec Github  : https://github.com/PoshSec/PoshSec

#>

param(
[parameter(Mandatory=$true)]
[String] $path,

[ValidateSet("SHA1","SHA256","SHA512","MD5")]
[String] $hashType = "SHA1"
)


$hashFactory = [Type] "System.Security.Cryptography.$hashType"
$hasher = $hashFactory::Create()

if(Test-Path $path -PathType Leaf){


$bytes = New-Object IO.StreamReader ((Resolve-Path $path).Path)
$hashed = $hasher.ComputeHash($bytes.BaseStream)
$bytes.Close()

$final = New-Object System.Text.StringBuilder
$hashed | ForEach-Object { [void] $final.Append($_.toString("X2")) }

Write-Output $final.ToString()
}
else{
Write-Error "Invalid File path"
}


}