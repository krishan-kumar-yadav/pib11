#!/bin/bash

# Configuration

SOURCE_REPO_URL="https://github.com/krishan-kumar-yadav/pib11.git"  # Replace with your source repo URL

DEST_REPO_URL="https://github.com/krishan-kumar-yadav/pibsync.git"  # Replace with your destination repo URL

WORK_DIR="C:\Users\YadavK\Desktop\landisgyr\ot\pib11"  # Temporary working directory

SOURCE_DIR="$WORK_DIR\pib11"  # Directory for source repository

DEST_DIR="$WORK_DIR\pibsync"  # Directory for destination repository

LOCAL_SOURCE="$WORK_DIR\pib11"

LOCAL_DEST="$WORK_DIR\pibsync"

FILES_TO_SYNC=(
    "pib11"
    "test.tf"
    )

BRANCH="main"  # Branch to sync


# rsync -av "$FILE_TO_SYNC" "$DEST_DIR"

# Create the working directory

mkdir -p "$SOURCE_DIR"

mkdir -p "$DEST_DIR"

# Clone the source repository

echo -e "\n#################################### Cloning of $SOURCE_REPO_URL. ####################################\n"
if [ -d "$SOURCE_DIR" ]; then
    echo "The repository already exists in $LOCAL_SOURCE."
else
  git clone --branch "$BRANCH" "$SOURCE_REPO_URL" "$SOURCE_DIR"
fi

# Clone the destination repository

echo -e "\n#################################### Cloning of $DEST_REPO_URL. ####################################\n"
if [ -d "$DEST_DIR" ]; then
    echo "The repository already exists in $LOCAL_DEST."
else
  git clone --branch "$BRANCH" "$DEST_REPO_URL" "$DEST_DIR"
fi
#
# Copy the file to the destination repository

echo -e "\n#################################### Copying file from source to destination... ####################################\n"

#for FILE in "${FILES_TO_SYNC[@]}"; do
#cp -R "$SOURCE_DIR/$FILE" "$DEST_DIR/$FILE"

for FILE in "${FILES_TO_SYNC[@]}"; do
    if [ -e "$SOURCE_DIR/$FILE" ]; then
        # Create the destination directory if it doesn't exist
        mkdir -p "$DEST_DIR$(dirname "$FILE")"

        # Copy the file
        cp "$SOURCE_DIR/$FILE" "$DEST_DIR/$FILE"
        echo -e "Copied: $FILE\n"
    else
        echo -e "File not found: $FILE\n"
    fi
done


# Commit and push changes to the destination repository

cd "$DEST_DIR" || exit

git add .

if git diff --cached --quiet; then

    echo -e "\nNo changes detected. Nothing to commit.\n"

else

    echo -e "\nCommitting and pushing changes to the destination repository...\n"

    git commit -m "Selected files are now synced from source repo"

    Git show

    git push origin "$BRANCH"

#    git diff last version:HEAD

    echo -e "\nChanges pushed successfully.\n"

fi



# git diff --name-only -branch "$BRANCH" "$SOURCE_DIR" "$DEST_DIR"

#git diff -u "$SOURCE_DIR/SyncFile01" "$DEST_DIR/SyncFile01"

#echo "Comparing two files"
#diff_output=$(diff -u "$SOURCE_DIR/SyncFile01" "$DEST_DIR/SyncFile01")

# Check if there are differences
#if [ -z "$diff_output" ]; then
#    echo "No differences found between the files."
#else
#    echo "Differences between the files:"
#    echo "$diff_output"
#fi


echo -e "\nDone\n"
