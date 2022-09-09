function Add-PersistRDP {
    
    [CmdletBinding()]
            Param(
            [Parameter(Mandatory=$false)]
            [bool]$DisableNLA = $false
        )
    
    if ($DisableNLA) {
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 0 -Force
    }
    
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0 -Force
    
    if (Get-NetFirewallRule -DisplayGroup "Remote Desktop") {
        Set-NetFirewallRule -DisplayGroup "Remote Desktop" -Action Allow -Enabled True
    }
    else {
        New-NetFirewallRule -DisplayName "Remote Desktop - User Mode (UDP-In)" -Direction Inbound -LocalPort 3389 -Protocol UDP -Action Allow
        New-NetFirewallRule -DisplayName "Remote Desktop - User Mode (TCP-In)" -Direction Inbound -LocalPort 3389 -Protocol TCP -Action Allow
    }
}