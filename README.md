check_MegaRAID
==============

Schedule the job (Run from elevated Powershell):

```
$listen = 'c:\scripts\listen.ps1'
$taskName = 'Listen_TCP'
    
$action = New-ScheduledTaskAction -Execute 'powershell.exe' `
                                  -Argument "-File $listen -ExecutionPolicy Bypass"
                                                                
$trigger = New-ScheduledTaskTrigger -AtStartup -RandomDelay 00:00:30
    
$settings = New-ScheduledTaskSettingsSet -MultipleInstances IgnoreNew `
                                         -DontStopOnIdleEnd `
                                         -AllowStartIfOnBatteries `
                                         -DontStopIfGoingOnBatteries `
                                         -ExecutionTimeLimit (New-TimeSpan -Days 3650)

Register-ScheduledTask -TaskName $taskName `
                       -Action $action `
                       -Trigger $trigger `
                       -Settings $settings `
                       -User 'SYSTEM' `
                       -Force
```
