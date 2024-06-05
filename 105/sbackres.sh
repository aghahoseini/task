#!/bin/bash


dir_should_be_backuped_path=/;
dir_should_be_backuped_name=temp
where_saved_backup=/home/${USER}/backup;
#tarfile_name="etc000$(date +%F%T)";
backup_file_name="etc-$(date +%F%T)";

LOG_FILE="/home/${USER}/b.log"

#crontab -l | { cat; echo "*/1 * * * * touch /home/hosein/test/a.txt"; } | crontab -


log ()
{
	echo "$1"
	echo "$1" >> $LOG_FILE
}

log "-------$(date +%d-%m-%Y-%H%M%S)------" 


function backup {

  log "option backup used \n"
      log "creating archive ...... \n> "

      #tar -cvf  a.tar /etc > /dev/null;

      mkdir -p $where_saved_backup;
      cd $dir_should_be_backuped_path && tar -cvf  $where_saved_backup/$backup_file_name.tar $dir_should_be_backuped_name >/dev/null 2>&1;
      

      if [ $? -eq 0 ]; then
	      log “create archive step successfully done”;
        log "backup $backup_file_name is created and stored in $where_saved_backup";
        
      else
        log 'create archive step failed | please contact admin' 
        exit
      fi


      log "compressing $where_saved_backup/$backup_file_name.tar' ...... \n> "
      gzip  $where_saved_backup/$backup_file_name.tar;
      echo -n "secret" | openssl aes-256-cbc -a -salt -pbkdf2 -in $where_saved_backup/$backup_file_name.tar.gz -out "$where_saved_backup/$backup_file_name.tar.gz.enc"   -pass stdin
      rm -rf $where_saved_backup/$backup_file_name.tar.gz ;


      log "successfuly backup file created from $dir_should_be_backuped_path$dir_should_be_backuped_name  and backup file saved in $where_saved_backup with name of $backup_file_name ";

}



function restore {
  log " i am function for restore" ;

        
      log "option restore used \n\n"
     



      if [ -n "$(ls -A $where_saved_backup 2>/dev/null)" ]
      then
        log "available backups to restore \n\n"
        b=$(ls $where_saved_backup );
        log "$b \n\n"
        log "please select one of them (enter one of them name ) :> "

        read selected_backup_file;
        

        
        if [ -e "$where_saved_backup/$selected_backup_file" ]; then
          
         
          log '*************************';





          log "extracting $selected_backup_file  to  ./  ......";

          echo -n "secret" | openssl aes-256-cbc -d -a -pbkdf2 -in "$where_saved_backup/$selected_backup_file" -out ${selected_backup_file%.*}  -pass stdin
          
          gzip -d ${selected_backup_file%.*} 

          tar -xf "./${selected_backup_file%.gz*}"  --dir ./


          if [ $? -eq 0 ]; then
	          log “extracting backup  successfully done”
          else
            log 'extracting backup failed | please contact admin' 
            exit
          fi


          

          log " restore process started "
          from="./$dir_should_be_backuped_name/";
          to="$dir_should_be_backuped_path$dir_should_be_backuped_name";
          rsync -a $from $to --delete

          rm -rf "./${selected_backup_file%.gz*}" ;
          rm -rf "./$dir_should_be_backuped_name" ;


          if [ $? -eq 0 ]; then
	          log “restoring1 backup  successfully done”
          else
            log 'restoring2 backup failed | please contact admin' 
            
          fi


          





          

        else 
          log "you enter a backupfile that dont exist at all"
          exit
        fi 

        
      else
        log "there is no backupfile to  restore to it "
        exit
      fi




}








if [[ $1 == "" ]] #Where "$1" is the positional argument you want to validate 

 then
  log "interactive mode activated "
  log "do you want get backup or restore ? (b for backup . r for restore) \n\n"
  read action;

  

  if [ $action == 'b' ] || [ $action == 'r' ]; then
    if [ $action == 'b' ]; then log 'backup selected' 
      backup;
    fi 
    if [ $action == 'r' ]; then log 'restore selected' 
      restore;
    fi 
  else
    log “invalid option passed”
  fi


fi





while getopts :br OPT; do
  case "$OPT" in
    b)

      backup

      log "`date -u` backup completed with exit code $?" 
      log "----------------------------------------------" 

      

      ;;
    r)

      restore

      log "`date -u` restore process completed with exit code $?" 
      log "----------------------------------------------" 


      ;;
    ?)
      log " option invalid ${OPTARG} "
      ;;
  esac
done


