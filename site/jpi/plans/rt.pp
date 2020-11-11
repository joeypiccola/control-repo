plan jpi::rt (
  TargetSpec $nodes,
  String $serial,
  String $label_key,
  String $label_new,
) {
    run_task('jpi::disk_set_status', $nodes, status => 'online', serial => $serial)
    run_task('jpi::volume_set_label', $nodes, label_key => $label_key, label_new => $label_new)
    run_task('jpi::cluster_add_disk', $nodes, name => $label_new, serial => $serial)
    #run_task('jpi::cluster_add_csv', $nodes, '_catch_errors' => true, disk_resouce_name => $new_label)
    #run_task('jpi::disk_new_guid', $nodes, '_catch_errors' => true, serial => $serial)
}
