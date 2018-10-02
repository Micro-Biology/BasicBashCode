# BasicBashCode
Basic BASH code for general programming


Bash shebang

    #!/bin/bash
    set -e #Stops scripts at first error
    set -u #Stops script if a variable is unset
    set -o pipefail #Prevents errors in a pipeline being masked
    
Better text printing

    printf "This prints this text and then a new line \n"
    printf "\033[1;34m This text is blue \e[0m\n"
    printf "$red" "This only works if you have the below lines in your ./bashrc"
    
printf colour alias

    red='\e[1;31m%s\e[0m\n' 
    green='\e[1;32m%s\e[0m\n' 
    yellow='\e[1;33m%s\e[0m\n' 
    blue='\e[1;34m%s\e[0m\n'  
    magenta='\e[1;35m%s\e[0m\n' 
    cyan='\e[1;36m%s\e[0m\n'

Any time you need to get todays date

    "$(date +%Y%m%d-%H%M%S)"
    mkdir "$(date +%Y%m%d-%H%M%S)" #directory with todays date
    zip "$(date +%Y%m%d-%H%M%S)".zip Archive #makes a zip of the folder Archive named todaysdate.zip

Make directory 'dir' if it doesn't exist:

    [[ -d dir ]] || mkdir dir
    
Set newest made directory as the value for variable 'new'

    new=$(ls -td -- */ | head -n 1 | cut -d'/' -f1)

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

Prints how long the script took to execute (strictly speaking its how long the terminal has been open when printed so be careful
    
    secs=$SECONDS
    printf "\033[1;34m Analysis completed in %dh:%dm:%ds\n \e[0m\n" \
    $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))
    
    
# BioinformaticsBashCode
Basic BASH code for bioinformatics

For loop example:

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

Calculate mean sequence length in fastq file:

    awk 'NR%4==2{sum+=length($0)}END{print sum/(NR/4)}' input.fastq

Fastq to Fasta:

    for samples in *.fastq; do awk 'NR%4==1 || NR%4==2' "$samples" > "$samples.fasta"; done

Rename files (bit more elegent than move) when used in for loops:

    rename "s/.oldprefix/.newprefix/g" *
    

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

Running code in parallel that doesnt have the option to do so: (DO NOT USE FOR CLUSTERING DE NOVO)

    ls *.fastq.gz | parallel -j 4 --no-notice 'cutadapt -e 0.1 -b ATGCGTTGGAGAGARCGTTTC -b GATCACCTTCTAATTTACCWACAACTG -o {}.trimmed.fastq.gz {}'

Another way of doing the above that works better with blast

    cat repset.fasta | parallel --block 100k --recstart '>' --gnu --pipe blastn -db diatoms -task blastn -max_target_seqs 1 -outfmt 6 -evalue 0.01 -query - > repset.diatoms.blastn

Retain just sequences from in.fastq

    awk '{if(NR%4==2) print $0}' in.fastq > out.txt
