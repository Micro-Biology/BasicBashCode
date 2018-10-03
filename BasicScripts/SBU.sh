#!/bin/bash
set -e
set -u
set -o pipefail

#Backs up and zips .sh files in ~ and ~/Scripts directory

printf "\033[1;34m Backing Up \e[0m\n"

#Navigate to master back up directory, eg:
cd backupdir/Script_Backup

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

mkdir HomeScripts && cd HomeScripts

#Copy files to $PWD
cp ~/*.sh $PWD
cp ~/Scripts/* $PWD


cd .. && zip -r HomeScripts.zip HomeScripts && rm -r HomeScripts

printf "\033[1;34m Backup Complete \e[0m\n"
