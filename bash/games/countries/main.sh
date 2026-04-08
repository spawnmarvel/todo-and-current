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
echo "Hello $USER"
echo "Real linux commands are used, this is game for learning bash and countries."
echo "It’s not just a game about geography; it’s a CLI (Command Line Interface) Simulator."
echo "Type m for menu."

#####
# vars
#####

fly_countries_scandinavia=("Norway" "Sweden" "Denmark")
fly_countries_europe=("Albania" "Andorra" "Austria" "Belarus" "Belgium" "Bosnia and Herzegovina" "Bulgaria" "Croatia" "Cyprus" "Czech Republic" "Denmark" "Estonia" "Finland" "France" "Germany" "Greece" "Hungary" "Iceland" "Ireland" "Italy" "Kazakhstan" "Kosovo" "Latvia" "Liechtenstein" "Lithuania" "Luxembourg" "Malta" "Moldova" "Monaco" "Montenegro" "Netherlands" "North Macedonia" "Norway" "Poland" "Portugal" "Romania" "Russia" "San Marino" "Serbia" "Slovakia" "Slovenia" "Spain" "Sweden" "Switzerland" "Turkey" "Ukraine" "United Kingdom" "Vatican City")
fly_countries_asia=("Afghanistan" "Armenia" "Azerbaijan" "Bahrain" "Bangladesh" "Bhutan" "Brunei" "Cambodia" "China" "Cyprus" "Georgia" "India" "Indonesia" "Iran" "Iraq" "Israel" "Japan" "Jordan" "Kazakhstan" "Kuwait" "Kyrgyzstan" "Laos" "Lebanon" "Malaysia" "Maldives" "Mongolia" "Myanmar" "Nepal" "North Korea" "Oman" "Pakistan" "Palestine" "Philippines" "Qatar" "Saudi Arabia" "Singapore" "South Korea" "Sri Lanka" "Syria" "Taiwan" "Tajikistan" "Thailand" "Timor-Leste" "Turkey" "Turkmenistan" "United Arab Emirates" "Uzbekistan" "Vietnam" "Yemen")
fly_countries_africa=("")
fly_countries_north_america=("")
fly_countries_south_america=("")
fly_countries_antartica=("")
fly_countries_oceania=("Australia")
current_location="Norway"
current_location_world="europe" # europe, asia
# main airports,
# Hub-and-spoke network.
# By designating Turkey and Japan (Tokyo) as your "Gateways," you’ve introduced a layer of strategy.
declare -A airport_codes
airport_codes["IST"]="Turkey"
airport_codes["HND"]="Tokyo"

