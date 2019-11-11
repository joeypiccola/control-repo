plan powershell_tasks::getservice (
  TargetSpec $nodes,
  String $service
) {
  return run_command("Get-Service -Name ${service}", $nodes)
}
