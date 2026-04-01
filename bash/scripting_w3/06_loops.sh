#!/bin/bash
# for loop

for i in {1..5}; do
  echo "Iteration $i"
done

# while loop

count=1
while [ $count -le 5 ]; do
  echo "Count is $count"
  ((count++))
done

# until loop

count=1
until [ $count -gt 5 ]; do
  echo "Count is $count"
  ((count++))
done

# break and continue

for i in  {1..5}; do
  if [ $i -eq 3 ]; then
    continue
  fi
  echo "Number $i"
  if [ $i -eq 4 ]; then
    break
  fi
done

# nested loops

for i in {1..3}; do
  for j in {1..2}; do
    echo "Outer $i, Inner $j"
  done
done
