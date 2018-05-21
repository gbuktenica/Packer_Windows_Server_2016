REM Enable verbose logging for packer
set PACKER_LOG=1
set PACKER_LOG_PATH=Packer.log.txt
call packer build template.json
