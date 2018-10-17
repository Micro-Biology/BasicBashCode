# BasicBashCode
Basic code for general programming, scripts in the Scripts folder should have explanations of what they are and how to use them.

## <a name="Contents"></a>Contents

- [To Start](#To_Start)
- [Printf](#Printf)
- [File Manipulation](#File_Manipulation)
- [Directories](#Directories)
- [Loops](#Loops)
- [Time](#Time)
- [VirtualBox](#VirtualBox)
- [bashrc additions](#bashrc_additions)

- [General Bioinformatics](#General_Bioinformatics)
- [Format changes](#Format_Changes)
- [Qiime 1 prep](#Qiime1_Prep)
- [Multithreading of single threaded workflows](#Multithreading)


## <a name="To_Start"></a>To Start

Goto Bash shebang:

    #!/bin/bash
    set -e #Stops scripts at first error
    set -u #Stops script if a variable is unset
    set -o pipefail #Prevents errors in a pipeline being masked

Launches System monitor and continues with the rest of the script:
    gnome-system-monitor &

[[back to top](#Contents)]


## <a name="Printf"></a>Printf

Better text printing:

    printf "This prints this text and then a new line \n"
    printf "\033[1;34m This text is blue \e[0m\n"
    printf "$red" "This only works if you have the below lines in your ./bashrc"
    
printf colour alias:

    red='\e[1;31m%s\e[0m\n' 
    green='\e[1;32m%s\e[0m\n' 
    yellow='\e[1;33m%s\e[0m\n' 
    blue='\e[1;34m%s\e[0m\n'  
    magenta='\e[1;35m%s\e[0m\n' 
    cyan='\e[1;36m%s\e[0m\n'

[[back to top](#Contents)]


## <a name="File_Manipulation"></a>File Manipulation

Replace all occurences of StringA with StringB in a text file:

    sed 's/StringA/StringB/g' file.txt

Rename files (bit more elegent than move) when used in for loops:

    rename "s/.oldprefix/.newprefix/g" *

Check to see if it's a regular file

    [ -f "/you/file.file" ] && echo 1 || echo 0

Check to see if a file exists

    [ -e "/you/file.file" ] && echo 1 || echo 0


[[back to top](#Contents)]


## <a name="Directories"></a>Directories

Find and go to Unusual_Dir:

cd "$find ~/location_to_search -name "Unusual_Dir" -printf '%h' -quit)"

Make directory 'dir' if it doesn't exist:

    [[ -d dir ]] || mkdir dir
    
Set newest made directory as the value for variable 'new':

    new=$(ls -td -- */ | head -n 1 | cut -d'/' -f1)

[[back to top](#Contents)]


## <a name="Loops"></a>Loops

While true loop:

    while true :
    do
        <code to perfrom>;
        sleep 60;
    done
    
While loop:

    i=1
    while (i > 10) :
    do
        #<code to perform when $i is less than 10 eg as below>;
        echo "$i" #will count from 1 to 10
        i=$((i + 1)); #alternatively "((i++))" will +1 to i and is technically quicker but isn't as readable
    done

For loop file maniplulation:

    for f in *.txt ; do
        <code manipulating $f>
        echo "file $f manipulated"
    done
    
For loop code so many times: (the same as while loop with i)
    
    for v in {1..10..2} ; do
        #<code to reproduce 5 times in increments of 2 eg below>;
        #This would be useful if for example you wanted to count how 
        #many samples there was if each sample was represented by 2 fastq files
        echo "$v" #will count 1 3 5 7 9
    done

For loop example for within a bioinformatic pipeline:

    for f in *.R1.fastq.gz.trimmed.fastq.gz ; do
    
        r=$(sed -e "s/.R1./.R2./" <<< "$f")
        s=$(sed -e "s/.R1.fastq.gz.trimmed.fastq.gz/""/" <<< "$f")
    
        echo
        echo ====================================
        echo Processing sample $s
        echo ====================================
    
        Command to be run for every sample \
            --inF $f \
            --inR $r \
            --out $s.analysed.fastq.gz
    done

Prompts user to continue yes or no?: (for example this scipt converts all .biom files to TSV files)

    read -p "Are you sure you want to do this? " -n 1 -r 
    #accepts first character if thats a y then it does the script
    echo    #creates new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        for f in *.biom ; do
            b=$(sed -e "s/.biom/""/" <<< "$f")
            echo "file $f processing"
            biom convert -i $f -o $b.FromBiom.tsv --to-tsv
            echo "file $b.FromBiom.tsv.biom exported"
        done
    fi

[[back to top](#Contents)]


## <a name="Time"></a>Time

Prints how long the script took to execute (strictly speaking its how long the terminal has been open when printed so be careful
    
    secs=$SECONDS
    printf "\033[1;34m Analysis completed in %dh:%dm:%ds\n \e[0m\n" \
    $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))
    
Any time you need to get todays date

    "$(date +%Y%m%d-%H%M%S)"
    mkdir "$(date +%Y%m%d-%H%M%S)" #directory with todays date
    zip "$(date +%Y%m%d-%H%M%S)".zip Archive #makes a zip of the folder Archive named todaysdate.zip    

[[back to top](#Contents)]


## <a name="VirtualBox"></a>VirtualBox

Install Virtual Box on Linux Host

    sudo apt-get update
    sudo apt-get upgrade
    
Easiest way is to download the virtual box .deb install file and double click it! But the below should work:

    sudo apt-get install virtualbox
    
If that doesnt work try this and then try installing again:

    sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian `lsb_release -cs` contrib"
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -


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

[[back to top](#Contents)]


## <a name="bashrc_additions"></a>bashrc additions

Extract feature
    extract () {
       if [ -f $1 ] ; then
           case $1 in
            *.tar.bz2)      tar xvjf $1 ;;
            *.tar.gz)       tar xvzf $1 ;;
            *.tar.xz)       tar Jxvf $1 ;;
            *.bz2)          bunzip2 $1 ;;
            *.rar)          unrar x $1 ;;
            *.gz)           gunzip $1 ;;
            *.tar)          tar xvf $1 ;;
            *.tbz2)         tar xvjf $1 ;;
            *.tgz)          tar xvzf $1 ;;
            *.zip)          unzip $1 ;;
            *.Z)            uncompress $1 ;;
            *.7z)           7z x $1 ;;
            *)              echo "don't know how to extract '$1'..." ;;
           esac
       else
           echo "'$1' is not a valid file!"
       fi
    }

Colour alias for print f:

    #printf colour alias, use as below
    red='\e[1;31m%s\e[0m\n'
    green='\e[1;32m%s\e[0m\n'
    yellow='\e[1;33m%s\e[0m\n'
    blue='\e[1;34m%s\e[0m\n'
    magenta='\e[1;35m%s\e[0m\n'
    cyan='\e[1;36m%s\e[0m\n'

    #printf "$green"   "This is a test in green"
    #printf "$red"     "This is a test in red"
    #printf "$yellow"  "This is a test in yellow"
    #printf "$blue"    "This is a test in blue"
    #printf "$magenta" "This is a test in magenta"
    #printf "$cyan"    "This is a test in cyan"

cd alias

    alias ..='cd ..'
    alias ...='cd ..; cd..'
    alias ....='cd ..; cd ..; cd ..'
    alias .....='cd ..; cd ..; cd ..; cd ..'
    alias ......='cd ..; cd ..; cd ..; cd ..; cd ..'

cd and list

    cdls() {
        builtin cd "$@" && ls
    }

Repeat last command as sudo

    alias pls='sudo (!!)'

Send to Recycling bin

    #Requires trash-cli, install using: sudo apt-get install trash-cli
    alias del='trash'

[[back to top](#Contents)]


## <a name="General_Bioinformatics"></a>General Bioinformatics

### <a name="Format_Changes"></a>Format Changes

Calculate mean sequence length in fastq file:

    awk 'NR%4==2{sum+=length($0)}END{print sum/(NR/4)}' input.fastq

Fastq to Fasta:

    for f in *.fastq; do s=$(sed -e "s/.fastq/""/" <<< "$f") ; sed -n '1~4s/^@/>/p;2~4p' $f > $s.fasta; done

Gives general information about a fastq file: # want to format this better:

    cat test.fastq | awk '((NR-2)%4==0){read=$1;total++;count[read]++}END{for(read in count){if(!max||count[read]>max) {max=count[read];maxRead=read};if(count[read]==1){unique++}};print total,unique,unique*100/total,maxRead,count[maxRead],count[maxRead]*100/total}'

Output sequence name and length for fasta file:

    for f in *.fasta; do s=$(sed -e "s/.fasta/""/" <<< "$f") ; cat $f | awk '$0 ~ ">" {print c; c=0;printf substr($0,2,100) "\t"; } $0 !~ ">" {c+=length($0);} END { print c; }' > $s.int.txt ; awk 'NR>1' $s.int.txt > $s.txt && rm $s.int.txt ; done

Retain just sequences from fastq:

    awk '{if(NR%4==2) print $0}' test.fastq > .txt

[[back to top](#Contents)]

### <a name="Qiime_1_prep"></a>Qiime1 Prep

Change fasta header to sequence number in that sample:

    for samples in *.fasta ; do
	    cat $samples | perl -ane 'if(/\>/){$a++;print ">_$a\n"}else{print;}' > "$samples.ordered"
    done

    rm *.fasta

    rename "s/.fasta.ordered/.fasta/g" *

    for samples in *.fasta ; do
    	awk '/>/{sub(">","&"FILENAME"");sub(/\.fasta/,x)}1' $samples > "$samples.named"
    done

    rm *.fasta
    rename "s/.named/.fasta/g" *

Combining Sequences for clustering:

    cat *.fasta > allsamples.fasta

Folding fasta file for qiime clustering pipeline:

    fold -w 60 allsamples.fasta > readyForClustering.allsamples.fasta

[[back to top](#Contents)]

### <a name="Multithreading"></a>Multithreading

Running code in parallel that doesnt have the option to do so: (DO NOT USE FOR CLUSTERING DE NOVO)

    ls *.fastq.gz | parallel -j 4 --no-notice 'cutadapt -e 0.1 -b ATGCGTTGGAGAGARCGTTTC -b GATCACCTTCTAATTTACCWACAACTG -o {}.trimmed.fastq.gz {}'

Another way of doing the above that works better with blast:

    cat repset.fasta | parallel --block 100k --recstart '>' --gnu --pipe blastn -db diatoms -task blastn -max_target_seqs 1 -outfmt 6 -evalue 0.01 -query - > repset.diatoms.blastn

[[back to top](#Contents)]

