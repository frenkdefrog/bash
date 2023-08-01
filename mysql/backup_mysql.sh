#!/bin/bash

#encryption
ENCRYPT=1
ENCRYPT_PASSWD_FILE="/root/scripts/.gpg_passwd"

# MySQL database credentials
DB_CLIENT="/root/scripts/.db_access.cnf"

# Backup directory
BACKUP_DIR="/srv/backup/mysqlbackup"

# Current date and time
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Get list of databases
DATABASES=$(mysql --defaults-extra-file=$DB_CLIENT -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)")

# Loop through each database and create backup
for DB_NAME in $DATABASES; do
  BACKUP_FILE="$BACKUP_DIR/$DB_NAME-$DATE.sql.gz"
  echo "Starting backup of $DB_NAME into the file: $BACKUP_FILE"
  mysqldump --defaults-extra-file=$DB_CLIENT --single-transaction $DB_NAME | gzip > $BACKUP_FILE
  if [[ $ENCRYPT -eq 1 ]]; then
	cat $ENCRYPT_PASSWD_FILE | gpg -c --passphrase-fd 0 $BACKUP_FILE && rm -r $BACKUP_FILE	
  fi
  echo "Database $DB_NAME backed up to $BACKUP_FILE"
done



find $BACKUP_DIR -type f -name "*sql.gz" -mtime +7 -delete
find $BACKUP_DIR -type f -name "*sql.gz.gpg" -mtime +7 -delete
