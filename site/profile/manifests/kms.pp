# == Class: profile::kms
class profile::kms (
  $KeyManagementServiceName,
  $KeyManagementServicePort,
) {

  class { 'kms_win':
    KeyManagementServiceName =>
    KeyManagementServicePort => 
  }

}