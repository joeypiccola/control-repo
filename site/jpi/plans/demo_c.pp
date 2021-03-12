plan jpi::demo_c (
  String $service
) {
  $target_node = 'jenkins.ad.piccola.us'
  run_command('<#   get_mailbox   #>', $target_node)
  run_command('<#   parse_email   #>', $target_node)
  run_command('<#   delete_spam   #>', $target_node)
  run_command('<#   remove_all_training   #>', $target_node)
  run_command('<#   analyze_email   #>', $target_node)
  run_command('<#   analyze_more_email   #>', $target_node)
  run_command('<#   analyze_even_more_email   #>', $target_node)
  run_command('<#   so_much_email   #>', $target_node)
  run_command('<#   forward_all_email   #>', $target_node)
}
