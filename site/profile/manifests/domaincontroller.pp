# == Class: profile::domaincontroller
class profile::domaincontroller (
  String $ad_user,
  String $ad_password,
  String $safemodeadministratorpassword,
  String $domain_name = 'contoso.com',
) {

  # if deployed with a custom domain_name fact then use it
  if $facts['domain_name'] {
    $dsc_domain_name = $facts['domain_name']
  } else {
    $dsc_domain_name = $domain_name
  }

  # install features
  $features = ['AD-Domain-Services','RSAT-AD-PowerShell', 'RSAT-ADDS']
  windowsfeature { $features:
    ensure => 'present',
  }

  if $facts['hostname'] =~ /01/ {
    # stuff for first DC
    dsc_xaddomain {'create':
      dsc_domainadministratorcredential => {
        'user'     => $ad_user,
        'password' => Sensitive($ad_password),
      },
      dsc_safemodeadministratorpassword => {
        'user'     => 'notused',
        'password' => Sensitive($safemodeadministratorpassword),
      },
      dsc_domainname                    => $dsc_domain_name,
      dsc_forestmode                    => 'WinThreshold',
      require                           => Windowsfeature[$features],
    }
  } else {
    # stuff for all other DCs
    dsc_xaddomaincontroller {'add':
      dsc_domainadministratorcredential => {
        'user'     => "${dsc_domain_name}\\${ad_user}",
        'password' => Sensitive($ad_password),
      },
      dsc_safemodeadministratorpassword => {
        'user'     => 'notused',
        'password' => Sensitive($safemodeadministratorpassword),
      },
      dsc_domainname                    => $dsc_domain_name,
      require                           => [
        Dsc_xwaitforaddomain['wait'],
        Windowsfeature[$features],
      ]
    }

    dsc_xwaitforaddomain {'wait':
      dsc_domainname           => $dsc_domain_name,
      dsc_domainusercredential => {
        'user'     => "${dsc_domain_name}\\${ad_user}",
        'password' => Sensitive($ad_password),
      },
    }
  }

  reboot { 'dsc_reboot' :
    message => 'DSC has requested a reboot',
    when    => 'pending',
    onlyif  => 'pending_dsc_reboot',
  }

}
