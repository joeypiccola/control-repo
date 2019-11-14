plan jpi::patch_engine (
  TargetSpec $nodes
) {
  ## ROUND #1
  # get needed updates
  $get_updates_1 = run_task('jpi::get_updates', $nodes)
  # get system(s) that have missing updates
  $targets_with_updates_1 = $get_updates_1.filter_set |$result| { $result['count'] > 0 }.targets
  # if there are no systems missing updates then exit
  if ($targets_with_updates_1.empty) {
    break
  }
  # install updates on nodes
  run_task('jpi::install_updates', $targets_with_updates_1)
  # reboot the system
  run_plan('reboot', $targets_with_updates_1)

  ## ROUND #2
  # get needed updates
  $get_updates_2 = run_task('jpi::get_updates', $nodes)
  # get system(s) that have missing updates
  $targets_with_updates_2 = $get_updates_2.filter_set |$result| { $result['count'] > 0 }.targets
  # if there are no systems missing updates then exit
  if ($targets_with_updates_2.empty) {
    break
  }
  # install updates on nodes
  run_task('jpi::install_updates', $targets_with_updates_2)
  # reboot the system
  run_plan('reboot', $targets_with_updates_2)

  ## ROUND #3
  # get needed updates
  $get_updates_3 = run_task('jpi::get_updates', $nodes)
  # get system(s) that have missing updates
  $targets_with_updates_3 = $get_updates_3.filter_set |$result| { $result['count'] > 0 }.targets
  # if there are no systems missing updates then exit
  if ($targets_with_updates_3.empty) {
    break
  }
  # install updates on nodes
  run_task('jpi::install_updates', $targets_with_updates_3)
  # reboot the system
  run_plan('reboot', $targets_with_updates_3)
}
