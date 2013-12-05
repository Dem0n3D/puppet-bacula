## bacula::config
# Perform some basic config checks on the configuration data when any
# of the bacula::* classes are called.

class bacula::config {
  # Check both the Director configuration variables to make sure that it is
  # a fully-qualified domain name
  if ($bacula_director_server !~ /^[a-z0-9_\.-]+$/) {
    fail("Invalid Bacula Director: $bacula_director_server")
  }
  # Do the same for the Storage Daemon configuration variable
  if ($bacula_storage_server !~ /^[a-z0-9_\.-]+$/) {
    fail("Invalid Bacula Storage Daemon: $bacula_storage_server")
  }
  # Make sure we have vales for both the Password variables
  if ($bacula_server_password == "" or $bacula_console_password == "") {
    fail("Bacula Server Password and/or Console Password is/are not set")
  }
  # Check mail_to address
  if ($bacula_mail_to !~ /^[\w-]+@([\w-]+\.)+[\w-]+$/) {
    fail("Invalid bacula_mail_to!")
  }
}
