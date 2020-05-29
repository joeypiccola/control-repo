# == Class: failovercluster_win::clusternetwork
class failovercluster_win::clusternetwork {

  dsc_xclusternetwork {'client_network':
    dsc_address     => $failovercluster_win::client_network_address,
    dsc_addressmask => $failovercluster_win::client_network_address_mask,
    dsc_name        => $failovercluster_win::client_network_name,
    dsc_role        => $failovercluster_win::client_network_role,
  }

  #dsc_xclusternetwork {'cluster_network':
  #  dsc_address     => $dsc_cluster_address,
  #  dsc_addressmask => $dsc_cluster_addressmask,
  #  dsc_name        => $dsc_cluster_name,
  #  dsc_role        => $dsc_cluster_role,
  #}

}
