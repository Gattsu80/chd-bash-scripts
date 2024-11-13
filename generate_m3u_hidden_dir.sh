#!/bin/bash

# Check if the input directory was provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <path_to_chd_folder>"
    exit 1
fi

# Set the CHD folder to the argument passed in
CHD_FOLDER="$1"

# Change to the .chd folder
cd "$CHD_FOLDER" || { echo "Failed to access CHD folder"; exit 1; }

# Clear any previously generated .m3u files
rm -f ./*.m3u

# Find all .chd files and group them by base game name
for file in *.chd; do
    # Check if the file has a .chd extension to avoid unintended files
    if [[ "$file" == *.chd ]]; then
        # Extract the base game name by removing "(Disc X)" and any extra suffix
        base_name=$(echo "$file" | sed -E 's/\s*\(Disc [0-9]+\).*\.chd$//' | xargs)
        
        # Append the relative path with ./.chd/ prefix to a temporary file for the game
        echo "./.chd/$file" >> "$base_name.tmp"
    fi
done

# Move each temporary file to a final .m3u file
for tmp_file in *.tmp; do
    # Rename the temporary file to .m3u and remove any trailing .chd from the base name
    m3u_file="${tmp_file%.tmp}.m3u"
    m3u_file="${m3u_file%.chd.m3u}.m3u"
    mv "$tmp_file" "$m3u_file"
    echo "Created M3U for ${m3u_file%.m3u}"
done

echo "All M3U files created successfully in $CHD_FOLDER"