# == Class failovercluster_win
class failovercluster_win (
  Array $service_names,
  Boolean $manage_quorum,
  Enum[
    'separate_cluster_client_network',
    'single_cluster_client_network'
  ] $network_strategy,
  Integer $ancillary_node_retry_count,
  Integer $ancillary_node_retry_interval_sec,
  Integer $quorum_retry_count,
  Integer $quorum_retry_interval_sec,
  Optional[Boolean] $manage_local_admin,
  Optional[String] $cluster_network_address_mask,
  Optional[String] $cluster_network_address,
  Optional[String] $local_admin_identity,
  String $ad_password,
  String $ad_user,
  String $client_network_address_mask,
  String $client_network_address,
  String $client_network_name,
  String $client_network_role,
  String $cluster_ip,
  String $cluster_name,
  String $cluster_network_name,
  String $cluster_network_role,
  String $description,
  String $log_level,
  String $log_size,
  String $primary_node,
  String $quorum_allocation_unit_size,
  String $quorum_disk_id_type,
  String $quorum_diskid,
  String $quorum_drive_letter,
  String $quorum_fs_label,
  String $quorum_is_single_instance,
  String $quorum_partition_style,
  String $quorum_type,
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
