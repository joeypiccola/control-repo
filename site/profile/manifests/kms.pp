# == Class: profile::kms
class profile::kms (
  $key_management_service_name,
  $key_management_service_port,
) {

  class { 'kms_win':
    key_management_service_name => $key_management_service_name,
    key_management_service_port => $key_management_service_port,
  }

}