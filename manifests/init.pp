## bacula
# This is the per-Client class and will configure the File Daemon to run on
# the server so that the Director can talk to it to back it up, while also
# producing and exporting the required configuration for the Director and
# the Storage Daemon as well so that they can be configured with the required
# settings on those boxes as well.

class bacula {
  # Do the configuration checks before we continue
  require bacula::config

  # Make sure the File Daemon (the client program) is installed. Don't use the
  # bacula-client package as it pulls in console and additional stuff which
  # we don't require
  package {
    ['bacula-fd']:
      ensure => 'present';
  }

  # Import the name and the hostname for the Directory from the node settings
  $safe_director_hostname = $bacula_director_server
  $safe_director_name     = $bacula_director_server ? {
    /^([a-z0-9_-]+)\./ => "$1",
    default            => $bacula_director_server
  }
  # And do the same for the Storage Daemon
  $safe_storage_hostname = $bacula_storage_server
  $safe_storage_name     = $bacula_storage_server ? {
    /^([a-z0-9_-]+)\./ => "$1",
    default            => $bacula_storage_server
  }
  # Finally also set up the name and hostname for the Client itself
  $safe_client_hostname = $fqdn
  $safe_client_name     = $hostname

  # Create various instances of the configuration required to get this server to
  # be backed up. Once is for the Director, which will initiate the backups and
  # set what needs to be backed up (and to where) and the other is for the
  # Storage Daemon, which will set where on it's filesystem the backups will be
  # kept (for which we'll also create a command which will make sure that
  # location exists)
  @@file {
    "/etc/bacula/bacula-sd.d/$safe_client_name.conf":
      ensure  => 'present',
      owner   => 'bacula',
      group   => 'bacula',
      mode    => '0640',
      tag     => "bacula_storage_$safe_storage_name",
      content => template('bacula/host-sd.conf'),
      notify  => Service['bacula-sd'],
      require => File['/etc/bacula/bacula-sd.d'];
    "$bacula_storage_dir/$safe_client_hostname":
      ensure  => 'directory',
      tag     => "bacula_storage_$safe_storage_name",
      owner   => 'bacula',
      group   => 'tape',
      mode    => '0750',
      require => File['$bacula_storage_dir'];
  }

  @@concat {
    "/etc/bacula/bacula-dir.d/$safe_client_name.conf":
      owner   => 'bacula',
      group   => 'bacula',
      mode    => '0640',
      tag     => "bacula_director_$safe_director_name",
      notify  => Service['bacula-director'];
  }

  @@concat::fragment { "/etc/bacula/bacula-dir.d/$safe_client_name.conf_base":
    target    => "/etc/bacula/bacula-dir.d/$safe_client_name.conf",
    content   => template('bacula/host-dir.conf'),
    order     => 01,
    tag       => "bacula_director_$safe_director_name",
    notify    => Service['bacula-director'];
  }

  # Register the Service so we can manage it through Puppet
  service {
    'bacula-fd':
      enable     => true,
      ensure     => running,
      require    => Package['bacula-fd'],
      hasrestart => true;
  }

  # Finally, make sure that the configuration for the client itself is set so
  # that it will allow the Director to talk with it and that it can contact
  # the Storage Daemon to back up the data
  file {
    '/etc/bacula/bacula-fd.conf':
      ensure  => 'present',
      content => template('bacula/bacula-fd.conf'),
      notify  => Service['bacula-fd'],
      require => Package['bacula-fd'];
  }
}
