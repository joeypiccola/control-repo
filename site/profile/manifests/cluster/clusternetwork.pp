# == Class: profile::cluster::clusternetwork
class profile::cluster::clusternetwork (
  String $dsc_client_address,
  String $dsc_client_addressmask,
  String $dsc_client_name,
  String $dsc_client_role,
  #String $dsc_cluster_address,
  #String $dsc_cluster_addressmask,
  #String $dsc_cluster_name,
  #String $dsc_cluster_role,
) {

  dsc_xclusternetwork {'client_network':
    dsc_address     => $dsc_client_address,
    dsc_addressmask => $dsc_client_addressmask,
    dsc_name        => $dsc_client_name,
    dsc_role        => $dsc_client_role,
  }

  #dsc_xclusternetwork {'cluster_network':
  #  dsc_address     => $dsc_cluster_address,
  #  dsc_addressmask => $dsc_cluster_addressmask,
  #  dsc_name        => $dsc_cluster_name,
  #  dsc_role        => $dsc_cluster_role,
  #}

}
