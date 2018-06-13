# == Class: role::jenkins
class role::jenkins {
  include profile::base
  include profile::jenkins::jenkins_install
}
