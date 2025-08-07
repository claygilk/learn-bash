#!/bin/bash

cat longfile.txt | while read -r line; do
  echo "$line"
done

