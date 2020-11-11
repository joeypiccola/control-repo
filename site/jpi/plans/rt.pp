plan jpi::rt (
  TargetSpec $nodes,
  #String $serial,
  String $label_key,
  String $label_new,
) {
    run_task('jpi::disk_set_status', $nodes, '_catch_errors' => true, status => 'online', serial => $serial)
    run_command('Start-Sleep -Seconds 20', $nodes)
    run_task('jpi::volume_set_label', $nodes, '_catch_errors' => true, label_key => $label_key, label_new => $label_new)
    run_task('jpi::cluster_add_disk', $nodes, '_catch_errors' => true, name => $label_new, serial => $serial)
    #run_task('jpi::cluster_add_csv', $nodes, '_catch_errors' => true, disk_resouce_name => $new_label)
    #run_task('jpi::disk_new_guid', $nodes, '_catch_errors' => true, serial => $serial)
}
