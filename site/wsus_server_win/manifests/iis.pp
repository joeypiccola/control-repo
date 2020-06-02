# == Class: wsus_server_win::iis
class wsus_server_win::iis {
  iis_feature { $wsus_server_win::iis_features:
    ensure => 'present',
  }
}
