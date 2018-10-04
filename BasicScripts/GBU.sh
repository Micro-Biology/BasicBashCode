#!/bin/bash
set -e #Stops scripts at first error
set -u #Stops script if a variable is unset
set -o pipefail #Prevents errors in a pipeline being masked

#Script to pull contents of Gdrive, back them up, and offer to put them on a memory stick.
#To Do:
#---Export to USB drive

#This script uses 'drive' to back up a google drive account, to install follow instructions here: https://medium.com/the-sysadmin/back-up-your-google-drive-files-from-linux-fcb68b234607 I am not affiliated with this link.

Differences="Var Differences incorrectly set"
Expecteddifferences="Var Expecteddifferences incorrectly set"
printf '\e[1;34m%s\e[0m\n' "Backing up Google Drive"
printf '\e[1;31m%s\e[0m\n' "WARNING: " "This script does not correctly backup 'google' files." "If you need to back these files up you must do this manually."

#sleep 30s

cd ~/Gdrive
drive pull -export doc,xls -no-prompt -verbose -ignore-name-clashes .

cd /BackupDirectory/Gdrive_Backup

#Makes a directory named after the current year eg: 2018
[[ -d "$(date '+%Y')" ]] || mkdir "$(date '+%Y')" ; cd $(date '+%Y')
#Makes a directory named after the current Month eg: Jan
[[ -d "$(date '+%b')" ]] || mkdir "$(date '+%b')" ; cd $(date '+%b')
#Makes a directory named after the current day of the month eg: 21
[[ -d "$(date '+%d')" ]] || mkdir "$(date '+%d')" ; cd $(date '+%d')

#Sets next set of code adds a subsequent directory depending on how many backups have been performed that day
Dir="1"
while [ -d $Dir ]; do
	let Dir+=1
done
mkdir $Dir ; cd $Dir

mkdir G && cd G

printf "Copying files to backup \n"

cp -r ~/Gdrive/* $PWD/ && cd ..

Expecteddifferences="Only in /home/nls/Gdrive: .gd"
printf "Expected differences = $Expecteddifferences \n"
#Needs '|| true' to stop script from failing 
Differences=$(diff -qr ~/Gdrive $PWD/G || true )
printf "Actual difference = $Differences \n"

if [ "$Differences" = "$Expecteddifferences" ]
then
	printf '\e[1;34m%s\e[0m\n' "File copying passed"
else
	printf '\e[1;31m%s\e[0m\n' "Error - File copying failed" "Exiting Script"; exit
fi

printf '\e[1;34m%s\e[0m\n' "Zipping backup and removing source"

printf "Zipping files" && zip -r G.zip G && rm -r G && rm -r ~/Gdrive/*
