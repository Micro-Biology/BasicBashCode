#!/bin/bash
set -e #Stops scripts at first error
set -u #Stops script if a variable is unset
set -o pipefail #Prevents errors in a pipeline being masked
#Backup home file to Data
sudo rsync -ahuv --exclude '.*' /home/-user- /media/-user-/Data/home_backup
#Make latest backup folder
mkdir -p /media/-user-/backup_disk/backups/latest
#make latest backup
rsync -avhvb \
  /media/-user-/Data/ \
  /media/-user-/backup_disk/backups/latest
#date latest backup folder
mkdir -p backups/"$(date +"%Y")"/"$(date +"%m")"/"$(date +"%d")"
cp -alv /media/-user-/backup_disk/backups/latest/ /media/-user-/backup_disk/backups/"$(date +"%Y")"/"$(date +"%m")"/"$(date +"%d")"
