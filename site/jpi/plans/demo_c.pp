plan jpi::demo_c (
  String $service
) {
  $target_node = 'jenkins.ad.piccola.us'
  run_command('# forward email', $target_node)
  run_command('# forward more email', $target_node)
}
