# == Class: profile::wsus_config
class profile::wsus_config (
) {

  class { 'wsus_client':
    auto_update_option        => "Scheduled",
    scheduled_install_day     => "Monday",
    scheduled_install_hour    => 2,
    detection_frequency_hours => 6,
  }

}
