    <#
        Checks to see if the eventlog is there
        If not, creates the eventlog and writes to it
        If so, continues with settings.

        T

    #>

        New-EventLog -LogName 'TokenWatcher' -Source Token
        Limit-EventLog -LogName 'TokenWatcher' -OverflowAction DoNotOverwrite -MaximumSize 1GB
 
        Write-EventLog -LogName 'TokenWatcher' -Source Token -Message "Log started on $(Get-Date)" -EventId 100 -EntryType Information
        



    $folder = "C:\Scripts\HoneyToken"
    $filter = '*.*'  # You can enter a wildcard filter here. 
    $filename = "HoneyToken-Log-$(Get-Date -Format yyyy-MM-dd).txt"
   
 
    # In the following line, you can change 'IncludeSubdirectories to $true if required.                           
    $fsw = New-Object IO.FileSystemWatcher $folder, $filter -Property @{IncludeSubdirectories = $true;NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'} 
 
    # Here, all three events are registerd.  You need only subscribe to events that you need: 
 
    Register-ObjectEvent $fsw Created -SourceIdentifier FileCreated -Action{ 
        $name = $Event.SourceEventArgs.Name 
        $changeType = $Event.SourceEventArgs.ChangeType 
        $timeStamp = $Event.TimeGenerated  
        Write-EventLog -LogName TokenWatcher -Source Token -Message "The file '$name' was $changeType at $timeStamp" -EventId 101 -EntryType Information
        } 
 
    Register-ObjectEvent $fsw Deleted -SourceIdentifier FileDeleted -Action{ 
        $name = $Event.SourceEventArgs.Name 
        $changeType = $Event.SourceEventArgs.ChangeType 
        $timeStamp = $Event.TimeGenerated 
        Write-EventLog -LogName TokenWatcher -Source Token -Message "The file '$name' was $changeType at $timeStamp" -EventId 102 -EntryType Information
        } 
 
    Register-ObjectEvent $fsw Changed -SourceIdentifier FileChanged -Action{ 
        $name = $Event.SourceEventArgs.Name 
        $changeType = $Event.SourceEventArgs.ChangeType 
        $timeStamp = $Event.TimeGenerated 
        Write-EventLog -LogName TokenWatcher -Source Token -Message "The file '$name' was $changeType at $timeStamp" -EventId 103 -EntryType Information
        } 
 
