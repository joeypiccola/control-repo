# == Class: profile::base::updatereporting
class profile::base::updatereporting (
) {
  $psmajor = 0 + (split($facts['powershell_version'], '[.]'))[0]
  if $psmajor[0] > 2 {
    include updatereporting_win
  }
}
