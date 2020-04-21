# == Class: profile::puppet_agent
#
# This class manages the Puppet Agent version and ensures that it
# is running and enabled.  Hiera data per-environment should be the
# source of the puppet_agent $package_version
# @param package_version - override package_version provided to the puppet_agent module
#   Default: Hiera data sets the version or leave it undefined
#
class profile::puppet_agent (
  $package_version = undef,
) {
  # Use puppet_agent module to manage puppet version
  class { 'puppet_agent':
    package_version => $package_version,
  }

  # If running an agent >= 6.12.0 then use EventCreate.exe else use puppetres.dll
  if versioncmp($facts[aio_agent_version], '6.12.0') >= 0 {
    $event_message_file_source = '%SystemRoot%\System32\EventCreate.exe'
  } else {
    $event_message_file_source = 'C:\Program Files\Puppet Labs\Puppet\puppet\bin\puppetres.dll'
  }
  # If running Windows then move the puppet event log from Application to Puppet
  if $facts['os']['family'] == 'windows' {
    registry_key { 'Application_Puppet':
      ensure => absent,
      path   => 'HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Application\Puppet',
    }
    registry_key { 'Puppet_Puppet':
      ensure  => present,
      path    => 'HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Puppet\Puppet',
      require => Registry_key['Application_Puppet'],
    }
    registry_value { 'EventMessageFile':
      ensure  => present,
      path    => 'HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Puppet\Puppet\EventMessageFile',
      type    => string,
      data    => $event_message_file_source,
      require => Registry_key['Puppet_Puppet'],
    }
  }
}
