# BasicBashCode
basic BASH code for general programming


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
    

For loop:

    for f in *.txt ; do
        <code manipulating $f>
        echo "file $f manipulated"
    done
    
    for i in {1..10} ; do
        <code to reproduce 10 times>
        
    done
