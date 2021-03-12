plan jpi::demo_c (
  String $service
) {
  $target_node = 'jenkins.ad.piccola.us'
  run_command('# forward email', $nodes)
  run_command('# forward more email', $nodes)
}
