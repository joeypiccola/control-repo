plan jpi::wu (
  TargetSpec $nodes,
  String $service
) {
  return run_task('jpi::wu_report', $nodes, update_report => 'missing')
}
