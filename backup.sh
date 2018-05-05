#!/bin/bash

#Set variables
USER=<your username>
COMPUTER=<your computername>
#Don't forget to set a "/" at the end of the path
FILES_ROOT=<path to your files>/
BACKUP_ROOT=<path to backup storage>/

#Adapt if needed
TIMESTAMP=`date '+%s'`
DATE=`date '+%Y-%m-%d_%H:%M:%S'`
BACKUP_FILE=${BACKUP_ROOT}${USER}_${COMPUTER}_${DATE}_${TIMESTAMP}.tar.gz


#Save and compress files
tar cf - ${FILES_ROOT} -P | pv -s $(du -sb ${FILES_ROOT} | awk '{print $1}') | gzip > ${BACKUP_FILE}

#Clean up backups older than 7884000 s (3 months)
FILES=($(find $BACKUP_ROOT -name "*.tar.gz"))
for FILE in "${FILES[@]}"; do
    FILE_TIMESTAMP=$(sed 's/.*_\(.*\).tar.gz/\1/' <<< "$FILE")
    if ((  7884000 < $(expr $TIMESTAMP - $FILE_TIMESTAMP))); then
        rm $FILE
        echo "Old backup file $FILE removed!"
    fi
done
