plan jpi::ct_get_nodes (
  TargetSpec $nodes
) {
    $cluster_nodes = run_task('jpi::get_cluster_nodes', $nodes)
    $cluster_targets = get_targets($cluster_nodes['data'])
    run_task('jpi::new_file', $cluster_targets)
}
