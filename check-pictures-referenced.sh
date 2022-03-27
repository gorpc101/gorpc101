#!/bin/bash 

for i in `ls .gitbook/assets/`
do 
    find . -iname "*.md" -print0 | \
        while read -d $'\0' file
        do 
            grep --color -Hn ${i} ${file}
        done
done
