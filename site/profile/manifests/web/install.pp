# == Class: profile::web::install
class profile::web::install (
  Optional[Boolean] $iis = undef
) {

  if ($iis) {

    # install IIS
    $iis_features_old = ['web-server','web-webserver','Web-Common-Http','Web-Static-Content','Web-Mgmt-Tools','Web-Mgmt-Console','Web-Windows-Auth','Web-Stat-Compression','Web-Dyn-Compression','Web-Dir-Browsing','Web-Http-Errors','Web-Http-Logging','Web-Default-Doc','Web-Asp-Net','Web-Includes','Web-Filtering','Web-Mgmt-Service','Web-Security','Web-Basic-Auth','Web-Performance','Web-Request-Monitor','Web-App-Dev','Web-Health','Web-Http-Redirect']
    $iis_features = ['web-webserver','Web-Asp-Net']

    iis_feature { $iis_features:
      ensure => 'present',
    }

  }

}
