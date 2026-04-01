#!/bin/bash

my_function() {
  echo "Hello world"
}

my_function


# parameter 1
input_fun() {
  local param=$1
  echo "The parameter is $param"
}

input_fun "Acer"

# parameter 1 and 2
input_fun() {
  local param1=$1
  local param2=$2
  echo "The parameter is $param1 and $param2"
}

input_fun "Acer" "ludo"

return_fun() {
  local sum=$(($1 + $2))
  echo $sum
  echo "Calculated"
}

result=$(return_fun 10 3)
echo $result
