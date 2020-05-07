# == Class: profile::cluster
class profile::cluster {
  include profile::cluster::cluster
  include profile::cluster::clusternetwork
  #include profile::cluster::clusterprefferedowner
  include profile::cluster::clusterproperty
  include profile::cluster::clusterquorum
  include profile::cluster::services

  Class['profile::cluster::services']
  -> Class['profile::cluster::cluster']
  -> Class['profile::cluster::clusternetwork']
  -> Class['profile::cluster::clusterquorum']
  -> Class['profile::cluster::clusterproperty']
}
