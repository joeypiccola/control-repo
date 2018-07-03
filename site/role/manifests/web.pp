# == Class: role::web
class role::web {
  include profile::base
  include profile::base::crypto
  include profile::web::install
  include profile::web::config
}
