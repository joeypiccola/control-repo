plan jpi::patch_engine (
  TargetSpec $nodes
) {
  ## ROUND #1
  # get needed updates
  $get_updates = run_task('jpi::get_updates', $nodes)
  # get system(s) that have missing updates
  $targets_with_updates = $get_updates.filter_set |$result| { $result['count'] > 0 }.targets
  # if there are no systems missing updates then exit
  if ($targets_with_updates.empty) {
    break
  }
  # install updates on nodes
  run_task('jpi::install_updates', $targets_with_updates)
  # reboot the system
  run_plan('reboot', $targets_with_updates)

  ## ROUND #2
  # get needed updates
  $get_updates = run_task('jpi::get_updates', $nodes)
  # get system(s) that have missing updates
  $targets_with_updates = $get_updates.filter_set |$result| { $result['count'] > 0 }.targets
  # if there are no systems missing updates then exit
  if ($targets_with_updates.empty) {
    break
  }
  # install updates on nodes
  run_task('jpi::install_updates', $targets_with_updates)
  # reboot the system
  run_plan('reboot', $targets_with_updates)

  ## ROUND #3
  # get needed updates
  $get_updates = run_task('jpi::get_updates', $nodes)
  # get system(s) that have missing updates
  $targets_with_updates = $get_updates.filter_set |$result| { $result['count'] > 0 }.targets
  # if there are no systems missing updates then exit
  if ($targets_with_updates.empty) {
    break
  }
  # install updates on nodes
  run_task('jpi::install_updates', $targets_with_updates)
  # reboot the system
  run_plan('reboot', $targets_with_updates)
}
