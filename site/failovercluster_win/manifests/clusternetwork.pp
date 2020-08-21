# == Class: failovercluster_win::clusternetwork
class failovercluster_win::clusternetwork {

  dsc_xclusternetwork {'client_network':
    dsc_address     => $failovercluster_win::client_network_address,
    dsc_addressmask => $failovercluster_win::client_network_address_mask,
    dsc_name        => $failovercluster_win::client_network_name,
    dsc_role        => $failovercluster_win::client_network_role,
  }

  if $failovercluster_win::network_strategy == 'separate_cluster_client_network' {
    dsc_xclusternetwork {'cluster_network':
      dsc_address     => $failovercluster_win::cluster_network_address,
      dsc_addressmask => $failovercluster_win::cluster_network_address_mask,
      dsc_name        => $failovercluster_win::cluster_network_name,
      dsc_role        => $failovercluster_win::cluster_network_role,
    }
  }

}
