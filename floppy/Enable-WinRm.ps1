<#
    .SYNOPSIS
        Enables Windows Remote Management (WinRM)

    .DESCRIPTION
        This script enables Win RM for all builders.
        Provisioner scripts use Win RM to finalize configuration.

    .EXAMPLE VMware
        "floppy_files": [
            "./floppy/Initialize-VMwareIso.ps1",

    .EXAMPLE AWS
        "builders": [
            {
                "user_data_file": "./floppy/Enable-WinRm.ps1",

    .NOTES
        Author          : Glen Buktenica
        Copyright       : 2018 Kinetic IT Pty Ltd.
        License         : Apache License v 2.0
#>
# Disable IPv6
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\TCPIP6\Parameters" -Name DisabledComponents -PropertyType DWord -Value 0xffffffff -Force | Out-Null

# Private connections can not have WinRM enabled
Set-NetConnectionProfile -InterfaceAlias (Get-NetAdapter).name -NetworkCategory Private -Confirm:$false

# Enable WinRM
Set-NetFirewallRule -Name WINRM-HTTP-In-TCP-PUBLIC -RemoteAddress Any
Enable-WSManCredSSP -Force -Role Server
set-wsmanquickconfig -force

#autostart
sc.exe config WinRM start=auto

# Allow unencrypted traffic
Enable-PSRemoting -Force -SkipNetworkProfileCheck
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config '@{MaxTimeoutms="1800000"}'
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="2048"}'
winrm set winrm/config/listener?Address=*+Transport=HTTP '@{Port="5985"}'
net stop winrm

# Automatically end user processes when the user logs off or the system is restarted.
New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name AutoEndTasks -Value 1 -PropertyType String
