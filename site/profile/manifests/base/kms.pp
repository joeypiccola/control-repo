# == Class: profile::base::kms
class profile::base::kms (
  $key_management_service_name,
) {

  class { 'kms_win':
    key_management_service_name => $key_management_service_name,
  }

}
