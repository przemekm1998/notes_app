#!/usr/bin/env bash
# Simple note-taking script

# Help
usage() {
    echo "Usage: $0 [-f filename] [-d directory]" 1>&2;
    exit 1; 
    }

error() {
    echo "$1" 1>&2;
    usage;
    exit "$2";
    }

# Declare where to save the notes
declare notesdir=${NOTESDIR:-"${HOME}/notes"}

while getopts "hd::f:" args; do
    case "${args}" in
        d)
            notesdir=${OPTARG}
            ;;
        f)
            declare -r title=${OPTARG}
            ;;
        h)
            usage
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

# Get the date
get_date=$(date)
declare -r cur_date="$get_date"

# Declare the file path
[[ ! ${title} ]] && {
        usage; 
        exit 1; 
    }
  
declare -r filename="${notesdir}/${title}"

# Ask user for input
read -r -p "Your note: " note

if [[ "$note" ]]; then

    # Creating the folder for notes if not exists
    if [[ ! -d ${notesdir} ]]; then
        mkdir "${notesdir}" 2> /dev/null || error "Cannot make directory ${notesdir}" 1
    fi

    # Check if the file already exists
    if [[ ! -f ${filename} ]]; then
        touch "${filename}.txt" 2> /dev/null || error "Cannot create file
        ${filename}" 1
    fi

    # Check if file is writable
    [[ ! -w ${filename} ]] || error "File ${filename} is not writable" 1

    echo "${cur_date}: ${note}" >> "$filename.txt" && echo "Note saved to: \"$filename\""
else
    error "No input; note wasn't saved" 2
fi