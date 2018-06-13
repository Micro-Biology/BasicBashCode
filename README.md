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

Make directory 'dir' if it doesn't exist:

    [[ -d dir ]] || mkdir dir

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
