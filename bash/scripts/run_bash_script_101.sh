#!/bin/bash

# https://www.w3schools.com/bash/bash_syntax.php

# sudo chmod +x run_bash_script_101.sh
# sudo ./run_bash_script_101.sh

echo "Hello 101"
echo "Hello 102"
echo "use ; for multiple lines"; echo " like this"

name="World"
echo " Hello $name"

current_dir=$(pwd)
echo $current_dir

number=42
echo $number

echo "Path is $PATH"

my_function() {
 local local_var="I am local"
 echo $local_var
}
my_function

player="John"
game="RPG"
echo $player$game

health=80
candybar=22
sum=$((health + candybar))
echo $sum

greeting="Allo, allo"
name="Steve"
welcome="$greeting, $name"
echo $welcome

num1=5
num2=2
sum=$((num1 + num2))
diff=$((num1 - num2))
mult=$((num1 * num2))
div=$((num1 / num2))
echo "sum $sum, diff $diff, mult $mult, div $div"

enemy=("ogre" "demon" "troll")
for e in "${enemy[@]}"; do
 echo $e
done

declare -A enemys
enemys[ogre]="100kg"
enemys[demon]="150kg"
enemys[troll]="200kg"
enemys[god]="50kg"
unset enemys[god]
echo ${enemys[demon]}

num=15
if [ $num -gt 10 ]; then
 echo "Number is greater then 10 $num"
fi

num2=2
if [ $num2 -gt 10 ]; then
 echo "Number is greater then 10 $num2"
else
 echo "Number is not greater then 10 $num2"
fi

num3=20
if [ $num3 -gt 20 ]; then
 echo "Number is greater then 20 $num3"
elif [ $num3 -eq 20 ]; then
 echo "Number is equal to 20 $num3"
else
 echo "Number is less then 20 $num3"
fi

num4=32
if [ $num4 -gt 20 ]; then
 if [ $num4 -lt 35 ]; then
  echo "Number is gt then 20 and less then 35 $num4"
 fi
fi
