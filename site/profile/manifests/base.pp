# == Class: profile::base
class profile::base (
) {
  include profile::chocolatey
  include profile::packages
}