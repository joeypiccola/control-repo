plan jpi::getservice_a (
  TargetSpec $nodes,
  String $service
) {
  return run_command("Get-Service -Name ${service}", $nodes)
}
