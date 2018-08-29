# == Class: profile::base::powershell
class profile::base::powershell (
) {

  package { 'powershell':
    ensure   => '5.1.14409.20180105',
    provider => 'chcolatey',

  }

}
