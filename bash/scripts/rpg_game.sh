#!/bin/bash

echo "RPG world"
version=1.0
echo "Version $version"

# game loop
while true; do
        read -p "Enter something (type false to stop): " userinput

        if [ "$userinput" == "false" ]; then
                echo "Quitting game"
                break
        fi

        echo "You entered $userinput"
done