plan jpi::getservice_a (
  TargetSpec $nodes,
  String $service
) {
  run_command("Get-Service -Name ${service} | ConvertTo-Json -Depth 1", $nodes)
}
