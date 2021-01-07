plan jpi::ct_get_nodes (
  TargetSpec $nodes
) {
    $cluster_nodes = run_task('jpi::get_cluster_nodes', $nodes)
    $clusternode_names = get_targets($cluster_nodes).map |$n| { $n.name }
    run_task('jpi::new_file', $clusternode_names)
}
