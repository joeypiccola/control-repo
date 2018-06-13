# == Class: profile::base::choco_install
class profile::base::choco_install (
  $chocolatey_download_url,
) {

  class {'chocolatey':
    chocolatey_download_url       => $chocolatey_download_url,
    use_7zip                      => false,
    choco_install_timeout_seconds => 2700,
  }

}