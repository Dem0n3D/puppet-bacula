## bacula::director
# Configure the Director for Bacula, making sure that all the client
# configuration is imported as required for this server.

class bacula::director inherits bacula::config {

  # Make sure the Director is installed (with mysql, which will be used for
  # the storage of the Catalog data). We will also need the File Daemon client
  # on this server regardless to manage backups of the Catalog
  package {
    ['bacula-director-mysql']:
      ensure => 'present';
  }

  # Configure the name and the hostname for the Director (i.e. this server)
  # and also set it to be the Client name/hostname as well for the File Deamon
  $safe_director_hostname = $fqdn
  $safe_director_name     = $hostname
  $safe_client_hostname   = $fqdn
  $safe_client_name       = $hostname

  # Configure bacula catalog
  $safe_catalog_user = $bacula_catalog_user
  $safe_catalog_password = $bacula_catalog_password
  $safe_catalog_database = $bacula_catalog_database

  # And import the details for the *DEFAULT* Storage Daemon, which will provide
  # the default storage Device and Pool configuration. Each client will be able
  # to define their own Storage Daemons if required and they will be imported
  # later on in the per-Client configuration
  $safe_storage_hostname = $bacula_storage_server
  $safe_storage_name     = $bacula_storage_server ? {
    /^([a-z0-9_-]+)\./ => $1,
    default            => $bacula_storage_server
  }

  # Create the configuration for the Director and make sure the directory for
  # the per-Client configuration is created before we run the realization for
  # the exported files below
  file {
    '/etc/bacula/bacula-dir.conf':
      ensure  => 'present',
      owner   => 'bacula',
      group   => 'bacula',
      content => template('bacula/bacula-dir.conf'),
      notify  => Service['bacula-director'],
      require => Package['bacula-director-mysql'];
    '/etc/bacula/bacula-dir.d':
      ensure  => 'directory',
      owner   => 'bacula',
      group   => 'bacula',
      require => Package['bacula-director-mysql'];
  # Create an empty while which will make sure that the last line of
  # the bacula-dir.conf file will always run correctly.
    '/etc/bacula/bacula-dir.d/empty.conf':
      ensure  => 'present',
      owner   => 'bacula',
      group   => 'bacula',
      content => '# DO NOT EDIT - Managed by Puppet - DO NOT REMOVE',
      require => File['/etc/bacula/bacula-dir.d'];
  }

  # Register the Service so we can manage it through Puppet
  service {
    'bacula-director':
      enable     => true,
      ensure     => running,
      require    => Package['bacula-director-mysql'],
      hasstatus  => true,
      hasrestart => true;
  }

  # Finally, realise all the virtual files created by all the clients that
  # this server needs to be configured to manage
  File <<| tag == "bacula_director_$safe_director_name" |>>
  Concat <<| tag == "bacula_director_$safe_director_name" |>>
  Concat::Fragment <<| tag == "bacula_director_$safe_director_name" |>>
}
