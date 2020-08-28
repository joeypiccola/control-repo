# == Class: failovercluster_win::cluster
class failovercluster_win::cluster {

  if $facts['hostname'] == $failovercluster_win::primary_node {
    dsc_xcluster {'create':
      dsc_domainadministratorcredential => {
        'user'     => $failovercluster_win::ad_user,
        'password' => Sensitive($failovercluster_win::ad_password)
      },
      dsc_name                          => $failovercluster_win::cluster_name,
      dsc_staticipaddress               => $failovercluster_win::cluster_ip,
      require                           => Group['Administrators'],
    }
  } else {
    dsc_xwaitforcluster {'wait':
      dsc_name             => $failovercluster_win::cluster_name,
      dsc_retrycount       => $failovercluster_win::ancillary_node_retry_count,
      dsc_retryintervalsec => $failovercluster_win::ancillary_node_retry_interval_sec,
    }
    dsc_xcluster {'add':
      dsc_domainadministratorcredential => {
        'user'     => $failovercluster_win::ad_user,
        'password' => Sensitive($failovercluster_win::ad_password)
      },
      dsc_name                          => $failovercluster_win::cluster_name,
      require                           => [
        Dsc_xwaitforcluster['wait'],
        Group['Administrators'],
      ],
    }
  }

}
