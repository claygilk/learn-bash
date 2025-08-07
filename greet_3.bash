#!/bin/bash

name=$1
time_24hr=$2

if [[ $time_24hr -lt 12 ]]; then
    echo "Good Morning ${name}!"  
elif [[ $time_24hr -lt 17 ]]; then
    echo "Good Afternoon ${name}!" 
else
    echo "Good Evening ${name}!" 
fi
