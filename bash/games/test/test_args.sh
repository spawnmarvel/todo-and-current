while true; do
    # 1. Clear variables (Good habit!)
    cmd=""
    args=""

    # 2. Read from TTY
    # -r is "Raw" (prevents backslash issues)
    # The first word goes to 'cmd', EVERYTHING ELSE goes to 'args'
    read -r -p "> " cmd args </dev/tty

    # 3. Debugging: See what happened
    echo "Command: $cmd"
    echo "Full Argument: $args"

    if [[ "$cmd" == "q" ]]; then break; fi
done
