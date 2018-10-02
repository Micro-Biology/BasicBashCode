#!/bin/bash

#This script converts all .biom files in the current directory to the .tsv format

printf "\033[1;34m This script converts all .biom files in the current directory to the .tsv format \e[0m\n"
read -p "Are you sure you want to do this? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    for f in *.biom ; do
        b=$(sed -e "s/.biom/""/" <<< "$f")
        echo "file $f processing"
        biom convert -i $f -o $b.FromBiom.tsv --to-tsv
        echo "file $b.FromBiom.tsv.biom exported"
    done
fi

