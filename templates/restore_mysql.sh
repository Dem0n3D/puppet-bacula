#!/bin/bash

if [ ! -f $1/<%= mysql_backup_filename %> ]; then
    echo "MySQL full backup not found!"
    exit 1
fi

<% if @mysql_backup_password and @mysql_backup_password != "" then -%>
dbpass="-p<%= mysql_backup_password %>"
<% else -%>
dbpass=""
<% end -%>

cd $1

cat <%= mysql_backup_filename %> | <%= mysql_backup_uncompress %> | mysql -u<%= mysql_backup_user %> $dbpass
mysqlbinlog $(ls -rt mysql-bin.*) | mysql -u<%= mysql_backup_user %> $dbpass

