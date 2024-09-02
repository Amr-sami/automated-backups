# Backup Script

## Overview
The `backup.sh` script is a simple and efficient tool designed to back up files from a specified target directory to a destination directory. It only backs up files that have been modified within the last 24 hours, compresses them into a `.tar.gz` archive, and moves the archive to the destination directory.

## How It Works
1. **Argument Check**: The script ensures that exactly two arguments are provided: the target directory and the destination directory.
   
2. **Directory Validation**: It validates that both arguments are valid directory paths.

3. **Timestamp Generation**: The script generates a timestamp and uses it to create a unique backup file name.

4. **File Modification Check**: It checks which files in the target directory have been modified in the last 24 hours.

5. **Compression and Archiving**: The script compresses and archives the modified files into a `.tar.gz` file.

6. **Move to Destination**: Finally, the script moves the backup file to the destination directory.
