# == Class: profile::kms
class profile::kms (
  $KeyManagementServiceName,
  $KeyManagementServicePort,
) {

  class { 'kms_win':
    KeyManagementServiceName => $keymanagementservicename,
    KeyManagementServicePort => $keymanagementmerviceport,
  }

}