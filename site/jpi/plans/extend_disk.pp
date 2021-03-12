plan jpi::extend_disk (
  TargetSpec $target_node,
  String     $drive_letter,
  Integer    $gb_to_add,
) {
  # lookup values needed to make changes in VMware
  $vcenter = lookup('jpi::vcenter')
  $svc_vmware_username = lookup('jpi::svc_vmware_username')
  $svc_vmware_password = lookup('jpi::svc_vmware_password')
  $powercli_proxy_host = lookup('jpi::powercli_proxy_host')
  # set single TargetSpec from the previously lookup'd powercli_proxy_host
  $powercli_proxy_host_target = get_target($powercli_proxy_host)
  # validate target_node in vmware (does it exist)
  run_task('jpi::validate_target_node_vmware', $powercli_proxy_host_target,
    username    => $svc_vmware_username,
    password    => $svc_vmware_password,
    vcenter     => $vcenter,
    target_node => $target_node,
  )
  # validate target_node disk (does it exist)
  run_task('jpi::validate_target_node_disk', $target_node,
    drive_letter => $drive_letter,
  )
  # extend disk in vmware
  run_task('jpi::extend_disk_vmware', $powercli_proxy_host_target,
    username    => $svc_vmware_username,
    password    => $svc_vmware_password,
    vcenter     => $vcenter,
    target_node => $target_node,
    gb_to_add   => $gb_to_add,
  )
  # rescan disks on target_node
  run_task('jpi::disk_rescan', $target_node)
  # extend disk on target_node
  run_task('jpi::extend_disk_target_node', $target_node,
    drive_letter => $drive_letter,
    gb_to_add    => $gb_to_add,
  )
}
