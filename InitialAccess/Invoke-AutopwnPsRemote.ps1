# https://www.commandline.ninja/connecting-to-multiple-computers-with-invoke-command/#:~:text=PowerShell%20Remoting%20allows%20you%20to,the%20remote%20machine(s). 
function Invoke-AutopwnPsRemote {

    [CmdletBinding()]
            Param(
            [Parameter(Mandatory)]
            [string[]]$Hosts,

            [Parameter(Mandatory=$false)]
            [string]$Username,

            [Parameter(Mandatory=$false)]
            [string]$Password,

            [Parameter(Mandatory)]
            [string]$Payload,
            
            [Parameter(Mandatory=$false)]
            [System.Management.Automation.PSCredential]$Credential
            )
    if (!$Credential) {
        $CredentialPass = ConvertTo-SecureString "$Password" -AsPlainText -Force
        $Credential = New-Object System.Management.Automation.PSCredential ("$Username", $CredentialPass)
    }
    
    Invoke-Command $Hosts -ScriptBlock {$Payload} -Credential $Credential
    
}