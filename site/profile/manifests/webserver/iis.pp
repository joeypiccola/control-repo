# == Class: profile::webserver::iis
class profile::webserver::iis (
  Optional[Boolean] $disable_default_website = $true
) {

  $iis_features = ['Web-WebServer','Web-Mgmt-Tools','Web-Mgmt-Console']
  iis_feature { $iis_features:
    ensure => 'present',
  }

  if $disable_default_website {
    iis_site {'Default Web Site':
      ensure          => absent,
      applicationpool => 'DefaultAppPool',
      require         => Iis_feature['Web-WebServer'],
    }
  }

}
