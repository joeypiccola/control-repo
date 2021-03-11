plan jpi::plan_a (
  TargetSpec $nodes,
) {
  $some_value = lookup('some_value')

  run_task('jpi::create_file', $nodes, file_contents => $some_value)
}

