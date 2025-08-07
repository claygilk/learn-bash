#!/bin/bash

# Sorts all files in current directory according to extension
# Ex. file.json will move to ./json/file.json and file.csv will move to ./csv/file.csv

cd $1

ls -1 | awk -F "." '{ ext = NF; print $ext}' | while read -r ext ; do
    if [[ -d $ext ]]; then
        echo "${ext} exists!"
    else
        mkdir $ext; 
    fi
done


ls -p | grep -v / | grep -v "sort.sh" | while read -r file; do

    ext=$(echo $file | awk -F "." '{ ext = NF; print $ext}')

    mv $file ./$ext/$file

done