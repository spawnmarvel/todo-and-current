#!/bin/bash

# TODO
# add health potion just like roll dice
# make the enemy attack and use random also
# write more echo with real feel

# --- VARIABLES ---
# Rule: We use 'var=value' (no $) to ASSIGN or CHANGE a variable.
# Rule: We use '$var' to READ or ACCESS the value stored inside it.
# global vars
player_health=110

declare -A enemys
enemys[ogre]=100
enemys[demon]=120
enemys[troll]=130

roll_dice() {
 local min=2
 local max=50
 # Inside $(( )), Bash is smart enough to know you mean variables,
 # so you can omit the $ (though $min still works).
 echo $(( (RANDOM % 49) + min))
}

use_potion() {
 local min=2
 local max=20
 # Inside $(( )), Bash is smart enough to know you mean variables,
 # so you can omit the $ (though $min still works).
 echo $(( (RANDOM % 19) + min))
}

run_game() {
        echo "You have entered the area"
        local names=("${!enemys[@]}")
        local ran=$(( RANDOM % ${#enemys[@]} ))
        local enemy_name="${names[$ran]}"
        local enemy_hp="${enemys[$enemy_name]}"

        local playing=true
        while [ "$playing" == "true" ]; do
                # --- WHY [ ] vs [[ ]] ---
                # [ ] is the "Old School" way. It's picky and needs quotes around variables.
                # [[ ]] is the "Modern" way. It handles empty variables and OR/AND logic
                # much better without crashing. It is generally safer for strings.

                if [ $enemy_hp -le 0 ]; then
                 echo "$enemy_name is dead..., you win!"
                 playing=false
                 continue
                else
                 echo "You will fight $enemy_name with health $enemy_hp"
                fi

                read -p "(game) what will you do (run / r, attack / a / potion / p): " game_input

                # We use [[ ]] here because we are doing complex "OR" (||) logic.
                # Single brackets [ ] struggle with || inside them.
                if [[ "$game_input" == "attack" || "$game_input" == "a" ]]; then
                        echo "Attack $enemy_name"
                        local damage=$(roll_dice)

                        # We use enemy_hp (no $) to tell Bash WHICH variable to update.
                        # We use enemy_hp and damage (no $) inside (( )) because it's a math context.
                        enemy_hp=$(( enemy_hp - damage ))

                        if [ $enemy_hp -gt 1 ]; then
                         echo "$enemy_name lost $damage and has now $enemy_hp left"
                        fi

                        local enemy_damage=$(roll_dice)
                        player_health=$((player_health - enemy_damage ))
                        echo "$enemy_name attacked you, your health is now $player_health"

                elif [[ "$game_input" == "potion" || "$game_input" == "p" ]]; then
                        local potion=$(use_potion)
                        player_health=$((player_health + potion ))
                        echo "Potion used, you health is now $player_health"

                elif [[ "$game_input" == "run" || "$game_input" == "r" ]]; then
                        playing=false
                else
                        echo "No game command for $game_input"
                fi
        done
}

## game main
echo "RPG world"
version=1.0
echo "Version $version"

while true; do
        read -p "Enter something (type quit / q, new / n or load / l): " user_input

        # [ -z ] checks if a string is empty.
        if [ -z "$user_input" ]; then
                echo "Please type a command!"
                continue
        fi

        if [[ "$user_input" == "quit" || "$user_input" == "q" ]]; then
                echo "Quitting game"
                break
        elif [[ "$user_input" == "new" || "$user_input" == "n" ]]; then
                echo "Starting a new game"
                run_game
        else
                echo "No game command for $user_input"
        fi
done