plan jpi::plan_a (
  TargetSpec $nodes,
  String $message,
) {
  run_task('jpi::task_a', $nodes, message => $message)
  run_task('jpi::task_b', $nodes, message => $message)
  run_task('jpi::task_c', $nodes, message => $message)
}
