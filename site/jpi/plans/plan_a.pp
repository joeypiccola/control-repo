plan jpi::plan_a (
  TargetSpec $node,
) {
  $vcenter = lookup('jpi::vcenter')
  $svc_vmware_username = lookup('jpi::svc_vmware_username')
  $svc_vmware_password = lookup('jpi::svc_vmware_password')
  run_task('jpi::getvm', $node, username => $svc_vmware_username, password => $svc_vmware_password, vcenter => $vcenter)
}
