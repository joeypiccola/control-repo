# == Class: profile::cluster::clusterproperty
class profile::cluster::clusterproperty (
  String $dsc_name,
  String $dsc_clusterloglevel,
  String $dsc_clusterlogsize,
  String $dsc_description,
  String $dsc_master,
  String $dsc_psdscrunascredential_user = $profile::cluster::cluster::dsc_domainadministratorcredential_user,
  String $dsc_psdscrunascredential_password = $profile::cluster::cluster::dsc_domainadministratorcredential_password,
) {

  if $facts['hostname'] == $dsc_master {
    dsc_xclusterproperty {'set_cluster_properties':
      dsc_name                 => $dsc_name,
      dsc_clusterloglevel      => $dsc_clusterloglevel,
      dsc_clusterlogsize       => $dsc_clusterlogsize,
      dsc_description          => $dsc_description,
      dsc_psdscrunascredential => {
        'user'     => $dsc_psdscrunascredential_user,
        'password' => Sensitive($dsc_psdscrunascredential_password)
      },
    }
  }

}
