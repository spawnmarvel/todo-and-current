variable="red"

case "$variable" in
    "red")
    echo "Var is $variable"
        # Commands for pattern 1
        ;;
    "blue" | "green")
        # You can use | for "OR" (e.g., Europe OR Asia)
        ;;
    *)
        # The wildcard * handles "Anything else" (Errors)
        ;;
esac