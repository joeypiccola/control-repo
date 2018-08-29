# == Class: profile::patching::pswindowsupdate_config
class profile::patching::pswindowsupdate_config (
) {

  include profile::base::chocolatey

  package { '7zip':
    ensure   => '18.5.0.20180730',
    provider => 'chocolatey',
  }

  package { 'pswindowsupdate':
    ensure   => '2.0.0.4',
    provider => 'chocolatey',
    require  => Package['7zip'],
  }

}
