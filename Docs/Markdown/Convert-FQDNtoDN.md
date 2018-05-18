---
external help file: PoshSec-help.xml
Module Name: PoshSec
online version:
schema: 2.0.0
---

# Convert-FQDNtoDN

## SYNOPSIS
Converts FQDN to DN

## SYNTAX

```
Convert-FQDNtoDN [-domainFQDN] <String> [<CommonParameters>]
```

## DESCRIPTION
This converts a user supplied Fully Qualified DOmain Name (FQDN) into a Distinguished Name (DN).

## EXAMPLES

### EXAMPLE 1
```
Convert-FQDNtoDN -domainFQDN 'poshsec.com'
```

DC=poshsec,DC=com

### EXAMPLE 2
```
Convert-FQDNtoDN 'dev.contoso.net'
```

DC=dev,DC=contoso,DC=NET

## PARAMETERS

### -domainFQDN
This is the Fully Qualified Domain Name (FQDN) that needs to be turned into a Distinguished Name (DN).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This is a PoshSec Utility Function.

## RELATED LINKS
