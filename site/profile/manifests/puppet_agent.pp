# == Class: profile::puppet_agent
#
# This class manages the Puppet Agent version and ensures that it
# is running and enabled.
#
# @param package_version - override package_version provided to the puppet_agent module
#   Default: determine the version of the PE server and match that, or leave it undefined
# @param manage_production - try to determine which machines are production based on facts and hostnames
#    and not include the puppet_agent module there, in order to prevent agent upgrades in production.
#
class profile::puppet_agent (
  Optional[Pattern[/\d+\.\d+\.\d+/]] $package_version = undef,
  Boolean $manage_production = true,
) {

  # PE Agent should, by default, automatically match the agent version on the PE Server
  if $package_version == undef and is_function_available('pe_compiling_server_aio_build') {
    $_package_version = pe_compiling_server_aio_build()
  } else {
    $_package_version = $package_version
  }

  # This if statement will optionally exclude production like environments (for change control)
  if $manage_production or
    ( "${facts['application_environment']} " !~ /pro?d/ and $trusted['certname'] !~ /^.....1/ ) {
    class { 'puppet_agent':
      package_version => $_package_version,
    }
  }

  # move puppet windows events out of the Application log into a new log named Puppet
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
      data    => 'C:\Program Files\Puppet Labs\Puppet\puppet\bin\puppetres.dll',
      notify  => Exec['Force_restart_eventlog'],
      require => Registry_key['Puppet_Puppet'],
    }
    exec { 'Force_restart_eventlog':
      command     => 'Restart-Service -Name EventLog -Force',
      refreshonly => true,
      provider    => powershell,
    }
  }

}
