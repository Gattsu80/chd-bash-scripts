#!/bin/bash

# Folder to search for files; use the current directory if none provided
TARGET_DIR="${1:-.}"

# Check if chdman is installed
if ! command -v chdman &> /dev/null
then
    echo "chdman could not be found. Please install MAME via Homebrew (brew install rom-tools)."
    exit 1
fi

# Convert function for .cue, .iso, and .gdi files
convert_to_chd() {
    local input_file="$1"
    local output_file="${input_file%.*}.chd"

    # Check if the output file already exists
    if [ -e "$output_file" ]; then
        echo "Skipping $input_file: $output_file already exists."
        return 0
    fi

    echo "Converting $input_file to $output_file..."

    # Check if input is .cue, .iso, or .gdi and set appropriate command
    if [[ "$input_file" == *.cue || "$input_file" == *.iso || "$input_file" == *.gdi ]]; then
        chdman createcd -i "$input_file" -o "$output_file"
    else
        echo "Unsupported file type: $input_file"
        return 1
    fi

    if [ $? -eq 0 ]; then
        echo "Successfully converted $input_file to $output_file."
    else
        echo "Failed to convert $input_file."
    fi
}

# Loop through each .cue, .iso, and .gdi file in the target directory
shopt -s nullglob
for file in "$TARGET_DIR"/*.{cue,iso,gdi}; do
    convert_to_chd "$file"
done

# Check if no .cue, .iso, or .gdi files were found
if [ $? -ne 0 ]; then
    echo "No .cue, .iso, or .gdi files found in $TARGET_DIR."
    exit 1
fi

shopt -u nullglob

echo "All conversions completed."
