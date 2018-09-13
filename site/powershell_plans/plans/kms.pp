# == Plan: powershell_plans::kms
plan powershell_plans::kms (
) {
  run_task('kms_win::slmgr_ato')
}
