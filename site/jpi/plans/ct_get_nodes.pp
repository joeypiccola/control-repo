plan jpi::ct_get_nodes (
  TargetSpec $nodes
) {
    $cluster_nodes = run_task('jpi::get_cluster_nodes', $nodes)
    out::message($cluster_nodes)
    $clusternode_names = get_targets($cluster_nodes)
    out::message($clusternode_names)
    #run_task('jpi::new_file', $clusternode_names)
}
