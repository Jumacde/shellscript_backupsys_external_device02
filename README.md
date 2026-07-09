# shellscript_backupsys_external_device02

backup system to 2 externer devices by shellscriipt.  

[structure]
  1) .env: include log_dir path(test/production enviroment) and backup_dir path.  
  2) .gitignore: include .env to hide log_dir and backup_dir and testlog file on github/gitlab
  3) main.sh:  run this backupsystem via loading finctions from other scripts.
  4) log_manager.sh:  load log_dir from .env and set up each path via inputting command(test:sudo ./main.sh prod: sudo ENV=prod ./main.sh ).
  5) device_manager.sh: load backup_dir from .env and set up follow tastk
      1. check mount staus the devices.
          if the device isn’t mounted show and record error message.
          if only a device is mounted start buck up to this device.
          if both device is mounted execute system to both device.
      2. execute backup date.
          if the directory for backup isn’t exist create this directory.
          send data to each mounted backup_dir.
          record the result of this system on log file.

