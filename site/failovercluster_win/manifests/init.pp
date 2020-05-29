# == Class failovercluster_win
class failovercluster_win (
  String  $ad_password,
  String  $ad_user,
  String  $client_network_address_mask,
  String  $client_network_address,
  String  $client_network_name,
  String  $client_network_role,
  String  $cluster_ip,
  String  $cluster_name,
  String  $primary_node,
  String  $quorum_diskid,
  Integer $ancillary_node_retry_count        = 60,
  Integer $ancillary_node_retry_interval_sec = 60,
  Integer $quorum_retry_count                = 10,
  Integer $quorum_retry_interval_sec         = 30,
  String  $description                       = 'Microsoft Windows Failover Cluster',
  String  $log_level                         = '3',
  String  $log_size                          = '1024',
  String  $quorum_allocation_unit_size       = '4096',
  String  $quorum_disk_id_type               = 'UniqueId',
  String  $quorum_drive_letter               = 'W',
  String  $quorum_fs_label                   = 'Witness',
  String  $quorum_is_single_instance         = 'Yes',
  Boolean $quorum_manage                     = true,
  String  $quorum_partition_style            = 'GPT',
  String  $quorum_type                       = 'DiskOnly',
) {
  include failovercluster_win::cluster
  include failovercluster_win::clusternetwork
  include failovercluster_win::clusterproperty
  include failovercluster_win::clusterquorum
  include failovercluster_win::diskpart
  include failovercluster_win::services

  Class['failovercluster_win::diskpart']
  -> Class['failovercluster_win::services']
  -> Class['failovercluster_win::cluster']
  -> Class['failovercluster_win::clusternetwork']
  -> Class['failovercluster_win::clusterquorum']
  -> Class['failovercluster_win::clusterproperty']
}