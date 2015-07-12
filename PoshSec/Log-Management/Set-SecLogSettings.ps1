function Set-SecLogSettings
{
    

    Limit-EventLog -LogName Application -MaximumSize 1GB -OverflowAction DoNotOverwrite
    Limit-EventLog -LogName Security -MaximumSize 1GB -OverflowAction DoNotOverwrite
    Limit-EventLog -LogName System -MaximumSize 1GB -OverflowAction DoNotOverwrite
    Limit-EventLog -LogName 'DNS Server' -MaximumSize 1GB -OverflowAction DoNotOverwrite
    
    <#
        .SYNOPSIS
        Configures log settings. Sizing must be configured to individual needs, as initial values should not be considered a baseline
        
        .DESCRIPTION
        Configures log settings

        .LINK
			www.poshsec.com
	
		.LINK
			github.com/poshsec


    #>
}
