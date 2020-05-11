# == Class: profile::cluster::cluster
class profile::cluster::cluster (
  String  $dsc_domainadministratorcredential_password,
  String  $dsc_domainadministratorcredential_user,
  String  $dsc_master,
  String  $dsc_name,
  Integer $dsc_retrycount,
  Integer $dsc_retryintervalsec,
  String  $dsc_staticipaddress,
) {

  if $facts['hostname'] == $dsc_master {
    dsc_xcluster {'create':
      dsc_domainadministratorcredential => {
        'user'     => $dsc_domainadministratorcredential_user,
        'password' => Sensitive($dsc_domainadministratorcredential_password)
      },
      dsc_name                          => $dsc_name,
      dsc_staticipaddress               => $dsc_staticipaddress,
      require                           => Group['Administrators'],
    }
  } else {
    dsc_xwaitforcluster {'wait':
      dsc_name             => $dsc_name,
      dsc_retrycount       => $dsc_retrycount,
      dsc_retryintervalsec => $dsc_retryintervalsec,
    }
    dsc_xcluster {'add':
      dsc_domainadministratorcredential => {
        'user'     => $dsc_domainadministratorcredential_user,
        'password' => Sensitive($dsc_domainadministratorcredential_password)
      },
      dsc_name                          => $dsc_name,
      require                           => [
        Dsc_xWaitForCluster['wait'],
        Group['Administrators'],
      ],
    }
  }

}
