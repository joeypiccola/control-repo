# == Class: profile::domaincontroller
class profile::domaincontroller {

  if $facts['hostname'] =~ /01/ {
    notify { '01':
      message => 'I am 01.',
    }
  } else {
    notify { 'not_01':
      message => 'I am not 01.',
    }
  }

}
