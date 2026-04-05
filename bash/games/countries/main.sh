#!/bin/bash

####
# colors
####

RED='\e[31m'
BLUE='\e[34m'
LGREEN='\e[1;32m'
NC='\e[0m' # No Color (Reset) last line or after current line

####
# start
####

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
echo "You might be stopped by customs or other's on your travel, take notes if needed."
echo "As you travel, you can store notes in your notebook, you might need them for later."
echo ""
echo "Real linux commands are used so this is game for learning bash and countries."
echo "It’s not just a game about geography; it’s a CLI (Command Line Interface) Simulator."
echo "Type m for menu."

#####
# vars
#####

fly_countries_scandinavia=("Norway" "Sweden" "Denmark")
fly_countries_europe=("Albania" "Andorra" "Austria" "Belarus" "Belgium" "Bosnia and Herzegovina" "Bulgaria" "Croatia" "Cyprus" "Czech Republic" "Denmark" "Estonia" "Finland" "France" "Germany" "Greece" "Hungary" "Iceland" "Ireland" "Italy" "Kazakhstan" "Kosovo" "Latvia" "Liechtenstein" "Lithuania" "Luxembourg" "Malta" "Moldova" "Monaco" "Montenegro" "Netherlands" "North Macedonia" "Norway" "Poland" "Portugal" "Romania" "Russia" "San Marino" "Serbia" "Slovakia" "Slovenia" "Spain" "Sweden" "Switzerland" "Turkey" "Ukraine" "United Kingdom" "Vatican City")
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
    echo "3. Quoting is king."
    echo "4. function_sum(), $1, $2 bash arguments are silent, we just provide and must code for it."
}
# menu
fun_menu() {
    printf "${LGREEN} Menu: (ls : look), (cd destination : travel), (pwd : current location) (q : quit), (m : menu). ${NC}\n"
    printf "${LGREEN} Menu: (nano text : save notebook text), (cat : open notebook TODO). ${NC}\n"
    printf "${LGREEN} Menu (TODO): (awk destination : scanning terminal). ${NC}\n"
    printf "${LGREEN} Menu (TODO): (printf : scanning full terminal). ${NC}\n"
}
# simulate nano with args 1 contaning all text
fun_save_notebook() {
    local note="$1"
    # --- FUNCTION ARGUMENTS ($1) ---
    # We check if $1 (the first argument) is NOT empty using [[ -n ]].

    if [[ -n "$note" ]]; then
        note="$1"
        echo "$(date) ; "$current_location" ; $note" >>saved_notebook.txt
        echo "Saved: $note to your notebook."

    else
        echo "Error: What do you want to write? (Usage: s 'your note here')"
    fi
}
# simulate cat with no args
fun_open_notebook() {
    local notebook="saved_notebook.txt"
    # We check if the notebook is NOT empty using [[ -n ]].
    if [[ ! -f "$notebook" ]]; then
        echo "Your notebook is empty, travel more to fill it up"
        return
    fi

    while IFS=";" read -r note_time note_location note_saved; do
        echo "$note_time $note_location $note_saved"
        sleep 0.1
    done <"$notebook"
}

fun_countries_from_location() {
    # if location is denmark
    ## fly_countries_europe
    ## elif
    echo "Looking for flights from home:"
    echo "${fly_countries_scandinavia[@]}"

}

# use printf to pretty print terminal
fun_full_scan_terminal() {
    # S1 get current_location
    echo "Test"
    # IFS open file to that location
    # printf cool
}

# simulate awk for scanning terminal
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
        echo "traveling to $move_to_destination"
        for c in "${fly_countries_scandinavia[@]}"; do
            if [[ "$1" == "$c" ]]; then
                can_fly=true
                break
            fi
        done
        if [[ "$can_fly" == true ]]; then
            if [[ "$1" == "$current_location" ]]; then
                echo "Domestic flight is not supported? You are in $current_location"

            else
                echo "You are flying to $1"
                # Loop 20 times to move the dot 20 spaces
                for i in {1..20}; do
                    # 1. \r jumps to the start of the line
                    # 2. %*s prints 'i' number of spaces
                    # 3. Then we print the dot
                    printf "\r%*s==++>" $i ""

                    # Wait a tiny bit (0.1 seconds) so we can see it move
                    sleep 0.1
                done
                current_location="$1"
                # This prints a newline and then your text
                printf "\n${BLUE}Landed safely in $current_location! ${NC}\n"
            fi
        else
            echo "Error unknow destination: $1."
            echo "Type ls to see where you can fly to."
        fi
    else
        echo "Error missing destination parameter"
    fi
}
#####
## The main entry loop
#####
while true; do
    # 1. Clear variables
    cmd=""
    args=""

    # 2. Read from TTY
    read -p "> " cmd args </dev/tty

    # 3. Clean and lowercase (using xargs to trim any weird spaces)
    user_input=$(echo "${cmd,,}" | xargs)
    # [ -z ] is "Is Zero" — checks if the user just hit Enter without typing.
    if [ -z "$user_input" ]; then
        echo "Please type m for menu if need to see commands."
        continue
    fi

    if [[ "$user_input" == "q" ]]; then
        echo "Quitting Capitals"
        fun_learning
        break

    elif [[ "$user_input" == "nano" ]]; then
        # [ -z ] is "Is Zero" — checks if the user just hit Enter without typing.
        if [ -z "$args" ]; then
            echo "No input to notebook"
        else
            fun_save_notebook "$args"
        fi

    elif [[ "$user_input" == "cat" ]]; then
        echo "cat open"
        fun_open_notebook

    elif [[ "$user_input" == "m" ]]; then
        fun_menu

    elif [[ "$user_input" == "ls" ]]; then
        fun_countries_from_location

    elif [[ "$user_input" == "pwd" ]]; then
        echo "$current_location in $current_location_world"

    elif [[ "$user_input" == "cd" ]]; then
        # [ -z ] is "Is Zero" — checks if the user just hit Enter without typing.
        if [ -z "$args" ]; then
            echo "No input for destination"
        else
            fun_destination_move "$args"
        fi

    else
        echo "Unknown command."
    fi
done
