# == Class: profile::reboot
class profile::reboot (
) {

  schedule { 'maint':
    range  => '2 - 4',
    period => daily,
    repeat => 1,
  }

  reboot { 'reboot':
    timeout  => 10,
    schedule => 'maint'
  }

}