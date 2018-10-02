#!/bin/bash

#Backs up pipelines using virtual machines

cd backupdir/Pipeline_Backup

[[ -d "$(date '+%Y')" ]] || mkdir "$(date '+%Y')" ; cd $(date '+%Y')
[[ -d "$(date '+%b-%d')" ]] || mkdir "$(date '+%b-%d')" ; cd $(date '+%b-%d')

cp -r pipelinedir/* $PWD/

cd pipelinedir

rm testdata/* || true
rm QC/testdata/* || true
rm Qiime/analysis/* || true

echo "Pipeline backed up as of " "$(date)" >> BackupInfo.txt
