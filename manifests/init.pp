/* This program is free software. It comes without any warranty, to
 * the extent permitted by applicable law. You can redistribute it
 * and/or modify it under the terms of the Do What The Fuck You Want
 * To Public License, Version 2, as published by Sam Hocevar. See
 * http://sam.zoy.org/wtfpl/COPYING for more details. */

class bacula-dir {
  package {
    'bacula-director-pgsql':
      ensure	=> installed;
  }

  service {
    'bacula-director':
      require		=> Package['bacula-director-pgsql'],
      pattern		=> '/usr/sbin/bacula-dir',
      hasrestart	=> false,
      enable		=> true,
      ensure		=> running;
  }

  define director($description = "Director $hostname", $password = "", $messages = "Daemon", $working_directory = "/var/lib/bacula", $pid_directory = "/var/run/bacula", $scripts_directory = "", $queryfile = "/etc/bacula/scripts/query.sql", $maximum_concurrent_jobs = "1", $diraddress = "127.0.0.1", $dirport = "9101", $ensure = "present") {
     common::concatfilepart {
      $name:
        file	=> '/etc/bacula/bacula-dir.conf', 
        manage	=> true,
        content	=> template('bacula/director.erb'),
        ensure	=> $ensure,
        notify  => Service['bacula-director'];
    }
  }

  define job($job_or_def = 'Job', $enabled = "yes", $jobtype = '', $level = '', $accurate = '', $verify_job = '', $jobdefs = '', $bootstrap = '', $write_bootstrap = '', $client = '', $fileset = '', $messages = '', $pool = '', $full_backup_pool = '', $differential_backup_pool = '', $incremental_backup_pool = '', $bacula_schedule = '', $storage = '', $max_start_delay = '', $max_run_time = '', $incremental_max_run_time = '', $differential_max_wait_time = '', $max_run_shed_time = '', $max_wait_time = '', $max_full_age = '', $prefer_mounted_volumes = 'yes', $prune_jobs = '', $prune_files = '', $prune_volumes = '', $runscript = '', $run_before_job = '', $run_after_job = '', $run_after_failed_job = '', $client_run_before_job = '', $client_run_after_job = '', $rerun_failed_levels = '', $spool_data = '', $spool_attributes = '', $where = '', $add_prefix = '', $add_suffix = '', $strip_prefix = '', $regexwhere = '', $replace = '', $prefix_links = '', $maximum_concurrent_jobs = '', $reschedule_on_error = '', $reschedule_interval = '', $reschedule_times = '', $run = '', $priority = '', $allow_mixed_priority = '', $write_part_after_job = '', $ensure = 'present') {
    common::concatfilepart {
      $name:
        file	=> '/etc/bacula/bacula-dir.conf', 
        manage	=> true,
        content	=> template('bacula/job.erb'),
        ensure	=> $ensure,
        notify  => Service['bacula-director'];
    }
  }

  define jobdefs($job_or_def = 'JobDefs', $enabled = "yes", $jobtype = '', $level = '', $accurate = '', $verify_job = '', $jobdefs = '', $bootstrap = '', $write_bootstrap = '', $client = '', $fileset = '', $messages = '', $pool = '', $full_backup_pool = '', $differential_backup_pool = '', $incremental_backup_pool = '', $bacula_schedule = '', $storage = '', $max_start_delay = '', $max_run_time = '', $incremental_max_run_time = '', $differential_max_wait_time = '', $max_run_shed_time = '', $max_wait_time = '', $max_full_age = '', $prefer_mounted_volumes = 'yes', $prune_jobs = '', $prune_files = '', $prune_volumes = '', $runscript = '', $run_before_job = '', $run_after_job = '', $run_after_failed_job = '', $client_run_before_job = '', $client_run_after_job = '', $rerun_failed_levels = '', $spool_data = '', $spool_attributes = '', $where = '', $add_prefix = '', $add_suffix = '', $strip_prefix = '', $regexwhere = '', $replace = '', $prefix_links = '', $maximum_concurrent_jobs = '', $reschedule_on_error = '', $reschedule_interval = '', $reschedule_times = '', $run = '', $priority = '', $allow_mixed_priority = '', $write_part_after_job = '', $ensure = 'present') {
   common::concatfilepart {
      $name:
        file	=> '/etc/bacula/bacula-dir.conf', 
        manage	=> true,
        content	=> template('bacula/job.erb'),
        ensure	=> $ensure,
        notify  => Service['bacula-director'];
    }
  }

