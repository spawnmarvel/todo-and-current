variable="green"

case "$variable" in
    "red")
    echo "Var red is $variable"
        # Commands for pattern 1
        ;;
    "blue" | "green")
        # You can use | for "OR" (e.g., Europe OR Asia)
        echo "Var blue or green is $variable"
        ;;
    *)
        # The wildcard * handles "Anything else" (Errors)
        echo "Unknow var $variable"
        ;;
esac

while true; do
    # 1. Clear variables (Good habit!)
    args=""

    # 2. Read from TTY
    # -r is "Raw" (prevents backslash issues)
    # The first word goes to 'cmd', EVERYTHING ELSE goes to 'args'
    read -r -p "> " args </dev/tty

    # 3. Debugging: See what happened
    echo "Full Argument: $args"

    case "$args" in
    "red")
    echo "Var red is $args"
        # Commands for pattern 1
        ;;
    "blue" | "green")
        # You can use | for "OR" (e.g., Europe OR Asia)
        echo "Var blue or green is $args"
        ;;
    *)
        # The wildcard * handles "Anything else" (Errors)
        echo "Unknow var $args"
        ;;
esac


done