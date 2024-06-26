#!/bin/bash


# ----------------------------------------------------------------------
# name:         snginx.sh
# version:      1.0
# createTime:   2024-06-04
# description:  if /var/log/access.log file exceed 200Mb . archive it
# author:       hosein aghahoseini
# ----------------------------------------------------------------------


#crontab -l | { cat; echo "0 */72 * * * touch /home/hosein/test/a.txt"; } | crontab -


TARGET_FILE="/var/log/nginx/access.log"
TARGET_FILE_PATH="/var/log/nginx"
TARGET_FILE_NAME="access.log"

BACKUP_SAVE_PATH='/var/log/nginx/'
BACKUP_FILE_NAME=access_$(date '+%Y%m%d').log.tar
#this is log file for this script
LOG_FILE="/home/${USER}/a.log"

LOG_MAX_FILE_SIZE=1k  #100M

NGINX_PID=/var/run/nginx.pid

#touch $LOG_FILE;


log ()
{
	echo "$1"
	echo "$1" >> $LOG_FILE
}
log "------Backup-$(date +%d-%m-%Y-%H%M%S)------" 


#check target file exist or not
if [ -e "$TARGET_FILE_PATH/$TARGET_FILE_NAME" ]; then
    log "target file for backup exist we can continue the process"
else 
    log "target file dont exist"
    exit;
fi 



if [ -n "$(find ${TARGET_FILE} -size +${LOG_MAX_FILE_SIZE})" ]; then

    log "$TARGET_FILE is strictly larger than ${LOG_MAX_FILE_SIZE} so we archive it";


    
    touch "${BACKUP_SAVE_PATH}/${BACKUP_FILE_NAME}";


    log "create archive file -->  ${BACKUP_SAVE_PATH}/${BACKUP_FILE_NAME}";
    cd $TARGET_FILE_PATH && tar -cPf "${BACKUP_SAVE_PATH}/${BACKUP_FILE_NAME}"  $TARGET_FILE_NAME;



    if [ $? -eq 0 ]; then
        log "create archive successfully done"
    else 
        log "create archive step failed | please contact admin"
        exit;
    fi 

    log "make empty access.log file "
    echo "" > "$TARGET_FILE_PATH/$TARGET_FILE_NAME"

fi


log "`date -u` backup completed with exit code $?" 
log "----------------------------------------------" 


