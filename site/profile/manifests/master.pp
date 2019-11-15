# == Class: profile::master
class profile::master {

  class { 'puppet_metrics_collector':
    metrics_server_type     => 'influxdb',
    metrics_server_hostname => 'dockerlin.piccola.us',
    metrics_server_port     => 8086,
    metrics_server_db_name  => 'puppet_metrics',
  }

}
