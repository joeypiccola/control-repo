# == Class: failovercluster_win::clusterproperty
class failovercluster_win::clusterproperty {

  if $facts['hostname'] == $failovercluster_win::primary_node {
    dsc_xclusterproperty {'set_cluster_properties':
      dsc_name                 => $failovercluster_win::cluster_name,
      dsc_clusterloglevel      => $failovercluster_win::log_level,
      dsc_clusterlogsize       => $failovercluster_win::log_size,
      dsc_description          => $failovercluster_win::description,
      dsc_psdscrunascredential => {
        'user'     => $failovercluster_win::ad_user,
        'password' => Sensitive($failovercluster_win::ad_password)
      },
    }
  }

}
