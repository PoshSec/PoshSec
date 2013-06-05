function Set-SecLogSettings
{
    <#
        Goal
        To manage, configure and enable the eventlogs.
        Increase storage size
        Configure the overflow action (not to erase, but to create a new log

    #>

    Limit-EventLog -LogName Application -MaximumSize 1GB -OverflowAction DoNotOverwrite
    Limit-EventLog -LogName Security -MaximumSize 1GB -OverflowAction DoNotOverwrite
    Limit-EventLog -LogName System -MaximumSize 1GB -OverflowAction DoNotOverwrite
    Limit-EventLog -LogName 'DNS Server' -MaximumSize 1GB -OverflowAction DoNotOverwrite
    
}
