#!/bin/bash

#colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

convertedList="converted.dat"
waitInterval=60 #seconds
fileCount=0
currentFileCount=0

echo "Starting Autobrake..."

#create file list if it doesn't already exist
if [ -f $convertedList ]
then
    echo "${convertedList} exists"
else
    echo "${convertedList} does not exist. Creating file..."
    touch $convertedList
    mkdir converted
    if [ -f ${convertedList} ]
    then
        echo "${convertedList} was created successfully"
    else
        echo "There was an issue creating ${convertedList}. Exiting."
        exit 1
    fi
fi

printf "${GREEN}Starting watchdog${NC}\n"
while [ true ]; do
    currentFileCount=($(ls *.mkv | wc -l))
    if [ $fileCount != $currentFileCount ];
    then
        for file in ./*.mkv; do
            echo "Found $file"
            if grep -w "$file" "$convertedList"
            then
                echo "File has already been converted"
            else
                echo "File has not been converted"
                /Applications/HandBrakeCLI -i ${file} -o ./converted/${file}
                echo $file >> $convertedList
            fi
        done
        printf "${GREEN}Waiting for new files${NC}\n"
        fileCount=$currentFileCount
    fi
    sleep $waitInterval
done