  define bacula_schedule($run, $ensure = 'present') {
   common::concatfilepart {
      $name:
        file	=> '/etc/bacula/bacula-dir.conf', 
        manage	=> true,
        content	=> template('bacula/schedule.erb'),
        ensure	=> $ensure,
        notify  => Service['bacula-director'];
    }
  }

  define fileset($ignore_fileset_changes = '', $enable_vss = '', $include, $exclude = [], $ensure = 'present') {
   common::concatfilepart {
      $name:
        file	=> '/etc/bacula/bacula-dir.conf', 
        manage	=> true,
        content	=> template('bacula/fileset.erb'),
        ensure	=> $ensure,
        notify  => Service['bacula-director'];
    }
  }

  define client($address, $fd_port = '', $catalog, $password, $file_retention = '', $job_retention = '', $autoprune = '', $maximum_concurrent_jobs = '', $priority = '', $ensure = 'present') {
   common::concatfilepart {
      $name:
        file	=> '/etc/bacula/bacula-dir.conf', 
        manage	=> true,
        content	=> template('bacula/client.erb'),
        ensure	=> $ensure,
        notify  => Service['bacula-director'];
    }
  }
  
  define storage($address, $sd_port = '', $password, $device, $media_type, $autochanger = '', $maximum_concurrent_jobs = '', $heartbeat_interval = '', $ensure = 'present') {
   common::concatfilepart {
      $name:
        file	=> '/etc/bacula/bacula-dir.conf', 
        manage	=> true,
        content	=> template('bacula/storage.erb'),
        ensure	=> $ensure,
        notify  => Service['bacula-director'];
    }
  }

  define pool($maximum_volumes = '', $pool_type, $storage = '', $use_volume_once = '', $maximum_volume_jobs = '', $maximum_volume_files = '', $maximum_volume_bytes = '', $volume_use_duration = '', $catalog_files = '', $autoprune = '', $volume_retention = '', $recyclepool = '', $recycle = '', $recycle_oldest_volume = '', $recycle_current_volume = '', $purge_oldest_volume = '', $cleaning_prefix = '', $label_format = '', $ensure = 'present') {
   common::concatfilepart {
      $name:
        file	=> '/etc/bacula/bacula-dir.conf', 
        manage	=> true,
        content	=> template('bacula/pool.erb'),
        ensure	=> $ensure,
        notify  => Service['bacula-director'];
    }
  }

  define catalog($password, $db_name, $user, $db_socket = '', $db_address = '', $db_port = '', $ensure = 'present') {
   common::concatfilepart {
      $name:
        file	=> '/etc/bacula/bacula-dir.conf', 
        manage	=> true,
        content	=> template('bacula/catalog.erb'),
        ensure	=> $ensure,
        notify  => Service['bacula-director'];
    }
  }

  define messages($mailcommand = '', $operatorcommand = '', $destinations, $ensure = 'present') {
   common::concatfilepart {
      $name:
        file	=> '/etc/bacula/bacula-dir.conf', 
        manage	=> true,
        content	=> template('bacula/messages.erb'),
        ensure	=> $ensure,
        notify  => Service['bacula-director'];
    }
  }

  define console($password, $jobacl = '', $clientacl = '', $storageacl = '', $scheduleacl = '', $poolacl = '', $filesetacl = '', $catalogacl = '', $commandacl = '', $whereacl = '', $ensure = 'present') {
   common::concatfilepart {
      $name:
        file	=> '/etc/bacula/bacula-dir.conf', 
        manage	=> true,
        content	=> template('bacula/console.erb'),
        ensure	=> $ensure,
        notify  => Service['bacula-director'];
    }
  }

  define counter($minumum = '', $maximum = '', $wrapcounter = '', $catalog = '', $ensure = 'present') {
   common::concatfilepart {
      $name:
        file	=> '/etc/bacula/bacula-dir.conf', 
        manage	=> true,
        content	=> template('bacula/counter.erb'),
        ensure	=> $ensure,
        notify  => Service['bacula-director'];
    }
  }
}

class bacula-sd {
  package {
    'bacula-sd-pgsql':
      ensure	=> installed;
  }

  service {
    'bacula-sd':
      require		=> Package['bacula-sd-pgsql'],
      pattern		=> '/usr/sbin/bacula-sd',
      hasrestart	=> false,
      enable		=> true,
      ensure		=> running;
  }
  
