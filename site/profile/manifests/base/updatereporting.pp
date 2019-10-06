# == Class: profile::base::updatereporting
class profile::base::updatereporting (
) {
  $psmajor = split($facts['powershell_version'], '[.]')
  if $psmajor[0] > 2 {
    include updatereporting_win
  }
}
