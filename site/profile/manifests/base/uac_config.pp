# == Class: profile::uac_config
class profile::uac_config (
) {

  class { 'msuac':
    enabled => false,
    prompt  => disabled,
  }

}