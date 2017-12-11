# == Class: profile::puppet_agent
class profile::puppet_agent (
) {
    class { 'puppet_agent' :
    package_version => '5.0.0',
  }
}
