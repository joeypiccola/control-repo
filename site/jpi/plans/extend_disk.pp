plan jpi::extend_disk (
  TargetSpec $target_node,
  String     $drive_letter,
) {
  # lookup values needed to make changes in VMware
  $vcenter = lookup('jpi::vcenter')
  $svc_vmware_username = lookup('jpi::svc_vmware_username')
  $svc_vmware_password = lookup('jpi::svc_vmware_password')
  $powercli_proxy_host = lookup('jpi::powercli_proxy_host')
  # set single TargetSpec from the previously lookup'd powercli_proxy_host
  $powercli_proxy_host_target = get_target($powercli_proxy_host)
  run_task('jpi::getvm', $powercli_proxy_host_target,
    username    => $svc_vmware_username,
    password    => $svc_vmware_password,
    vcenter     => $vcenter,
    target_node => $target_node,
  )
}
