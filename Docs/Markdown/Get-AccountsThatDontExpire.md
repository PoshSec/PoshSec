---
external help file: PoshSec-help.xml
Module Name: PoshSec
online version:
schema: 2.0.0
---

# Get-AccountsThatDontExpire

## SYNOPSIS
Gets a list of the accounts that don't expire.

## SYNTAX

```
Get-AccountsThatDontExpire [[-SizeLimit] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Gets a list of the accounts from the active directory domain that don't expire.

## EXAMPLES

### EXAMPLE 1
```
Get-AccountThatDontExpire
```

DisplayName     SamAccountName      DistinguishedName
    ----------      -------------       -----------------'
    TestAccount     TestAccount         cn=TestAccount,OU=PoshSec,DC=PoshSec,DC=Com
    Bob Uncle       Bob.Uncle           cn=Bob Uncle,OU=PoshSec,DC=PoshSec,DC=Com

## PARAMETERS

### -SizeLimit
Number of objects to return in results.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 3000
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Part of the PoshSec PowerShell Module

## RELATED LINKS
