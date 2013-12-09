define bacula::pool($maximum_volumes = '', $pool_type, $storage = '', $use_volume_once = '', $maximum_volume_jobs = '', $maximum_volume_files = '', $maximum_volume_bytes = '', $volume_use_duration = '', $catalog_files = '', $autoprune = '', $volume_retention = '', $recyclepool = '', $recycle = '', $recycle_oldest_volume = '', $recycle_current_volume = '', $purge_oldest_volume = '', $cleaning_prefix = '', $label_format = '', $ensure = 'present') {
    @@concat::fragment { "pool-$name":
        target  => "/etc/bacula/bacula-dir.d/$fqdn.conf",
        content => template('bacula/pool.erb'),
        order   => 20,
        tag     => "bacula_director_$bacula_director_server";
    }
}

