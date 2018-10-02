#!/bin/bash
set -e
set -u
set -o pipefail

printf "\033[1;34m Backing Up \e[0m\n"

echo "making directories..."
#Navigate to master back up directory, eg:
cd backupdir/VMs_Backup/

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

mkdir VMBU && cd VMBU

echo "Copying Virtual Machines"
#Copy VMs to $PWD
cp -a -r -v ~/VirtualBox_VMs/* $PWD

echo "Compressing files"
cd .. && zip VMBU.zip VMBU/* && rm -r VMBU

printf "\033[1;34m Backup Complete \e[0m\n"
