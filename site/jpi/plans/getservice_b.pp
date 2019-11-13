plan jpi::getservice_b (
  TargetSpec $nodes,
  String $service
) {
  return run_command("Get-Service -Name ${service} | ConvertTo-JSON", $nodes)
}