  define storage($working_directory, $pid_directory, $heartbeat_interval = '', $client_connect_wait = '', $maximum_concurrent_jobs = '', $sdport = '', $sdaddress = '', $ensure = 'present') {
   common::concatfilepart {
      $name:
        file	=> '/etc/bacula/bacula-sd.conf', 
        manage	=> true,
        content	=> template('bacula/sd-storage.erb'),
        ensure	=> $ensure,
        notify  => Service['bacula-sd'];
    }
  }

  define sd-director($password, $monitor = '', $ensure = 'present') {
   common::concatfilepart {
      $name:
        file	=> '/etc/bacula/bacula-sd.conf', 
        manage	=> true,
        content	=> template('bacula/sd-director.erb'),
        ensure	=> $ensure,
        notify  => Service['bacula-sd'];
    }
  }

  define device($archive_device, $device_type = '', $media_type, $autochanger = '', $changer_device = '', $changer_command = '', $alert_command = '', $drive_index = '', $autoselect = '', $maximum_concurrent_jobs = '', $maximum_changer_wait = '', $maximum_rewind_wait = '', $maximum_open_wait = '', $always_open = '', $volume_poll_interval = '', $close_on_poll = '', $maximum_open_wait = '', $removable_media = '', $random_access = '', $requires_mount = '', $mount_point = '', $mount_command = '', $unmount_command = '', $block_checksum = '', $minimum_block_size = '', $maximum_block_size = '', $hardware_end_of_medium = '', $fast_forward_space_file = '', $use_mtiocget = '', $bsf_at_eom = '', $two_eof = '', $backward_space_record = '', $backward_space_file = '', $forward_space_record = '', $forward_space_file = '', $offline_on_unmount = '', $maximum_concurrent_jobs = '', $maximum_volume_size = '', $maximum_file_size = '', $block_positioning = '', $maximum_network_buffer_size = '', $maximum_spool_size = '', $maximum_job_spool_size = '', $spool_directory = '', $maximum_part_size = '', $labelmedia = '', $automaticmount = '', $removablemedia = '',  $ensure = 'present') {
   common::concatfilepart {
      $name:
        file	=> '/etc/bacula/bacula-sd.conf', 
        manage	=> true,
        content	=> template('bacula/sd-device.erb'),
        ensure	=> $ensure,
        notify  => Service['bacula-sd'];
    }
  }

  define messages($mailcommand = '', $operatorcommand = '', $destinations, $ensure = 'present') {
   common::concatfilepart {
      $name:
        file	=> '/etc/bacula/bacula-sd.conf', 
        manage	=> true,
        content	=> template('bacula/messages.erb'),
        ensure	=> $ensure,
        notify  => Service['bacula-sd'];
    }
  }
}

class bacula-client {
  package {
    'bacula-client':
      ensure	=> installed;
  }
  
  service {
    'bacula-fd':
      require		=> Package['bacula-client'],
      pattern		=> '/usr/sbin/bacula-fd',
      hasrestart	=> false,
      enable		=> true,
      ensure		=> running;
  }

  define filedaemon($working_directory, $pid_directory, $heartbeat_interval = '', $maximum_concurrent_jobs = '', $fdaddresses = '', $fdport = '', $fdaddress = '', $fdsourceaddress = '', $sdconnecttimeout = '', $maximum_network_buffer_size = '', $heartbeat_interval = '', $ensure = 'present') {
    common::concatfilepart {
      $name:
        file	=> '/etc/bacula/bacula-fd.conf', 
        manage	=> true,
        content	=> template('bacula/fd-filedaemon.erb'),
        ensure	=> $ensure,
        notify		=> Service['bacula-fd'];
    }
  }

  define fd-director($password, $monitor = '', $ensure = 'present') {
     common::concatfilepart {
      $name:
        file	=> '/etc/bacula/bacula-fd.conf', 
        manage	=> true,
        content	=> template('bacula/fd-director.erb'),
        ensure	=> $ensure,
        notify		=> Service['bacula-fd'];
    }
  }

  define messages($mailcommand = '', $operatorcommand = '', $destinations, $ensure = 'present') {
    common::concatfilepart {
      $name:
        file	=> '/etc/bacula/bacula-fd.conf', 
        manage	=> true,
        content	=> template('bacula/messages.erb'),
        ensure	=> $ensure,
        notify		=> Service['bacula-fd'];
    }
  }
}
