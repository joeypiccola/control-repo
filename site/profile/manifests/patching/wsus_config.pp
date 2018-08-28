# == Class: profile::patching::wsus_config
class profile::patching::wsus_config (
) {

  class { 'wsus_client':
    auto_update_option                  => 'AutoNotify',
    scheduled_install_hour              => 2,
    detection_frequency_hours           => 6,
    no_auto_reboot_with_logged_on_users => false,
    reboot_relaunch_timeout_minutes     => 2,
    server_url                          => 'http://wsus.ad.piccola.us:8530',
    target_group                        => 'Saturday Patch Group',
  }

}
