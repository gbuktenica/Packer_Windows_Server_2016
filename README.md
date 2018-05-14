# Packer build of Windows Server 2016

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Description

This project contains the files and artefacts required to build a Windows 2016 Server on VMware infrastructure.

## Usage instructions

Edit Autounattend.xml and sysprep-unattend.xml
Update the product key with the correct value

Download en_windows_server_2016_updated_feb_2018_x64_dvd_11636692.iso from Microsoft and save to the ISO folder.

Edit template.json and edit all of the entries in the variables section.

## Build instructions

```commandline
packer build template.json
```