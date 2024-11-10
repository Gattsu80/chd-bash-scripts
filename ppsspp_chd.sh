#!/bin/bash

# Check if chdman is installed
if ! command -v chdman &> /dev/null; then
    echo "chdman is not installed. Please install it first."
    exit 1
fi

# Check for input arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_directory>"
    exit 1
fi

INPUT_DIR=$1
OUTPUT_DIR=$1  # Set output directory to the same as input directory

# Iterate over all ISO and BIN files in the input directory
for FILE in "$INPUT_DIR"/*.{iso,bin}; do
    if [ -f "$FILE" ]; then
        FILENAME=$(basename -- "$FILE")
        EXTENSION="${FILENAME##*.}"
        BASENAME="${FILENAME%.*}"

        # Generate the output CHD filename
        OUTPUT_CHD="$OUTPUT_DIR/${BASENAME}.chd"

        # Convert ISO or BIN/CUE to CHD
        if [ "$EXTENSION" == "iso" ]; then
            chdman createdvd -hs 2048 -c zstd,zlib,huff,flac -i "$FILE" -o "$OUTPUT_CHD"
        elif [ "$EXTENSION" == "bin" ]; then
            CUE_FILE="$INPUT_DIR/${BASENAME}.cue"
            if [ ! -f "$CUE_FILE" ]; then
                echo "CUE file corresponding to $FILE not found. Skipping."
                continue
            fi
            chdman createdvd -hs 2048 -c zstd,zlib,huff,flac -i "$CUE_FILE" -o "$OUTPUT_CHD"
        else
            echo "Unsupported file type: $FILE. Skipping."
            continue
        fi

        # Check if the conversion was successful
        if [ $? -eq 0 ]; then
            echo "Conversion completed successfully for $FILE! The CHD file is located at $OUTPUT_CHD"
        else
            echo "Conversion failed for $FILE. Please check the input file and try again."
        fi
    fi
done
