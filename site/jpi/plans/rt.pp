plan jpi::rt (
  TargetSpec $nodes,
  String $serial,
  String $label,
  String $new_label,
) {
    run_task('jpi::disk_set_status', $nodes, '_catch_errors' => true, status => 'online', serial => $serial)
    run_task('jpi::disk_new_guid', $nodes, '_catch_errors' => true, serial => $serial)
    run_task('jpi::volume_set_label', $nodes, '_catch_errors' => true, new_label => $new_label, label => $label)
    run_task('jpi::cluster_add_disk', $nodes, '_catch_errors' => true, name => $label, serial => $serial)
    #run_task('jpi::cluster_add_csv', $nodes, '_catch_errors' => true, disk_resouce_name => $new_label)

}
