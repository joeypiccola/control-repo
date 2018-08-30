# == Class: profile::base::notify
class profile::base::notify (
) {


  case $facts['powershell_version'] {
    /^5\./: {
      notify { 'ps_five':
        name    => '5 name',
        message => 'ps 5 detected',
      }
    }
    /^4\./: {
      notify { 'ps_four':
        name    => '4 name',
        message => 'ps 4 detected',
      }
    }
    /^3\./: {
      notify { 'ps_three':
        name    => '3 name',
        message => 'ps 3 detected',
      }
    }
    default: {
      notify { 'noMatch':
        name    => 'no match',
        message => 'no match',
      }
    }
  }


}
