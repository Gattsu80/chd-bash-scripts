# cue_bin_iso_gdi_to_chd

## Overview
This Bash script automates the process of converting `.cue`, `.iso`, and `.gdi` disc image files to the CHD (Compressed Hunks of Data) format using `chdman`. It is designed to search for and convert all applicable files within a specified directory or, by default, the current directory.

## Prerequisites
- Ensure that `chdman` is installed on your system. `chdman` is part of the MAME tools package.
- macOS users can install MAME tools using Homebrew:

  ```bash
  brew install rom-tools
  ```

## Usage
### Make Executable
  ```bash
  chmod +x cue_iso_gdi_to_chd.sh
  ```
### Basic Command
```bash
./cue_iso_gdi_to_chd.sh [TARGET_DIR]
```
- **`TARGET_DIR`**: (Optional) The folder to search for `.cue`, `.iso`, and `.gdi` files. If not specified, the script will use the current directory (`.`) by default. The output directory is the same is the input directory.

### Example
```bash
./cue_iso_gdi_to_chd.sh /path/to/your/files
```
This command will convert all `.cue`, `.iso`, and `.gdi` files in `/path/to/your/files` to the CHD format. If you are trying to convert atomiswave gdi please use the atomiswave script.

## Script Details
1. **Directory Check**: The script checks if a directory is specified; otherwise, it defaults to the current directory.
2. **`chdman` Check**: Verifies that `chdman` is installed and available in the system's `PATH`.
3. **File Conversion**: The script processes `.cue`, `.iso`, and `.gdi` files, converting each to a `.chd` file.
4. **Existing Output Check**: Skips conversion if a `.chd` file with the same name already exists.
5. **Completion Message**: Outputs a success or failure message for each file and a summary at the end.

## Script Behavior
- If no compatible files are found in the target directory, the script will display an appropriate message and exit.
- If an output `.chd` file already exists for an input, the script will skip that file and move to the next.

## Exit Codes
- `0`: Successful execution.
- `1`: `chdman` is not found, or no valid files are available for conversion.

## Sample Output
```bash
Converting game.iso to game.chd...
Successfully converted game.iso to game.chd.
Skipping existing_file.cue: existing_file.chd already exists.
No .cue, .iso, or .gdi files found in /path/to/your/files.
All conversions completed.
```

## Notes
- Ensure that your source `.cue`, `.iso`, or `.gdi` files are in the target directory specified and working before converting. Also that the emulator you are usig supports `.chd`.
- The `shopt -s nullglob` line ensures that no error occurs if no matching files are found.

## License
This script is provided as-is without any warranty. Feel free to modify and use it as needed.



# atomiswave_gdi_to_chd

Atomiswave for Dreamcast often come as gdi that point to iso track files rather than `.raw` and `.bin`. Use this script for those.

Usage is same as above just a diffent `.sh` name.



# ppsspp_to_chd

Use this script for PSP as they require a specific conversion method/options or PPSSPP will complain.

Usage is same as above just a diffent `.sh` name.



# generate_m3u

## Overview
This Bash script automates the creation of `.m3u` playlist files from `.chd` files in a specified directory. It is useful for organizing multi-disc CHD games into M3U playlists for easier access in compatible emulators.

## Prerequisites
- A directory containing `.chd` files that represent game discs.
- Basic familiarity with executing shell scripts.

## Usage
### Make Executable
  ```bash
  chmod +x generate_m3u.sh
  ```
### Command
```bash
./generate_m3u.sh /path/to/chd_folder
```
- **`/path/to/chd_folder`**: The path to the folder that contains the `.chd` files. This path must be provided when running the script.

### Example
```bash
./generate_m3u.sh /games/chd_collection
```
This command will process all `.chd` files in the `/games/chd_collection` directory and generate corresponding `.m3u` files.

## Script Details
1. **Path Verification**: The script checks if a path is provided as an argument and ensures the specified directory exists.
2. **Navigation**: It navigates to the target directory containing the `.chd` files.
3. **Cleanup**: Any existing `.m3u` files in the directory are removed to prevent duplication.
4. **File Grouping**: The script identifies `.chd` files and groups them by their base game names (ignoring disc numbers).
5. **Temporary File Creation**: A temporary `.tmp` file is created for each game grouping.
6. **M3U File Creation**: The temporary files are renamed to `.m3u` files and cleaned up.

## Script Behavior
- The script uses `sed` and `xargs` to extract and clean the base game names, removing patterns like `(Disc X)` from filenames.
- It generates M3U playlists that include paths to the `.chd` files for each grouped game.
- If no `.chd` files are found, the script completes without generating any M3U files.

## Output
- Each `.m3u` file created corresponds to a multi-disc game, with entries pointing to the respective `.chd` files.
- A success message will be printed upon completion:

  ```
  Created M3U for GameName
  All M3U files created successfully in /path/to/chd_folder
  ```

## Example Output
If the folder `/games/chd_collection` contains:
```
Game (Disc 1).chd
Game (Disc 2).chd
Game2 (Disc 1).chd
```
The script will create:
```
Game.m3u
Game2.m3u
```
Each `.m3u` file will list paths to the corresponding `.chd` files:

**`Game.m3u`**
```
./Game (Disc 1).chd
./Game (Disc 2).chd
```

**`Game2.m3u`**
```
./Game2 (Disc 1).chd
```

## Notes
- Ensure that all `.chd` files follow a consistent naming convention for proper grouping.
- The script removes any `.tmp` files it creates, leaving only the final `.m3u` files.
- The script will display an error message if the provided directory does not exist or if no path is provided.

## License
This script is provided as-is without any warranty. You may modify and distribute it as needed.

---
For more information about CHD files and M3U playlists, refer to the appropriate emulator documentation.



# generate_m3u_hidden_dir

This is the same as the above but the `.m3u` will contain the chd directory as:

```
./.chd/Game.chd
```

This can be handy as a directory starting with `.` is hidden by defaut. This way you can hide `.chd` from the emulator and only scan m3u to avoid duplicates.