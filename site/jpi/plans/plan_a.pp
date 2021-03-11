plan jpi::plan_a (
  TargetSpec $nodes,
) {
  $some_value = lookup('something::some_value')

  run_task('jpi::create_file', $node, file_contents => $some_value)
}

