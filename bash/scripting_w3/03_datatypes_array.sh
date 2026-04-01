#!/bin/bash

# strings
greeting="Allo, allo"
name="Steve"
welcome="$greeting, $name"
echo "$welcome"

# Numbers
num1=5
num2=2
echo "sum $((num1 + num2)), diff $((num1 - num2)), mult $((num1 * num2)), div $((num1 / num2))"

# Standard Array
enemy=("ogre" "demon" "troll")
for e in "${enemy[@]}"; do
 echo "Enemy: $e"
done

# Key-Value (Associative) Array
declare -A enemys
enemys[ogre]="100kg"
enemys[demon]="150kg"
enemys[troll]="200kg"
enemys[god]="50kg"

unset enemys[god]
# ater this, echo $nemys[god] will produce no output, and the variable will be "unbound".

echo "Demon weight: ${enemys[demon]}"
