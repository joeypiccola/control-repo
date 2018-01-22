# == Class: profile::updatereporting
class profile::updatereporting (
  $download_directory,
  $pswindowsupdate_url,
  $pswindowsupdate_force_download,
  $wsusscn_url,
  $task_day_of_week,
  $task_every,
  $task_schedule,
  $task_enabled,
  $task_ensure,
) {

  class { 'updatereporting_win':
    pswindowsupdate_url            => $pswindowsupdate_url,
    pswindowsupdate_force_download => $pswindowsupdate_force_download,
    wsusscn_url                    => $wsusscn_url,
    download_directory             => $download_directory,
    task_day_of_week               => $task_day_of_week,
    task_every                     => $task_every,
    task_ensure                    => $task_ensure,
    task_schedule                  => $task_schedule,
    task_enabled                   => $task_enabled,
  }

}
