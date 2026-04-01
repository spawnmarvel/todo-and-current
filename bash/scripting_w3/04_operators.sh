#!/bin/bash

# numbers

num3=22
if [ $num3 -gt 20 ]; then
 echo "Greater than 20"
fi

# strings
name="john"
if [ $name = "Jim" ]; then
 echo "Name is equal $name"
else
  echo "Name is not equal $name"
fi

# file

# asuming the folder is in the dir where we run the script
check_dir="folder/"
if [ -d "$check_dir" ]; then
  echo "Dir exists $check_dir"
else
  echo "Dir not exists $check_dir"
fi
