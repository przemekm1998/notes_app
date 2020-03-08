#!/bin/bash
# Simple note-taking script

# Help
usage() { 
    echo "Usage: $0 [-f filename] [-d directory]" 1>&2; 
    exit 1; 
    }

# Declare where to save the notes
declare notesdir="${HOME}/notes"
[[ $NOTESDIR ]] && notesdir="${NOTESDIR}"

while getopts "d::f:" args; do
    case "${args}" in
        d)
            notesdir=${OPTARG}
            ;;
        f)
            declare -r title=${OPTARG}
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
[[ ! $title ]] && { 
        usage; 
        exit 1; 
    }
  
declare -r filename="${notesdir}/${title}"

# Ask user for input
read -r -p "Your note: " note

if [[ "$note" ]]; then

    # Creating the folder for notes if not exists
    if [[ ! -d $notesdir ]]; then
        mkdir "${notesdir}" 2> /dev/null || {
            echo "Cannot make directory ${notesdir}" 1>&2;
            exit 1;
        }
    fi

    # Check if the file already exists
    if [[ ! -f $filename ]]; then
        touch "${filename}.txt" 2> /dev/null || {
            echo "Cannot create file ${filename}" 1>&2;
            exit 1;
        }
    fi

    # Check if file is writable
    [[ -w $filename ]] || {
        echo "File is not writable" 1>&2;
        exit 1;
    }

    echo "${cur_date}: ${note}" >> "$filename.txt" && echo "Note saved to: \"$filename\""
else
    echo "No input; note wasn't saved." 1>&2
    exit 2
fi