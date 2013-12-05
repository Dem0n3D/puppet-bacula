define bacula::fileset($ignore_fileset_changes = '', $enable_vss = '', $include, $exclude = [], $ensure = 'present') {
    @@concat::fragment { "fileset-$name":
        target  => "/etc/bacula/bacula-dir.d/$fqdn.conf",
        content => template('bacula/fileset.erb'),
        order   => 10,
        tag     => "bacula_director_$bacula_director_server";
    }
}

