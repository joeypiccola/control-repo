plan getservice_s (
  TargetSpec $nodes,
  String $service
) {
  return run_command("Get-Service -Name ${service}", $nodes)
}
