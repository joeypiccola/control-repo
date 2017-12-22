# == Class: profile::wsus_config
class profile::wsus_config (
  $server_url
) {

  class { 'wsus_client':
    server_url                => $server_url,
    enable_status_server      => true,
    auto_update_option        => 'AutoNotify',
    detection_frequency_hours => 1,
    target_group              => 'ad.piccola.us',
  }

}
