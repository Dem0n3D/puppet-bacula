define bacula::schedule($run, $ensure = 'present') {
    @@concat::fragment { "schedule-$name":
        target  => "/etc/bacula/bacula-dir.d/$fqdn.conf",
        content => template('bacula/schedule.erb'),
        order   => 30,
        tag     => "bacula_director_$bacula_director_server";
    }
}

