#!/bin/bash

set -e

SOURCE_DIR="$1"
BACKUP_DIR="$2"
FILE_EXTENSION="$3"

if [ -z "$SOURCE_DIR" ] || [ -z "$BACKUP_DIR" ] || [ -z "$FILE_EXTENSION" ]; then
    echo "Give the parameters: $0 source_director, backup_directory,file_extension"
    exit 1
fi

FILES_TO_BACKUP=($SOURCE_DIR/*$FILE_EXTENSION)

if [ ${#FILES_TO_BACKUP[@]} -eq 0 ]; then
    echo "No files matching '$FILE_EXTENSION' found in $SOURCE_DIR."
    exit 1
fi

export BACKUP_COUNT=0

if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR" || { echo "Failed to create backup directory! Exiting..."; exit 1; }
    echo "Backup directory created: $BACKUP_DIR"
fi


echo "Backing up files from $SOURCE_DIR to $BACKUP_DIR..."

TOTAL_SIZE=0

for FILE in "${FILES_TO_BACKUP[@]}"; do
   
    FILE_SIZE=$(stat -c %s "$FILE")
    echo "Backing up: $FILE (Size: $FILE_SIZE bytes)"
    
    TOTAL_SIZE=$((TOTAL_SIZE + FILE_SIZE))

    DEST_FILE="$BACKUP_DIR/$(basename "$FILE")"

    if [ -e "$DEST_FILE" ]; then
        SOURCE_MOD_TIME=$(stat -c %Y "$FILE")
        DEST_MOD_TIME=$(stat -c %Y "$DEST_FILE")
        if [ "$SOURCE_MOD_TIME" -gt "$DEST_MOD_TIME" ]; then
            echo "Overwriting $DEST_FILE (source is newer)"
            cp -f "$FILE" "$DEST_FILE"
        else
            echo "Skipping $DEST_FILE (source is not newer)"
        fi
    else
        cp "$FILE" "$DEST_FILE"
    fi

 
    export BACKUP_COUNT=$((BACKUP_COUNT + 1))
done


echo "Backup completed. Generating report..."
REPORT_FILE="$BACKUP_DIR/backup_report.log"
echo "Total files processed: $BACKUP_COUNT" > "$REPORT_FILE"
echo "Total size of files backed up: $TOTAL_SIZE bytes" >> "$REPORT_FILE"
echo "Backup directory: $BACKUP_DIR" >> "$REPORT_FILE"

# Display the report
cat "$REPORT_FILE"
