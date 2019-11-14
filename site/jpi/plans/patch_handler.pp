plan jpi::patch_handler (
  TargetSpec $nodes
) {
  run_plan('jpi::patch_engine', $nodes)
}
