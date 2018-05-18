---
external help file: PoshSec-help.xml
Module Name: PoshSec
online version:
schema: 2.0.0
---

# Get-EnterpriseAdmins

## SYNOPSIS
Obtains the list of Enterprise admins.

## SYNTAX

```
Get-EnterpriseAdmins [[-Domain] <String>] [<CommonParameters>]
```

## DESCRIPTION
Obtains the list of Enterprise admins for the current or specified domain.

## EXAMPLES

### EXAMPLE 1
```
Get-EnterpriseAdmins
```

DisplayName     SamAccountName      DistinguishedName
        ----------      -------------       -----------------'
        TestAccount     TestAccount         cn=TestAccount,OU=PoshSec,DC=PoshSec,DC=Com
        Bob Uncle       Bob.Uncle           cn=Bob Uncle,OU=PoshSec,DC=PoshSec,DC=Com

## PARAMETERS

### -Domain
Name of domain to run query against.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
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
