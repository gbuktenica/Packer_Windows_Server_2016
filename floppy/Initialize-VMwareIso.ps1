<#
    .SYNOPSIS
        VMware specific configuration

    .DESCRIPTION
        Option to use a static or dynamic IP address for configuration (dynamic recommended)
        Installs Chocolatey
        Installs VMware tools
        Configuration common to all builders should be in other scripts.

    .EXAMPLE
        "floppy_files": [
            "./floppy/Initialize-VMwareIso.ps1",

    .NOTES
        Author          : Glen Buktenica
        Copyright       : 2018 Kinetic IT Pty Ltd.
        License         : Apache License v 2.0
#>
# Disable IPv6
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\TCPIP6\Parameters" -Name DisabledComponents -PropertyType DWord -Value 0xffffffff -Force | Out-Null

# Test that Network Adapter is connected
# Wait for operator to repair if not

If (-not((Get-NetAdapter -Physical | Where-Object status -eq 'up' | Select-Object Name).Name).Length -gt 0) {
    Write-Output 'Waiting for connected ethernet adapter'
    Write-Warning 'Check cable or VM settings'
    Start-Sleep -s 5
}
While (-not((Get-NetAdapter -Physical | Where-Object status -eq 'up' | Select-Object Name).Name).Length -gt 0) {
    Write-Output '.' -NoNewline
    Start-Sleep -s 1
}

# De-comment out below to set static IP address for build. Make sure correct IP, Subnet and Gateway are updated.
# Set Static IP address
# New-NetIPAddress -IPAddress 10.1.1.1 -InterfaceIndex (Get-NetAdapter).ifIndex -PrefixLength 24 -DefaultGateway 10.1.1.254
# Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses 10.1.1.10,10.1.1.11

# Test internet/LAN connection
# This test can be changed to the Nexus endpoint if public chocolately is not available.
If (-not (Test-NetConnection chocolatey.org -port 80 -InformationLevel Quiet -ErrorAction SilentlyContinue)) {
    Write-Warning "If IP address settings have been incorrectly set they can be safely changed now"
}
While (-not (Test-NetConnection chocolatey.org -port 80 -InformationLevel Quiet -ErrorAction SilentlyContinue)) {
    Write-Output "." -NoNewline
    Start-Sleep -s 1
}