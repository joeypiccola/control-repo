# == Class: role::web_server
class role::web_server {

  #This role would be made of all the profiles that need to be included to make a webserver work
  #All roles should include the base profile
  include profile::base
  include profile::iis_install
  include profile::iis_config

}
