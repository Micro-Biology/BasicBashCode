# BasicBashCode
Basic BASH code for general programming


Bash shebang

    #!/bin/bash
    set -e
    set -u
    set -o pipefail
    
Nicer text use printf (this colour is blue)

    printf "\033[1;34m Text Here \e[0m\n"

Make directory 'dir' if it doesn't exist:

    [[ -d dir ]] || mkdir dir

While true loop:

    while true :
    do
        <code to perfrom>;
        sleep 60;
    done
    
While loop:

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
        echo "$v" #will count 1 3 5 7 9
    done
