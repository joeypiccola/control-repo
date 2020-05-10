# == Class: profile::cluster::clusterproperty
class profile::cluster::clusterproperty (
  String $dsc_name,
  String $dsc_clusterloglevel,
  String $dsc_clusterlogsize,
  String $dsc_description,
  String $dsc_master,
  String $user,
  String $pass,
) {

  if $facts['hostname'] == $dsc_master {
    dsc_xclusterproperty {'set_cluster_properties':
      dsc_name                 => $dsc_name,
      dsc_clusterloglevel      => $dsc_clusterloglevel,
      dsc_clusterlogsize       => $dsc_clusterlogsize,
      dsc_description          => $dsc_description,
      dsc_psdscrunascredential => {
        'user'     => $user,
        'password' => Sensitive($pass)
      },
    }
  }

}
