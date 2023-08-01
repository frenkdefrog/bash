# Mysql - backup

This script helps you to backup mysql/mariadb databases with mysqldump tool. 

1. Make sure that mysqldump is installed and can be run by the user which in name you would like to run this backup script.
2. Make sure, that a *.db_access.cnf* file is created. This is needed to hold the authentication data for the user which should be used during the backup.
3. If file encryption is needed then make sure that .gpg_password file is created with the **password** for the encryption.


