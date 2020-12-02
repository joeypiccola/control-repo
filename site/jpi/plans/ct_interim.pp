plan jpi::ct_interim (
  TargetSpec $nodes,
  Optional[String] $serial,
  Optional[String] $label_key,
  Optional[String] $label_new,
) {
    run_task('jpi::disk_set_status', $nodes, status => 'online', serial => $serial)
    run_task('jpi::volume_set_label', $nodes, label_key => $label_key, label_new => $label_new)
    run_task('jpi::disk_new_guid', $nodes, serial => $serial)
    run_task('jpi::disk_set_status', $nodes, status => 'offline', serial => $serial)
}
