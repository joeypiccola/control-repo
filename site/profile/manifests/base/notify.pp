# == Class: profile::base::notify
class profile::base::notify (
) {


  case $facts['powershell_version'] {
    # /^5\./: {
    #   notify { 'ps_five':
    #     name    => '5 name',
    #     message => 'ps 5 detected',
    #   }
    # }
    /^4\.|5\./: {
      notify { 'ps_four':
        name    => '4 or 5 name',
        message => 'ps 4 or 5 detected',
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

  $psmajor = split($facts['powershell_version'], '[.]')
  if $psmajor[0] == 5 {
    notify { 'psmajor':
      name    => 'maybe this is the version of powershell.major',
      message => $psmajor[0],
    }
  }
}
