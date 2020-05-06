# == Class: profile::cluster::clusternetwork
class profile::cluster::clusternetwork (
  String $dsc_address,
  String $dsc_addressmask,
  #String $dsc_name,
  #String $dsc_role,
) {

  dsc_xclusternetwork {'properties':
    dsc_address     => $dsc_address,
    dsc_addressmask => $dsc_addressmask,
    #dsc_name        => $dsc_name,
    #dsc_role        => $dsc_role,
  }

}
