define bacula::job($job_or_def = 'Job', $enabled = "yes", $jobtype = '', $level = '', $accurate = '', $verify_job = '', $jobdefs = '', $bootstrap = '', $write_bootstrap = '', $client = '', $fileset = '', $messages = '', $pool = '', $full_backup_pool = '', $differential_backup_pool = '', $incremental_backup_pool = '', $bacula_schedule = '', $storage = '', $max_start_delay = '', $max_run_time = '', $incremental_max_run_time = '', $differential_max_wait_time = '', $max_run_shed_time = '', $max_wait_time = '', $max_full_age = '', $prefer_mounted_volumes = 'yes', $prune_jobs = '', $prune_files = '', $prune_volumes = '', $runscript = '', $run_before_job = '', $run_after_job = '', $run_after_failed_job = '', $client_run_before_job = '', $client_run_after_job = '', $rerun_failed_levels = '', $spool_data = '', $spool_attributes = '', $where = '', $add_prefix = '', $add_suffix = '', $strip_prefix = '', $regexwhere = '', $replace = '', $prefix_links = '', $maximum_concurrent_jobs = '', $reschedule_on_error = '', $reschedule_interval = '', $reschedule_times = '', $run = '', $priority = '', $allow_mixed_priority = '', $write_part_after_job = '', $ensure = 'present') {
    @@concat::fragment { "job-$name":
        target  => "/etc/bacula/bacula-dir.d/$fqdn.conf",
        content => template('bacula/job.erb'),
        order   => 99, # Job is the last resource
        tag     => "bacula_director_$bacula_director_server";
    }
}
