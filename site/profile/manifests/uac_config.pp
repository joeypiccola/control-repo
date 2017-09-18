# == Class: profile::uac_config
class profile::uac_config (
  $timezone
) {

  class { 'msuac':
    enabled => false,
    prompt  => disabled,
  }

}