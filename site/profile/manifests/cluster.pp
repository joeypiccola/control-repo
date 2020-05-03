# == Class: profile::cluster
class profile::cluster {
  include profile::cluster::test
  #include profile::cluster::cluster
  #include profile::cluster::clusterdisk
  #include profile::cluster::clusternetwork
  #include profile::cluster::clusterprefferedowner
  #include profile::cluster::clusterproperty
  #include profile::cluster::clusterquorum
  include profile::cluster::services
  #include profile::cluster::waitforcluster
}
