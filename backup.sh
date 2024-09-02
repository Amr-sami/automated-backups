#!/bin/bash

# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]
then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi

# [TASK 1]
targetDirectory=$1
destinationDirectory=$2

# [TASK 2]
echo "Target Directory: $targetDirectory"
echo "Destination Directory: $destinationDirectory"

# [TASK 3]
currentTS=$(date +%s)

# [TASK 4]
backupFileName="backup-${currentTS}.tar.gz"

# We're going to:
  # 1: Go into the target directory
  # 2: Create the backup file
  # 3: Move the backup file to the destination directory

# To make things easier, we will define some useful variables...

# [TASK 5]
origAbsPath=$(pwd)

# [TASK 6]
cd "$destinationDirectory"
destAbsPath=$(pwd)

# [TASK 7]
cd "$origAbsPath"
cd "$targetDirectory"

# [TASK 8]
yesterdayTS=$(($currentTS - 24 * 60 * 60))

declare -a toBackup

# [TASK 9] - Find all files and directories in the current folder
for file in $(ls); do
  # [TASK 10] - Check if the file was modified in the last 24 hours
  if [[ $(date -r $file +%s) > $yesterdayTS ]]; then
    # [TASK 11] - Add the file to the toBackup array
    toBackup+=($file)
  fi
done

# [TASK 12] - Compress and archive the files
if [ ${#toBackup[@]} -eq 0 ]; then
  echo "No files were modified in the last 24 hours. No backup created."
else
  tar -czvf "$backupFileName" "${toBackup[@]}"
  echo "Backup created successfully: $backupFileName"

  # [TASK 13] - Move the backup file to the destination directory
  mv "$backupFileName" "$destAbsPath"
  echo "Backup file moved to $destAbsPath"
fi
