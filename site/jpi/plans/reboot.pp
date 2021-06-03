plan jpi::reboot (
  TargetSpec $nodes,
) {
  run_plan('reboot', $nodes,
    message           => 'Post DC promotion reboot. Triggered via Puppet.',
    reconnect_timeout => 600, # check for a total of 600s if system is back up
    retry_interval    => 10,  # check every 10s to see if system is back up
    disconnect_wait   => 20,  # how long to wait after reboot to start checking if system is back up
  )
}
