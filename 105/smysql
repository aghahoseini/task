#!/bin/bash

# ----------------------------------------------------------------------
# name:         smysql.sh
# version:      1.0
# createTime:   2024-06-04
# description:  mysql dump
# author:       hosein aghahoseini
# ----------------------------------------------------------------------



backup_save_path=/home/${USER}/dbbackup/"$(date +%F).database_backup"
backup_file_name="test_$(date +%F%T).sql";

mysql_user=root
mysql_password=testpass;
mysql_db_name=testdb

encryption_password=secret

LOG_FILE="/home/${USER}/mysql-script.log"


log ()
{
	echo "$1"
	echo "$1" >> $LOG_FILE
}


log "------mysqldump-$(date +%d-%m-%Y-%H%M%S)------" 


log "check which user runs script (must be root) "
if [[ "$(whoami)" != "root" ]]; then
  log "you must be root to run this script . Try again with the sudo"
  exit 2
else
    log "user root runs script ";
fi


log "check mysql and mysqldump installed or not ";

if [ -n $(command -v mysqldump) ] && [ -n $( command -v mysql) ]; then


    log " mysql and mysqldump installed ";

    log "check mysql is running or not ";
    if [ -n  "$(pidof mysqld)" ]; then
        log 'mysql is runing';

        log "check specified database exist or not ";        
        mysql --user=$mysql_user --password=$mysql_password -e "SHOW DATABASES;" | grep -qwE $mysql_db_name;
        if [ $? -eq 0 ]; then
            log "database found"


            log "create $backup_save_path (it is backup save path) "
            mkdir -p $backup_save_path;

            log "create $backup_file_name in $backup_save_path "
            cd $backup_save_path && touch $backup_file_name;

            log " execute mysql dump command on database $mysql_db_name"
            cd $backup_save_path &&  mysqldump --user=$mysql_user --password=$mysql_password $mysql_db_name > $backup_save_path/$backup_file_name;

            if [ $? -eq 0 ]; then
                log "mysqldump command successfuly done and $backup_file_name saved in $backup_save_path"
            else 
                log "mysqldump command failed | please contact admin"
                exit;
            fi 


            log " compress mysql dump file"
            gzip  $backup_save_path/$backup_file_name;


            if [ $? -eq 0 ]; then
                log "compressing  $backup_save_path/$backup_file_name successfuly done "
            else 
                log "compressing  $backup_save_path/$backup_file_name failed | please contact admin"
                exit;
            fi 



            file_name="${file_name}.gz"
            backup_file_name="${backup_file_name}.gz"
            
            log "encryption process started on $backup_file_name "
            echo -n $encryption_password | openssl aes-256-cbc -a -salt -pbkdf2 -in $backup_file_name -out "${backup_file_name}.enc"   -pass stdin

            
            if [ $? -eq 0 ]; then
                log "encryption process successfully done "
            else 
                log "encryption process failed | please contact admin"
                exit;
            fi 


            log "remove temp file --> $backup_file_name ";
            rm -rf $backup_file_name



        else 
            log "database dosent exist at all"
            exit;
        fi 

    else
	    log 'mysql  not runnig '
        exit;
    fi

else
    log "Mysqldump is required to export database, but not available on your stack. Please install it first!"
    exit
fi







log "`date -u` backup completed with exit code $?" 
log "----------------------------------------------" 

