---
external help file: PoshSec-help.xml
Module Name: PoshSec
online version:
schema: 2.0.0
---

# Get-LockedOutAccount

## SYNOPSIS
Gets current list of locked out accounts in Active Directory.

## SYNTAX

```
Get-LockedOutAccount [<CommonParameters>]
```

## DESCRIPTION
Gets current list of locked out accounts in Active Directory

## EXAMPLES

### EXAMPLE 1
```
Get-LockedOutAccount
```

DisplayName     SamAccountName      DistinguishedName
        ----------      -------------       -----------------'
        TestAccount     TestAccount         cn=TestAccount,OU=PoshSec,DC=PoshSec,DC=Com
        Bob Uncle       Bob.Uncle           cn=Bob Uncle,OU=PoshSec,DC=PoshSec,DC=Com

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Part of the PoshSec PowerShell Module

## RELATED LINKS
