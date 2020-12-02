plan jpi::ct_cluster_node (
  TargetSpec $nodes,
  String $serial,
  String $action,
  String $label_new,
) {
  if ($action == 'add') {
    run_task('jpi::disk_set_status', $nodes, status => 'online', serial => $serial)
    run_task('jpi::cluster_set_disk', $nodes, name => $label_new, serial => $serial, status => 'add')
    # add to CSV
  }

  if ($action == 'remove') {
    # remove from CSV
    run_task('jpi::cluster_set_disk', $nodes, name => $label_new, status => 'remove')
    run_task('jpi::disk_set_status', $nodes, status => 'offline', serial => $serial)
  }

}
