#!/bin/bash
my_array=("val1" "val2" "val3")
# get 0
echo $my_array[0]
# get all

echo "${my_array[@]}"

# mod
my_array[1]="val22"

echo "${my_array[@]}"
