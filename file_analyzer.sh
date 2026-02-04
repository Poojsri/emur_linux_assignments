#!/bin/bash
############################################
# file_analyzer.sh
#
# Demonstrates:
# - Recursive functions
# - Redirection & error handling
# - Here document & here string
# - Special parameters
# - Regular expressions
# - getopts for CLI arguments
############################################

ERROR_LOG="errors.log"

# ---------- Error handling function ----------
error_exit() {
    local msg="$1"
    echo "ERROR: $msg" | tee -a "$ERROR_LOG" >&2
    return 1
}

# ---------- Help menu (Here Document) ----------
show_help() {
    cat <<EOF
Usage: $0 [OPTIONS]

Options:
  -d <directory>   Recursively search a directory for a keyword
  -f <file>        Search for a keyword in a specific file
  -k <keyword>     Keyword to search for
  --help           Display this help menu

Examples:
  $0 -d logs -k error
  $0 -f script.sh -k TODO
  $0 --help
EOF
}

# ---------- Recursive function ----------
recursive_search() {
    local dir="$1"
    local keyword="$2"

    for item in "$dir"/*; do
        if [[ -f "$item" ]]; then
            if grep -qi "$keyword" "$item"; then
                echo "Match found in: $item"
            fi
        elif [[ -d "$item" ]]; then
            recursive_search "$item" "$keyword"
        fi
    done
}

# ---------- Argument count check (Special parameter $#) ----------
if [[ $# -eq 0 ]]; then
    error_exit "No arguments provided. Use --help for usage."
    exit 1
fi

# ---------- Handle --help manually ----------
if [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# ---------- getopts ----------
while getopts ":d:f:k:" opt; do
    case "$opt" in
        d) DIRECTORY="$OPTARG" ;;
        f) FILE="$OPTARG" ;;
        k) KEYWORD="$OPTARG" ;;
        \?)
            error_exit "Invalid option: -$OPTARG"
            exit 1
            ;;
        :)
            error_exit "Option -$OPTARG requires an argument."
            exit 1
            ;;
    esac
done

# ---------- Input validation using regex ----------
# Keyword must not be empty and contain valid characters only
if [[ -z "$KEYWORD" || ! "$KEYWORD" =~ ^[A-Za-z0-9_-]+$ ]]; then
    error_exit "Invalid or empty keyword."
    exit 1
fi

# ---------- File search ----------
if [[ -n "$FILE" ]]; then
    if [[ ! -f "$FILE" ]]; then
        error_exit "File '$FILE' does not exist."
        exit 1
    fi

    echo "Searching for '$KEYWORD' in file '$FILE'..."

    # Here string usage
    if grep -qi "$KEYWORD" <<< "$(cat "$FILE")"; then
        echo "Keyword '$KEYWORD' found in $FILE"
    else
        echo "Keyword '$KEYWORD' not found in $FILE"
    fi

# ---------- Directory recursive search ----------
elif [[ -n "$DIRECTORY" ]]; then
    if [[ ! -d "$DIRECTORY" ]]; then
        error_exit "Directory '$DIRECTORY' does not exist."
        exit 1
    fi

    echo "Recursively searching for '$KEYWORD' in directory '$DIRECTORY'..."
    recursive_search "$DIRECTORY" "$KEYWORD"

else
    error_exit "You must specify either -d or -f."
    exit 1
fi

# ---------- Exit status ($?) ----------
if [[ $? -eq 0 ]]; then
    echo "Operation completed successfully."
else
    echo "Operation completed with errors."
fi

# ---------- Special parameters ----------
echo "Script name: $0"
echo "All arguments passed: $@"