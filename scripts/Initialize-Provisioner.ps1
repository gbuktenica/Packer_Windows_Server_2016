<#
.SYNOPSIS
    Configures a base Windows Server 2016 image

.DESCRIPTION
    This script configures Windows enough to allow Puppet or Ansible to configure.

 .EXAMPLE
    "scripts": [
        "./scripts/Install-Packages.ps1",
        "./scripts/Initialize-Provisioner.ps1"
    ]

.NOTES
    Author          : Glen Buktenica
    Copyright       : 2017 Kinetic IT Pty Ltd.
    License         : Apache License v 2.0
#>
# Set Screen Resolution
#Set-DisplayResolution -Width 1280 -Height 800 -Force

# Set Network connection category to Private
Set-NetConnectionProfile -InterfaceAlias (Get-NetAdapter).name -NetworkCategory Private -Confirm:$false

# Enable RDP
New-NetFirewallRule -DisplayName "Allow Inbound RDP" -Direction Inbound -LocalPort 3389 -Protocol TCP -Action Allow
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name fDenyTSConnections -Value 0 -PropertyType DWord -Force

#Install VMware tools
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install vmware-tools -y
