#!/bin/bash

#functions

player_health=100
player_attack=40

run_game() {
        # clear the screen from old cmds
        clear
        echo "You have entred the area"
        local playing=true
        while [ "$playing" == "true" ]; do
                # game loop
                read -p "(game) what will you do (return, attack): " game_input
                if [ "$game_input" == "attack" ]; then
                        echo "Attack troll"
                elif [ "$game_input" == "return" ]; then
                        playing=false
                else
                        echo "No game command for $game_input"
                fi
        done
}
echo "RPG world"
version=1.0
echo "Version $version"

# game loop
while true; do
        read -p "Enter something (type quit, new or load): " user_input
        if [ -z "$user_input" ]; then
                echo "Please type a command!"
                continue # Skips the rest of the loop and starts over
        fi

        if [ "$user_input" == "quit" ]; then
                echo "Quitting game"
                break
        elif [ "$user_input" == "new" ]; then
                echo "Starting a new game"
                run_game
        else
                echo "No game command for $user_input"
        fi

        echo "You entered $user_input"
done