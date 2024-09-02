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

7. 1. Argument Validation

# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]
then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi
Purpose: This block checks if the script is called with exactly two arguments. If not, it prints a usage message and exits the script.
$#: This variable represents the number of arguments passed to the script.
[[ $# != 2 ]]: Checks if the number of arguments is not equal to 2.
exit: Stops the execution of the script if the condition is met.

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi
Purpose: This block verifies that the two provided arguments are valid directory paths. If either is not a valid directory, the script prints an error message and exits.
-d $1: Checks if the first argument is a valid directory.
-d $2: Checks if the second argument is a valid directory.
!: Negates the condition, meaning if the argument is not a directory, the condition is true.
||: Logical OR; if either of the conditions is true, the script will exit.
2. Setting Up Variables

# [TASK 1]
targetDirectory=$1
destinationDirectory=$2
Purpose: Assigns the first argument to the variable targetDirectory and the second argument to destinationDirectory.
$1 and $2: These represent the first and second command-line arguments, respectively.

# [TASK 2]
echo "Target Directory: $targetDirectory"
echo "Destination Directory: $destinationDirectory"
Purpose: Prints out the target and destination directory paths to the console for confirmation. This helps the user verify that the correct directories are being used.

# [TASK 3]
currentTS=$(date +%s)
Purpose: Captures the current timestamp (in seconds since the Unix epoch) and stores it in the variable currentTS. This timestamp will be used to generate a unique name for the backup file.
date +%s: The date command with the +%s option returns the current time in seconds since 00:00:00 UTC on January 1, 1970.

# [TASK 4]
backupFileName="backup-${currentTS}.tar.gz"
Purpose: Creates a unique name for the backup archive using the current timestamp. This ensures that each backup file has a unique name, preventing overwrites.
backup-${currentTS}.tar.gz: The backup file name includes the timestamp to ensure uniqueness.
3. Preparing for Backup

# [TASK 5]
origAbsPath=$(pwd)
Purpose: Stores the absolute path of the current working directory in origAbsPath. This allows the script to return to this directory later if needed.
pwd: The pwd command returns the absolute path of the current directory.

# [TASK 6]
cd "$destinationDirectory"
destAbsPath=$(pwd)
Purpose: Changes the current directory to the destination directory (destinationDirectory) and stores its absolute path in the variable destAbsPath.
cd: Changes the current working directory to the specified directory.
pwd: Captures the absolute path of the destination directory.

# [TASK 7]
cd "$origAbsPath"
cd "$targetDirectory"
Purpose: Returns to the original directory (origAbsPath) and then changes to the target directory (targetDirectory). This prepares the script to work with the files in the target directory.
4. Identifying Files for Backup

# [TASK 8]
yesterdayTS=$(($currentTS - 24 * 60 * 60))
Purpose: Calculates the timestamp for exactly 24 hours before the current time and stores it in yesterdayTS. This timestamp is used to determine which files have been modified in the last 24 hours.
24 * 60 * 60: This expression calculates the number of seconds in 24 hours (86,400 seconds).
$currentTS - 24 * 60 * 60: Subtracts 24 hours' worth of seconds from the current timestamp.

declare -a toBackup
Purpose: Declares an array named toBackup to store the names of files that need to be backed up. An array allows the script to manage a list of files.

# [TASK 9] - Find all files and directories in the current folder
for file in $(ls); do
Purpose: Iterates over each file and directory in the target directory using the ls command.
$(ls): The ls command lists all files and directories in the current directory. The $(...) syntax executes the command and returns its output as a list.

  # [TASK 10] - Check if the file was modified in the last 24 hours
  if [[ $(date -r $file +%s) > $yesterdayTS ]]; then
Purpose: Checks if each file was modified within the last 24 hours by comparing its last modification time to yesterdayTS.
date -r $file +%s: Returns the last modified timestamp of the file in seconds since the Unix epoch.
> $yesterdayTS: The condition checks if the file’s last modification time is greater than yesterdayTS (i.e., within the last 24 hours).

    # [TASK 11] - Add the file to the toBackup array
    toBackup+=($file)
  fi
done
Purpose: If the file was modified within the last 24 hours, it is added to the toBackup array.
5. Creating and Moving the Backup File

# [TASK 12] - Compress and archive the files
if [ ${#toBackup[@]} -eq 0 ]; then
  echo "No files were modified in the last 24 hours. No backup created."
else
  tar -czvf "$backupFileName" "${toBackup[@]}"
  echo "Backup created successfully: $backupFileName"
Purpose: Compresses and archives the files listed in the toBackup array into a single .tar.gz file if any files were modified. If no files were modified, the script prints a message and does not create a backup.
tar -czvf "$backupFileName" "${toBackup[@]}":
-c: Create a new archive.
-z: Compress the archive using gzip.
-v: Verbose mode, which lists the files being added to the archive.
-f "$backupFileName": Specifies the name of the archive file.
${toBackup[@]}: Expands the toBackup array into a list of files, which are then added to the archive.

  # [TASK 13] - Move the backup file to the destination directory
  mv "$backupFileName" "$destAbsPath"
  echo "Backup file moved to $destAbsPath"
fi
Purpose: Moves the newly created backup file to the destination directory (destAbsPath) and prints a message confirming the move.
mv "$backupFileName" "$destAbsPath": Moves the backup file to the destination directory.
