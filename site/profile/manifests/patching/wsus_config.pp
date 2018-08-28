# == Class: profile::base::wsus_config
class profile::base::wsus_config (
) {

  class { 'wsus_client':
    auto_update_option                  => 'Scheduled',
    scheduled_install_day               => 'Tuesday',
    scheduled_install_hour              => 2,
    detection_frequency_hours           => 6,
    no_auto_reboot_with_logged_on_users => false,
    reboot_relaunch_timeout_minutes     => 2,
  }

}
