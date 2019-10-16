# == Class: profile::wsus::server

class profile::wsus::server (
  Array[String] $wsusserver_computer_target_groups = [],
) {
  # include wsusserver module
  include wsusserver

  # if wsusserver_computer_target_groups then add me some target groups (if in hiera)!
  wsusserver_computer_target_group { $wsusserver_computer_target_groups: }

  # for downstream server switch to replica mode
  if $facts['application_component'] == 'downstream' {
    exec { 'set downstream replica mode':
      command  => "Set-WsusServerSynchronization -UpdateServer ${wsusserver::upstream_wsus_server_name} -PortNumber ${wsusserver::upstream_wsus_server_port} -Replica",
      provider => powershell,
      onlyif   => 'if (((Get-WsusServer).GetConfiguration()).IsReplicaServer) {exit 1} else {exit 0}',
      require  => Class['wsusserver::service'],
    }
  }
}
