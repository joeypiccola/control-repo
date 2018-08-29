# == Class: profile::base::powershell
class profile::base::powershell (
) {

  include profile::base::chocolatey

  package { 'powershell':
    ensure   => '5.1.14409.20180105',
    provider => 'chocolatey',

  }

}
