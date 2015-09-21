define bacula::backup_mysql(
  $title="",
  $default_pool = "",
  $bacula_schedule = "",

  $mysql_backup_user = "root",
  $mysql_backup_password = "",
  $mysql_backup_compress = "gzip",
  $mysql_backup_uncompress = "gunzip",
  $mysql_backup_filename = "database.full.sql.gz",
  $mysql_backup_dir = "/backup/mysql",
  $mysql_logs_dir = "/var/lib/mysql",
  $bacula_level_full = "Full",
  $bacula_level_incremental = "Incremental"
) {
  file { "/var/backups/backup_mysql_before.sh":
    ensure  => 'present',
    owner   => 'bacula',
    group   => 'bacula',
    mode    => '0550',
    content => template('bacula/backup_mysql_before.sh');
    "/var/backups/restore_mysql.sh":
    ensure  => 'present',
    owner   => 'bacula',
    group   => 'bacula',
    mode    => '0550',
    content => template('bacula/restore_mysql.sh');
    "$mysql_backup_dir":
    ensure  => 'directory',
    owner   => 'bacula',
    group   => 'bacula',
    mode    => '0770';
  }

  bacula::fileset { "$fqdn:fileset_$title":
    include => ["File = $mysql_backup_dir!Options=signature=MD5,compression=GZIP"]
  }

  bacula::job { "${hostname}:$title":
    fileset => "$fqdn:fileset_$title",
    jobtype => Backup,
    level => Full,
    messages => "$bacula_director_server:messages:standard",
    client => "$fqdn",
    pool => "$default_pool",
    storage => "$bacula_storage_server:storage:$fqdn",
    bacula_schedule => "$bacula_schedule",
    accurate => "yes",
    client_run_before_job => "/bin/bash /var/backups/backup_mysql_before.sh %l"
  }
}

