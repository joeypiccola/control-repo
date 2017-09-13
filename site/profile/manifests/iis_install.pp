# == Class: profile::iis_install
class profile::iis_install (
) {

  $iis_features = ['web-server','web-webserver','Web-Common-Http','Web-Static-Content']
  
  iis_feature { $iis_features:
    ensure                   => 'present',
    include_management_tools => true,
  }
}