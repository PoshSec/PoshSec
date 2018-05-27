---
external help file: PoshSec-help.xml
Module Name: PoshSec
online version:
schema: 2.0.0
---

# Get-AccountsThatNeverLoggedIn

## SYNOPSIS
Gets current list of active accounts that have not logged into Active Directory.

## SYNTAX

```
Get-AccountsThatNeverLoggedIn [[-LastLogon] <Int32>] [[-SizeLimit] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Gets current list of active accounts that have not logged into Active Directory

## EXAMPLES

### EXAMPLE 1
```
Get-AccountsThatNeverLoggedIn
```

DisplayName     SamAccountName      DistinguishedName
        ----------      -------------       -----------------'
        TestAccount     TestAccount         cn=TestAccount,OU=PoshSec,DC=PoshSec,DC=Com
        Bob Uncle       Bob.Uncle           cn=Bob Uncle,OU=PoshSec,DC=PoshSec,DC=Com

## PARAMETERS

### -LastLogon
Days for last logon into the domain.
Default is 30.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 30
Accept pipeline input: False
Accept wildcard characters: False
```

### -SizeLimit
Size limit of objects to return in query

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 3000
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Part of the PoshSec PowerShell Module

## RELATED LINKS
