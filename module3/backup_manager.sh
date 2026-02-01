#!/bin/bash

# 1. Check if exactly 3 arguments are given
if [ $# -ne 3 ]; then
    echo "Usage: $0 <source_dir> <backup_dir> <extension>"
    exit 1
fi

# 2. Assign arguments to variables
SRC="$1"      # Source directory
DEST="$2"     # Backup directory
EXT="$3"      # File extension (like .txt)

# 3. Create backup directory if it doesn’t exist
mkdir -p "$DEST"

# 4. Find files with the given extension
FILES=("$SRC"/*"$EXT")

# 5. If no files found, exit
if [ ! -e "${FILES[0]}" ]; then
    echo "No $EXT files found in $SRC"
    exit 0
fi

# 6. Copy files (overwrite only if newer)
BACKUP_COUNT=0

for f in "${FILES[@]}"; do
    fname=$(basename "$f")

    if [ ! -e "$DEST/$fname" ] || [ "$f" -nt "$DEST/$fname" ]; then
        cp "$f" "$DEST/"
        BACKUP_COUNT=$((BACKUP_COUNT + 1))
    fi
done

export BACKUP_COUNT

# 7. Write a simple report
REPORT="$DEST/backup_report.log"
echo "Backed up $BACKUP_COUNT files to $DEST" > "$REPORT"

echo "Backup complete. Report saved to $REPORT"

