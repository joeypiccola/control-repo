# == Class: profile::base::updatereporting
class profile::base::updatereporting (
) {
  # take '2.0', make it '2', and then force it to 2 (i.e. an integer)
  $psmajor = 0 + (split($facts['powershell_version'], '[.]'))[0]
  if $psmajor > 2 {
    include updatereporting_win
  }
}
