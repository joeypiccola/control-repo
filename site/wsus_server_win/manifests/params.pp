# == Class: wsus_server_win::params
class wsus_server_win::params {
  $iis_features = ['Web-WebServer','Web-Mgmt-Tools','Web-Mgmt-Console']
  $wsus_directory = undef
  $wsus_features = ['UpdateServices','UpdateServices-Services','UpdateServices-RSAT','UpdateServices-API','UpdateServices-UI']
}
