$action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c `"$PSScriptRoot\RunFetchApiTokenService.bat`""
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

Register-ScheduledTask -TaskName "FetchApiTokenService" -Action $action -Trigger $trigger -Principal $principal -Settings $settings
