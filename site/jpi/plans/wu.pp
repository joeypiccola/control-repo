plan jpi::wu (
  TargetSpec $nodes
) {
  # run task to get updates
  $wu_report_task_result = run_task('jpi::wu_report', $nodes, update_report => 'missing')
  # nodes that succeeded to run the task
  $succeeded = $wu_report_task_result.ok_set
  out::message("succeeded: ${succeeded}.names}")
  # nodes that failed to run the task
  $failed = $wu_report_task_result.error_set
  out::message("failed: ${failed}.names}")

  # # parse out targets from the previous task that has missing updates
  # $targets_with_updates = $wu_report_task_result.filter_set |$result| { $result['missing_update_count'] > 0 }.targets
  # # if no nodes to update then break
  # if ($targets_with_updates.empty) {
  #   # "Breaking on iteration ${i}"
  #   break
  # }
}
