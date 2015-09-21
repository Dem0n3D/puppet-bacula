#!/bin/bash

# This file managed by puppet

level=$1

<% if @mysql_backup_password and @mysql_backup_password != "" then -%>
dbpass="-p<%= mysql_backup_password %>"
<% else -%>
dbpass=""
<% end -%>

dbdump="mysqldump --single-transaction --master-data=2 --flush-logs --all-databases -u<%= mysql_backup_user %> $dbpass"
compress="<%= mysql_backup_compress %>"
fulldb_name="<%= mysql_backup_filename %>"

flush_logs="mysqladmin flush-logs -u<%= mysql_backup_user %> $dbpass"

backup_dir="<%= mysql_backup_dir %>"
logs_dir="<%= mysql_logs_dir %>"

bacula_level_full="<%= bacula_level_full %>"
bacula_level_incremental="<%= bacula_level_incremental %>"

if [ ! -d $backup_dir ]; then
    mkdir -p $backup_dir
fi

case ${level} in
    "$bacula_level_full" )
        if [ -f $backup_dir/${fulldb_name} ]; then
            rm $backup_dir/* # delete all previous files (full, diff, incremental)
        fi
        ${dbdump} | ${compress} > $backup_dir/${fulldb_name}
        ;;
    "$bacula_level_incremental" )
        if [ ! -f $backup_dir/${fulldb_name} ]; then
            echo "Can't find ${fulldb_name}"
            exit 2
        fi
        
        ${flush_logs}

        logs=$(find $logs_dir -newer $backup_dir/${fulldb_name} -name "mysql-bin.*" | grep -v "index") # select all binary logs since last full backup
        
        rm $backup_dir/mysql-bin.* || echo 1

        cp -p $logs $backup_dir
        ;;
    * )
        echo "Unknown backup level!"
        exit 1
        ;;
esac

