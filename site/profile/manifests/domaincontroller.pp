# == Class: profile::domaincontroller
class profile::domaincontroller (
  String $domain_name                   = 'contoso.com',
  String $ad_user                       = 'Administrator',
  String $ad_password                   = '>H!Hok~T2M,3',
  String $safemodeadministratorpassword = '-N@St.kQJgW#',
) {

  # if deployed with a custom domain_name fact then use it
  if $facts['domain_name'] {
    $dsc_domain_name = $facts['domain_name']
  } else {
    $dsc_domain_name = $domain_name
  }

  # install features
  $features = ['AD-Domain-Services','RSAT-AD-PowerShell']
  windowsfeature { $features:
    ensure => 'present',
  }

  if $facts['hostname'] =~ /01/ {
    notify { '01':
      message => 'I am 01.',
    }
    dsc_xaddomain {'create':
      dsc_domainadministratorcredential => {
        'user'     => $ad_user,
        'password' => Sensitive($ad_password),
      },
      dsc_safemodeadministratorpassword => {
        'user'     => 'dummy',
        'password' => Sensitive($safemodeadministratorpassword),
      },
      dsc_domainname                    => $dsc_domain_name,
      dsc_forestmode                    => 'WinThreshold',
      require                           => Windowsfeature[$features],
    }
  } else {
    notify { 'not_01':
      message => 'I am not 01.',
    }
  }

}
