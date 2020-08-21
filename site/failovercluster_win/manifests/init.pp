# == Class failovercluster_win
class failovercluster_win (
  String $ad_password,
  String $ad_user,
  String $client_network_address_mask,
  String $client_network_address,
  String $cluster_ip,
  String $cluster_name,
  String $primary_node,
  String $quorum_diskid,
  Array $service_names = ['Failover-Clustering'],
  Boolean $manage_quorum = true,
  Enum['separate_cluster_client_network','single_cluster_client_network'] $network_strategy = 'separate_cluster_client_network',
  Integer $ancillary_node_retry_count = 60,
  Integer $ancillary_node_retry_interval_sec = 60,
  Integer $quorum_retry_count = 10,
  Integer $quorum_retry_interval_sec = 30,
  String $client_network_name = 'Client Network',
  String $client_network_role = '0',
  String $cluster_network_name = 'Cluster Network',
  String $cluster_network_role = '1',
  String $description = 'Microsoft Windows Failover Cluster',
  String $log_level = '3',
  String $log_size = '1024',
  String $quorum_allocation_unit_size = '4096',
  String $quorum_disk_id_type = 'UniqueId',
  String $quorum_drive_letter = 'W',
  String $quorum_fs_label = 'Witness',
  String $quorum_is_single_instance = 'Yes',
  String $quorum_partition_style = 'GPT',
  String $quorum_type = 'DiskOnly',
  Optional[Boolean] $manage_local_admin = undef,
  Optional[String] $cluster_network_address = undef,
  Optional[String] $cluster_network_address_mask = undef,
  Optional[String] $local_admin_identity = undef,
) {

  # if manage_local_admin is true then ensure a local admin has been defined
  if $manage_local_admin {
    assert_type(Array[NotUndef], [$local_admin_identity])
  }

  # if network strategy indicates two separate networks ensure optional cluster network params are defined
  if $network_strategy == 'separate_cluster_client_network' {
    assert_type(Array[NotUndef], [$cluster_network_address_mask])
    assert_type(Array[NotUndef], [$cluster_network_address])
    $_client_network_name = $client_network_name
    $_client_network_role = $client_network_role
  } else {
    # override client network role from 'client only' to 'cluster and client' if not already overridden
    if $client_network_name == 'Client Network' {
      $_client_network_name = 'Cluster and Client Network'
    } else {
      $_client_network_name = $client_network_name
    }
    # set client network role to 3 when single network strategy is specified. it can be no other value.
    $_client_network_role = '3'
  }

  include failovercluster_win::cluster
  include failovercluster_win::clusternetwork
  include failovercluster_win::clusterproperty
  include failovercluster_win::clusterquorum
  include failovercluster_win::diskpart
  include failovercluster_win::localadmin
  include failovercluster_win::services

  Class['failovercluster_win::localadmin']
  -> Class['failovercluster_win::diskpart']
  -> Class['failovercluster_win::services']
  -> Class['failovercluster_win::cluster']
  -> Class['failovercluster_win::clusternetwork']
  -> Class['failovercluster_win::clusterquorum']
  -> Class['failovercluster_win::clusterproperty']
}
