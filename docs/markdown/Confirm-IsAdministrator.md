---
external help file: PoshSec-help.xml
Module Name: PoshSec
online version:
schema: 2.0.0
---

# Confirm-IsAdministrator

## SYNOPSIS
Checks to see if user is running as administrator

## SYNTAX

```
Confirm-IsAdministrator [<CommonParameters>]
```

## DESCRIPTION
This function checks to see if the user is currently running as an administrator

## EXAMPLES

### EXAMPLE 1
```
Confirm-IsAdministrator
```

False

### EXAMPLE 2
```
if (Confirm-IsAdministrator) { Write-Host "You are an admin" }
```

You are an admin

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Boolean

## NOTES
Part of the PoshSec PowerShell Module

## RELATED LINKS
