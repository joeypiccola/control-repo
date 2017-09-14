# == Class: profile::wsus_config
class profile::wsus_config (
) {

  class { 'wsus_client':
    server_url                => 'http://box.ad.piccola.us:8530',
    enable_status_server      => true,
    auto_update_option        => 'AutoNotify',
    detection_frequency_hours => 2,
    target_group              => 'ad.piccola.us',
  }
}