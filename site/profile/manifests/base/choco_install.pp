# == Class: profile::base::choco_install
class profile::base::choco_install (
  $chocolatey_download_url,
  $chocolatey_version,
) {

  class {'chocolatey':
    chocolatey_download_url       => $chocolatey_download_url,
    use_7zip                      => false,
    choco_install_timeout_seconds => 2700,
    chocolatey_version            => $chocolatey_version,
  }

}
