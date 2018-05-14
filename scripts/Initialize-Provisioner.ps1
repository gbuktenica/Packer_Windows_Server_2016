<#
.SYNOPSIS
    Configures a base Windows Server 2016 image

.DESCRIPTION
    This script configures Windows enough to allow puppet to manage the server.
    It is used all cloud builders.
    Cloud specific configuration should be in separate scripts.

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

# Ensure Sysprep keys are set correctly
New-ItemProperty -Path "HKLM:\SYSTEM\Setup\Status\SysprepStatus" -Name CleanupState -Value 2 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path "HKLM:\SYSTEM\Setup\Status\SysprepStatus" -Name GeneralizationState -Value 7 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" -Name SkipRearm -Value 1 -PropertyType DWord -Force | Out-Null