# == Class: profile::webserver::iis
class profile::webserver::iis (
) {

  $iis_features = ['web-webserver','Web-Mgmt-Tools','Web-Mgmt-Console']
  iis_feature { $iis_features:
    ensure => 'present',
  }

  # remove default web site
  iis_site {'Default Web Site':
    ensure          => absent,
    applicationpool => 'DefaultAppPool',
  }

}
