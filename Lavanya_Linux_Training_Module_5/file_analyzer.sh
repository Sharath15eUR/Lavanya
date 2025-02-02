#!/bin/bash

# Initialize variables
DIRECTORY=""
KEYWORD=""
FILE=""
ERROR_LOG="errors.log"

# Function to display help menu using here document
display_help() {
    cat << EOF
Usage: $0 [options]

Options:
  -d <directory>   Directory to search recursively for the keyword.
  -k <keyword>     Keyword to search for in files.
  -f <file>        Search for the keyword in a specific file.
  --help           Display this help message.

Example usage:
  $0 -d logs -k error        # Recursively search for "error" in the "logs" directory.
  $0 -f script.sh -k TODO    # Search for "TODO" in "script.sh" file.
EOF
}

# Recursive function to search for files containing the keyword
search_files() {
    local dir="$1"
    local keyword="$2"
    local file
    for file in "$dir"/*; do
        if [ -d "$file" ]; then
            # Recursively search subdirectories
            search_files "$file" "$keyword"
        elif [ -f "$file" ]; then
            if grep -q "$keyword" "$file"; then
                echo "Found '$keyword' in: $file"
            fi
        fi
    done
}

# Function to search for a keyword in a file using here string
search_in_file() {
    local file="$1"
    local keyword="$2"
    if [[ -f "$file" ]]; then
        grep -Hn -- "$keyword" <<< "$file"
    else
        echo "Error: File '$file' not found." >> "$ERROR_LOG"
        echo "Error: File '$file' not found."
    fi
}

# Function to validate inputs using regular expressions
validate_inputs() {
    if [[ ! "$KEYWORD" =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Error: Invalid keyword. It should only contain alphanumeric characters and underscores." >> "$ERROR_LOG"
        echo "Error: Invalid keyword. It should only contain alphanumeric characters and underscores."
        exit 1
    fi
    if [[ ! -z "$DIRECTORY" && ! -d "$DIRECTORY" ]]; then
        echo "Error: Directory '$DIRECTORY' does not exist." >> "$ERROR_LOG"
        echo "Error: Directory '$DIRECTORY' does not exist."
        exit 1
    fi
    if [[ ! -z "$FILE" && ! -f "$FILE" ]]; then
        echo "Error: File '$FILE' does not exist." >> "$ERROR_LOG"
        echo "Error: File '$FILE' does not exist."
        exit 1
    fi
}

# Handle command-line arguments using getopts
while getopts ":d:k:f:" opt; do
    case $opt in
        d)
            DIRECTORY="$OPTARG"
            ;;
        k)
            KEYWORD="$OPTARG"
            ;;
        f)
            FILE="$OPTARG"
            ;;
        *)
            display_help
            exit 1
            ;;
    esac
done

# Display help if --help is passed
if [[ "$1" == "--help" ]]; then
    display_help
    exit 0
fi

# Validate inputs before proceeding
validate_inputs

# Perform the search operations
if [[ -n "$DIRECTORY" ]]; then
    if [[ -n "$KEYWORD" ]]; then
        search_files "$DIRECTORY" "$KEYWORD"
    else
        echo "Error: Keyword is missing for the directory search." >> "$ERROR_LOG"
        echo "Error: Keyword is missing for the directory search."
        exit 1
    fi
fi

if [[ -n "$FILE" ]]; then
    if [[ -n "$KEYWORD" ]]; then
        search_in_file "$FILE" "$KEYWORD"
    else
        echo "Error: Keyword is missing for the file search." >> "$ERROR_LOG"
        echo "Error: Keyword is missing for the file search."
        exit 1
    fi
fi

# Output for special parameters
echo "Script name: $0"
echo "Number of arguments: $#"
echo "Arguments passed: $@"
echo "Exit status of the last command: $?"
