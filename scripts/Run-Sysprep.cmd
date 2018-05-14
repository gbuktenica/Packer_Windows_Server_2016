REM Called by Packer shutdown
REM Sysprep the server and shut down so that Packer can convert to template

REM Sysprep and exit with no restart or shutdown
c:\windows\system32\sysprep\sysprep.exe /generalize /oobe /mode:vm /quiet /quit

REM Copy unattend to Panther default directory
mkdir c:\Windows\Panther\unattend
copy c:\Windows\Temp\unattend.xml c:\Windows\Panther\unattend\unattend.xml

REM Trigger shutdown in 10 seconds
shutdown -s -t 10

REM Return code of 0 to Packer
EXIT /B 0