# learned
fun_learning() {
    echo "What did i learn making this or where did i send time debugging?"
    echo "1. bash is pickey about spaces, it needs them."
    echo "2. echo "text" >> file.txt, is silent."
    echo "3. Quoting is king."
    echo "4. function_sum(), '$1, $2' bash arguments are silent, we just provide and must code for it."
}
# menu
fun_menu() {
    printf "${BLUE} Main Airports: ${NC}"
    printf "${BLUE}%s ${NC}" "${airport_codes[@]}"
    printf "\n"
    printf "${LGREEN} Menu: (m : menu), (pwd : current location) (ls : travel alternatives), (cd destination : travel to), (q : quit). ${NC}\n"
    printf "${LGREEN} Menu: (nano text : save notebook text), (cat : open notebook). ${NC}\n"
    printf "${LGREEN} Menu: (printf : scanning full terminal). ${NC}\n"
    printf "${LGREEN} Menu (TODO): (awk destination : scanning terminal). ${NC}\n"
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

# simulate printf for full terminal and random flights
fun_full_scan_terminal() {
    # 1. Shuffle and save into a NEW array called 'current_terminal'
    # -n 10, pick 10 items
    # -e treat them as elements
    mapfile -t current_terminal < <(shuf -n 10 -e "${fly_countries_europe[@]}")

    for country in "${current_terminal[@]}"; do
        # %-20s = The country name, padded to 20 spaces
        # \n = MOVE TO NEXT LINE (Very important!)
        printf " * %-20s [BOOK NOW]\n" "$country"
    done
    printf " * %-20s [BOOK NOW] Main airport \n" "${fly_countries_europe[44]}"

}

# simulate awk for scanning terminal
fun_scan_terminal() {
    echo "TBD"
}

# helper ls to format array
fun_format_array() {
    local -n fly_countries_arr="$1"
    local c=0

    for country in "${fly_countries_arr[@]}"; do
        #  %-22s creates a fixed-width column of 22 characters
        # The minus sign aligns the text to the LEFT
        printf " %-22s" "$country"
        ((c++))
        if [[ "$c" -eq 4 ]]; then
            printf "\n"
            c=0
        fi
    done
    printf "\n"
}
# simulate ls to list where we can fly
fun_check_countries_from_location() {
    local c=0

    if [[ "$current_location_world" == "europe" && "$current_location" != "${airport_codes[IST]}" ]]; then
        # flights in europe
        printf "${LGREEN} * * Flights in europe, avaliable at your location: ${NC}\n"
        fun_format_array fly_countries_europe

    elif [[ "$current_location_world" == "europe" && "$current_location" = "${airport_codes[IST]}" ]]; then
        # flights in europe and asia
        printf "${LGREEN} * * Flights in europe: ${NC}\n"
        fun_format_array fly_countries_europe
        printf "${LGREEN} * * Flights in asia, since you are at airport ${airport_codes[IST]} ${NC}\n"
        fun_format_array fly_countries_asia

    elif [[ "$current_location_world" = "asia" ]]; then
        # flights in europe
        printf "${LGREEN} * * Flights in asia: ${NC}\n"
        fun_format_array fly_countries_asia
    else
        echo "TODO"
    fi

}

# check what country we are in an set location world
# some place may overlap, like our starting point scandinavia
fun_verify_continents_flights() {
    flight_possibilities=""

    # 1. gateway instanbul (bridge asia and europe)
    if [[ "$current_location" == "${airport_codes[IST]}" ]]; then
        flight_possibilities="europe;asia"

    # 2. gateway tokyo (bridge asia and europe)
    elif [[ "$current_location" == "${airport_codes[HND]}" ]]; then
        flight_possibilities="europe;asia"

    elif [[ "$current_location_world" == "europe" ]]; then
        flight_possibilities="europe"

    elif [[ "$current_location_world" == "asia" ]]; then
        flight_possibilities="asia"

    else
        flight_possibilities="unknown"
    fi
    echo "$flight_possibilities"

}

#####
## simulate cd move loop
#####
fun_destination_move() {

    local move_to_destination="$1"
    local can_fly=false
    local possibilities=""
    local new_continent=""
    # --- FUNCTION ARGUMENTS ($1) ---
    # We check if $1 (the first argument) is NOT empty using [[ -n ]].
    # [[ ]] is modern and safer for string checks than [ ].
    if [[ -n "$1" ]]; then

        echo "Checking destination $move_to_destination"
        possibilities=$(fun_verify_continents_flights)
        echo "All destinations: $possibilities"

        # splitt the string
        IFS=";" read -ra continents <<<"$possibilities"
        count=${#continents[@]}
        # echo "Current continent: ${continents[*]}"
        # echo "Total count: $count"

        # Loop through every continent found in your 'continents' array
        # echo "Check if multiple continents or single."
        for region in "${continents[@]}"; do

            if [[ "$region" == "europe" ]]; then
                for c in "${fly_countries_europe[@]}"; do
                    # lowercase trick{c,,}
                    if [[ "$move_to_destination" == "${c,,}" ]]; then
                        can_fly=true
                        new_continent="$region"
                        break 2
                    fi
                done
            elif [[ "$region" == "asia" ]]; then
                for c in "${fly_countries_asia[@]}"; do
                    if [[ "$move_to_destination" == "${c,,}" ]]; then
                        can_fly=true
                        new_continent="$region"
                        break 2
                    fi
                done
            else
                echo "Change world location"
            fi
            # done with region
        done
        ####
        # You are in the air
        ###
        if [[ "$can_fly" == true ]]; then
            if [[ "$1" == "$current_location" ]]; then
                echo "Domestic flight is not supported? You are in $current_location"

            else
                echo "You are flying to $move_to_destination"
                # Loop 10 times to move the dot 10 spaces
                for i in {1..10}; do
                    # 1. \r jumps to the start of the line
                    # 2. %*s prints 'i' number of spaces
                    # 3. Then we print the dot
                    printf "\r%*s==++>" $i ""

                    # Wait a tiny bit (0.1 seconds) so we can see it move
                    sleep 0.1
                done
                current_location="$move_to_destination"
                current_location_world="$new_continent"

                # This prints a newline and then your text
                printf "\n${BLUE}Landed safely in $current_location! ${NC}\n"
                # fun_verify_continents_flights "$current_location"
            fi
        else
            echo "Error unknow destination: $move_to_destination."
            echo "Type ls to see where you can fly to."
        fi

    else
        echo "Error missing destination parameter"
    fi
}
#####
## The main entry loop
#####
# Change this full loop to a case statment
####
while true; do
    # 1. Clear variables
    cmd=""
    args=""

    # 2. Read from TTY
    read -p "> " cmd args </dev/tty

    # 3. Clean and lowercase (using xargs to trim any weird spaces)
    user_input=$(echo "${cmd,,}" | xargs)
    # We use "$args" in quotes to handle multi-word countries like "United Kingdom"
    args=$(echo "$args" | xargs)

    # 4. [ -z ] is "Is Zero" — checks if the user just hit Enter without typing.
    if [ -z "$user_input" ]; then
        echo "Please type m for menu if need to see commands."
        continue
    fi

    case "$user_input" in
    "m")
        fun_menu
        ;;
    "q" | "quit")
        echo "Quitting Countries"
        fun_learning
        break
        ;;
    "ls")
        fun_check_countries_from_location
        ;;
    "pwd")
        echo "You are in $current_location in $current_location_world"
        ;;
    "cd")
        # [ -z ] is "Is Zero" — checks if the user just hit Enter without typing.
        if [ -z "$args" ]; then
            echo "No input for destination"
        else
            fun_destination_move "$args"
        fi
        ;;
    "nano")
        # [ -z ] is "Is Zero" — checks if the user just hit Enter without typing.
        if [ -z "$args" ]; then
            echo "No input to notebook"
        else
            fun_save_notebook "$args"
        fi
        ;;
    "cat")
        fun_open_notebook
        ;;

    "printf")
        fun_full_scan_terminal
        ;;

    *)
        # The wildcard * handles "Anything else" (Errors)
        echo "Unknown cmd: $cmd or Unknown args: $args"
        ;;
    esac

done
