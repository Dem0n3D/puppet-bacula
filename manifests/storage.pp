## bacula::storage
# Configure the Storage Daemon for Bacula, making sure we build the storage
# location and import all exported configuration files and directories for
# this server.

class bacula::storage {
  # Do the configuration checks before we continue
  require bacula::config

  # Make sure the Storage Daemon is installed (with mysql)
  package {
    ['bacula-sd-mysql']:
      ensure => 'present';
  }

  # Create the configuration for the Storage Daemon and make sure the directory
  # for the per-Client configuration is created before we run the realization
  # for the exported files below. Also make sure that the storage locations are
  # created along with the location for the default Device.
  file {
    '/etc/bacula/bacula-sd.conf':
      ensure  => 'present',
      owner   => 'bacula',
      group   => 'bacula',
      content => template('bacula/bacula-sd.conf'),
      notify  => Service['bacula-sd'],
      require => Package['bacula-sd-mysql'];
    '/etc/bacula/bacula-sd.d':
      ensure  => 'directory',
      owner   => 'bacula',
      group   => 'bacula',
      require => Package['bacula-sd-mysql'];
  # Create an empty while which will make sure that the last line of
  # the bacula-sd.conf file will always run correctly.
    '/etc/bacula/bacula-sd.d/empty.conf':
      ensure  => 'present',
      owner   => 'bacula',
      group   => 'bacula',
      content => '# DO NOT EDIT - Managed by Puppet - DO NOT REMOVE',
      require => File['/etc/bacula/bacula-sd.d'];
   ["$bacula_storage_dir", "$bacula_storage_dir/default"]:
      ensure  => 'directory',
      owner   => 'bacula',
      group   => 'tape',
      mode    => '0750';
  }
  
  # Realise all the virtual exported configruation from the clients
  # that this server needs to be configured to manage
  File <<| tag == "bacula_storage_$bacula_storage_server" |>> ~>

  # Register the Service so we can manage it through Puppet
  service {
    'bacula-sd':
      enable     => true,
      ensure     => running,
      require    => Package['bacula-sd-mysql'],
      hasstatus  => true,
      hasrestart => true;
  }
}
