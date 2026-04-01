#!/bin/bash

current_dir=$(pwd)
echo "Curent dir $current_dir"

number=42
echo $number

# Environment Variables
echo "Your PATH is $PATH"

# Concatenation
player="John"
game="RPG"
echo "$player$game"

# Arithmetic
health=80
candybar=22
sum=$((health + candybar))
echo "Total Health: $sum"
