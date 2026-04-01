#!/bin/bash
# --- GLOBAL VARIABLES ---
# We define these outside functions so they persist across different games.
# No '$' is used during assignment (setting the value).
player_hp=140

# --- ASSOCIATIVE ARRAY ---
# 'declare -A' creates a key-value map. This is cleaner than 20 'if' statements.
declare -A enemys
enemys[ogre]=80
enemys[demon]=105
enemys[troll]=170

# --- DICE LOGIC ---
# Why we use $(( )): This is "Arithmetic Expansion." 
# Inside $(( )), Bash treats words as variables automatically, so 'min' is the same as '$min'.
roll_dice() {
    local min=2
    echo $(( (RANDOM % 49) + min )) # Range: 2 to 50
}

use_potion() {
    local min=2
    echo $(( (RANDOM % 19) + min )) # Range: 2 to 20
}

run_game() {
    # 'local' ensures these variables don't bleed out into the rest of the script.
    local enemy_name
    local enemy_hp
    local playing=true
    local in_game

    # --- FUNCTION ARGUMENTS ($1, $2) ---
    # We check if $1 (the first argument) is NOT empty using [[ -n ]].
    # [[ ]] is modern and safer for string checks than [ ].
    if [[ -n "$1" ]]; then
        # If we passed an enemy name to the function, it's a LOADED game.
        enemy_name="$1"
        enemy_hp="$2"
        in_game=true 
        echo "... Resuming fight with $enemy_name"
    else
        # If no arguments, it's a NEW game. We reset player_hp here.
        player_hp=140 
        echo "Swish, ...showsh..bang, bang, bang!"
        echo "... You have entered the arena of the blue gate."

        # Get all keys (names) from our enemy array
        local names=("${!enemys[@]}")
        local ran=$(( RANDOM % ${#names[@]} ))
        enemy_name="${names[$ran]}"
        enemy_hp="${enemys[$enemy_name]}"
        in_game=false
    fi

    # --- THE COMBAT LOOP ---
    # We use [ ] here for a simple string comparison.
    while [ "$playing" == "true" ]; do
        
        # Why -le? It stands for "Less than or Equal to." 
        # Bash uses these instead of '<=' inside [ ] brackets.
        if [ $enemy_hp -le 0 ]; then
            echo "... $enemy_name is dead..., you win!"
            rm -f rpg_game_saved.txt # Delete save so you can't re-fight a dead boss
            playing=false
            continue # Skip to the end of the loop to exit
        fi

        if [ $player_hp -le 0 ]; then
            echo "... You are dead! The $enemy_name stands victorious."
            rm -f rpg_game_saved.txt
            playing=false
            continue
        fi

        # Logic to skip the intro text if we are mid-fight
        if [ "$in_game" == "true" ]; then
            echo "--- The fight continues! (Your HP: $player_hp | $enemy_name HP: $enemy_hp) ---"
        else
            echo "... $enemy_name has entered the arena with health $enemy_hp"
            in_game=true
        fi

        read -p "... [Game] (r)un, (a)ttack, (p)otion, (h)ealth, (s)ave: " game_input

        # --- OR LOGIC (||) ---
        # We use [[ ]] here because [ ] does not support the '||' operator easily.
        if [[ "$game_input" == "attack" || "$game_input" == "a" ]]; then
            local p_dmg=$(roll_dice)
            enemy_hp=$(( enemy_hp - p_dmg )) # Math logic
            echo "... You dealt $p_dmg damage!"

            if [ $enemy_hp -gt 0 ]; then
                local e_dmg=$(roll_dice)
                player_hp=$(( player_hp - e_dmg ))
                echo "... $enemy_name counters for $e_dmg damage!"
            fi

        elif [[ "$game_input" == "potion" || "$game_input" == "p" ]]; then
            local heal=$(use_potion)
            player_hp=$(( player_hp + heal ))
            echo "... Gulp! Healed for $heal. Your HP: $player_hp"
            
            # Penalize the player for healing mid-combat
            local e_dmg=$(roll_dice)
            player_hp=$(( player_hp - e_dmg ))
            echo "... $enemy_name hits you while you drink! Loss: $e_dmg"

        elif [[ "$game_input" == "run" || "$game_input" == "r" ]]; then
            echo "... You fled like a coward!"
            playing=false
        elif [[ "$game_input" == "health" || "$game_input" == "h" ]]; then
            # We use $ vars here because we want to READ their values to the screen.
            echo "... [Status] Your HP: $player_hp | $enemy_name HP: $enemy_hp"
        elif [[ "$game_input" == "save" || "$game_input" == "s" ]]; then
            echo "... Saving game..."
            # Save variables separated by semicolons into a text file.
            echo "$player_hp;$enemy_name;$enemy_hp" > rpg_game_saved.txt
            playing=false
        else
            echo "Invalid command."
        fi
    done
}

# --- MAIN MENU ---
echo "RPG World Fight Arena"
version=1.9
echo "Version $version"

while true; do
    read -p "Menu: (q)uit, (n)ew, (l)oad: " user_input

    # [ -z ] is "Is Zero" — checks if the user just hit Enter without typing.
    if [ -z "$user_input" ]; then continue; fi

    if [[ "$user_input" == "quit" || "$user_input" == "q" ]]; then
        echo "Quitting game"
        break
    elif [[ "$user_input" == "new" || "$user_input" == "n" ]]; then
        run_game
    elif [[ "$user_input" == "load" || "$user_input" == "l" ]]; then
        # [ -f ] checks if a FILE exists.
        if [[ -f rpg_game_saved.txt ]]; then            
            echo "Loading game..."
            # IFS is the "Separator". It tells 'read' that ';' splits our data.
            # The '<' redirects the file content into the 'read' command.
            IFS=";" read -r p_hp e_name e_hp < rpg_game_saved.txt
            player_hp=$p_hp
            run_game "$e_name" "$e_hp"
        else
            echo "No saved file found."
        fi
    else
        echo "Unknown command."
    fi
done