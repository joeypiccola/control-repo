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
  notify { 'psmajor_0':
    name    => '0 maybe this is the version of powershell.major',
    message => $psmajor,
  }
  notify { 'psmajor_1':
    name    => '1 maybe this is the version of powershell.major',
    message => $psmajor[0],
  }
  if $psmajor[0] == 5 {
    notify { 'psmajor_2':
      name    => '2 maybe this is the version of powershell.major',
      message => $psmajor[0],
    }
  }
  if $psmajor[0] == '5' {
    notify { 'psmajor_3':
      name    => '3 maybe this is the version of powershell.major',
      message => $psmajor[0],
    }
  }

  exec { 'test':
    provider    => 'powershell',
    command     => '$oi = "hello"
                    write-output $oi
                    add-content -path "c:/oi.txt" -value $oi
                    new-item -path c:/blah.txt -itemtype file',
    refreshonly => true,
  }

}
