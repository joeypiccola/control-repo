plan jpi::wu (
  TargetSpec $nodes
) {
  # run task to get updates
  $wu_report_task_result = run_task('jpi::wu_report', $nodes, '_catch_errors' => true, update_report => 'missing')

  # nodes that succeeded to run the task
  $succeeded = $wu_report_task_result.ok_set |$result| { $result }.names
  out::message("succeeded: ${succeeded}}")

  # nodes that failed to run the task
  # $failed = $wu_report_task_result.error_set |$result| { $result }.names
  # out::message("failed: ${failed}}")

  # # parse out targets from the previous task that has missing updates
  # $targets_with_updates = $wu_report_task_result.filter_set |$result| { $result['missing_update_count'] > 0 }.targets
  # # if no nodes to update then break
  # if ($targets_with_updates.empty) {
  #   # "Breaking on iteration ${i}"
  #   break
  # }
}
