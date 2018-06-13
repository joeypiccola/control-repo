# == Class: profile::base::uac_config
class profile::base::uac_config (
) {

  class { 'msuac':
    enabled => false,
    prompt  => disabled,
  }

}
