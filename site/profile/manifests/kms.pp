# == Class: profile::kms
class profile::kms (
  $key_management_service_name,
  $key_management_service_port,
) {

  class { 'kms_win':
    KeyManagementServiceName => $key_management_service_name,
    KeyManagementServicePort => $key_management_service_port,
  }

}