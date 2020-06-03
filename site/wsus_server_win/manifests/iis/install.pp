# == Class: wsus_server_win::iis::install
class wsus_server_win::iis::install {
  iis_feature { $wsus_server_win::iis_features:
    ensure => 'present',
  }
}
