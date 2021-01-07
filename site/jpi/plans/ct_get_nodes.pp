plan jpi::ct_get_nodes (
  TargetSpec $nodes
) {
    $cluster_nodes = run_task('jpi::get_cluster_nodes', $nodes)
    run_task('jpi::new_file', $cluster_nodes)
}
