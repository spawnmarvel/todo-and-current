#!/bin/bash

#### vars

RED='\e[31m'
LGREEN='\e[1;32m'
NC='\e[0m' # No Color (Reset) last line or after current line

echo ""
echo "########"
# The first argument is the "Format", the others are the "Data"
printf "${LGREEN}Countries\n"

printf "${LGREEN}Inspired by https://web.mit.edu/mprat/Public/web/Terminus/Web/main.html \n"
version=1.2
printf "${LGREEN}Version $version ${NC}\n"
echo "########"
echo ""
echo "Fly to countries from home."
echo "It might not be direct flights to your destination, then select a valid destination."
echo "You might be stopped by customs or other's on your travell, take notes if needed."
echo "As you travell, you can store notes in your notebook, you might need them for later."
echo ""
echo "Real linux commands are used so this is game for learning bash and countries."
echo "It’s not just a game about geography; it’s a CLI (Command Line Interface) Simulator."
echo "Type m for menu."

fly_countries_scandinavia=("Norway" "Sweden" "Denmark")
fly_countries_europe=("") # read txt file and fill array
fly_countries_asia=("")
fly_countries_africa=("")
fly_countries_north_america=("")
fly_countries_south_america=("")
fly_countries_antartica=("")
fly_countries_oceania=("Australia")
current_location="Norway"
current_location_world="scandinava"

# learned
fun_learning() {
    echo "What did i learn making this or where did i send time debugging?"
    echo "1. bash is pickey about spaces, it needs them."
    echo "2. echo "text" >> file.txt, is silent."
}
# menu
fun_menu() {
    printf "${LGREEN} Menu: (ls : look), (cd destination : travell), (pwd : current location) (q : quit), (m : menu). ${NC}\n"
    printf "${LGREEN} Menu: (nano text : save notebook text), (cat : open notebook TODO). ${NC}\n"
    printf "${LGREEN} Menu (TODO): (awk destination : scanning terminal). ${NC}\n"
    printf "${LGREEN} Menu (TODO): (printf : scanning full terminal). ${NC}\n"
}
# save nano
fun_save_notebook() {
    local note
    # --- FUNCTION ARGUMENTS ($1) ---
    # We check if $1 (the first argument) is NOT empty using [[ -n ]].
    # [[ ]] is modern and safer for string checks than [ ].

    if [[ -n "$1" ]]; then
        note=$1
        echo "$(date) ; $note" >>saved_notebook.txt
        echo "Saved: Note $note"

    else
        echo "Missing note"
    fi
}
# open cat TODO
fun_open_notebook() {
    echo "Must implement open notebook"
}
fun_countries_scandinavia() {
    echo "Looking for flights from home:"
    echo "${fly_countries_scandinavia[@]}"

}

# ISF TODO
fun_full_scan_terminal() {
    # S1 get current_location
    echo "Test"
    # IFS open file to that location
    # printf cool
}

# AWK TODO
fun_scan_terminal() {
    # get current location
    # get current file
    # get destination and time
    awk '{print $3}' europe.txt
    # Output: Norway 11:25
}

#####
## The c move loop
#####
fun_destination_move() {
    local move_to_destination
    local can_fly=false
    # --- FUNCTION ARGUMENTS ($1) ---
    # We check if $1 (the first argument) is NOT empty using [[ -n ]].
    # [[ ]] is modern and safer for string checks than [ ].
    if [[ -n "$1" ]]; then
        move_to_destination=$1
        echo "Travelling to $move_to_destination"
        for c in "${fly_countries_scandinavia[@]}"; do
            if [[ "$1" == "$c" ]]; then
                can_fly=true
                break
            fi
        done
        if [[ "$can_fly" == true ]]; then
            if [[ "$1" == "Norway" ]]; then
                echo "Domestic flight? You are in norway"
            fi
            echo "You are flying to $1"
            current_location="$1"
        else
            echo "You can not fly to $1. It is not possible from where you are"
            echo "Mabye dived up the flights, there are more flights from Denmark for example"
        fi
    else
        echo "Missing destination"
    fi
}
#####
## The main entry loop
#####
while true; do
    # 1. Clear variables
    tmp_user_input_args1=""
    tmp_user_input_args2=""

    # 2. Read from TTY
    read -p "> " tmp_user_input_args1 tmp_user_input_args2 </dev/tty

    # 3. Clean and lowercase (using xargs to trim any weird spaces)
    user_input=$(echo "${tmp_user_input_args1,,}" | xargs)
    # [ -z ] is "Is Zero" — checks if the user just hit Enter without typing.
    if [ -z "$user_input" ]; then
        continue
    fi

    if [[ "$user_input" == "q" ]]; then
        echo "Quitting Capitals"
        fun_learning
        break

    elif [[ "$user_input" == "nano" ]]; then
        # [ -z ] is "Is Zero" — checks if the user just hit Enter without typing.
        if [ -z "$tmp_user_input_args2" ]; then
            echo "No input to notebook"
        else
            fun_save_notebook "$tmp_user_input_args2"
        fi

    elif [[ "$user_input" == "cat" ]]; then
        fun_open_notebook

    elif [[ "$user_input" == "m" ]]; then
        fun_menu

    elif [[ "$user_input" == "ls" ]]; then
        fun_countries_scandinavia

    elif [[ "$user_input" == "pwd" ]]; then
        echo "$current_location in $current_location_world"

    elif [[ "$user_input" == "cd" ]]; then
        # [ -z ] is "Is Zero" — checks if the user just hit Enter without typing.
        if [ -z "$tmp_user_input_args2" ]; then
            echo "No input for destination"
        else
            fun_destination_move "$tmp_user_input_args2"
        fi

    else
        echo "Unknown command."
    fi
done
