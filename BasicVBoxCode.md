# BasicVBoxCode
Basic code for automation of virtual machines as part of a bioinformatic pipeline

## Install Virtual Box on Linux Host

    sudo apt-get update
    sudo apt-get upgrade
    
Easiest way is to download the virtual box .deb install file and double click it! But the below should work:

    sudo apt-get install virtualbox
    
If that doesnt work try this and then try installing again:

    sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian `lsb_release -cs` contrib"
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -


## Basic Management Code

list VMs

    VBoxManage list vms

Start VM called "QIIME"

    VBoxManage startvm "QIIME"

Clone VM "QIIME"

    VBoxManage clonevm "QIIME" 
    
Checks to see if VM is running (0 is off, 1 is on)

    D1=$(vboxmanage showvminfo "Diatom_VM_1.0" | grep -c "running (since")
    echo $D1
    
Above within a whie true loop

    VM=$(vboxmanage showvminfo "VM" | grep -c "running (since")
    while true ;  do
	      if [ $VM = 0 ]
	          then
		     printf "VM has shut down \n" && break;
	          else
		     printf "Waiting for VM to complete work, will check again in another 5 minute(s)...\n" && sleep 300; VM1=$(vboxmanage showvminfo "VM" | grep -c "running (since") ; echo " $VM status" ;
              fi
    done
