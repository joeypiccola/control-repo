plan jpi::rt (
  TargetSpec $nodes,
  String $serial,
  String $label,
) {
    run_task('jpi::disk_set_status', $nodes, '_catch_errors' => true, status => 'online', serial => $serial)
    run_task('jpi::volume_set_label', $nodes, '_catch_errors' => true, label => $label, serial => $serial)
    run_task('jpi::cluster_add_disk', $nodes, '_catch_errors' => true, name => $label, serial => $serial)
}
