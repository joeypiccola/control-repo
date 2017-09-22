# == Class: profile::master
class profile::master {
  class { 'hiera':
          hiera_version   =>  '5',
          hiera5_defaults =>  {'datadir' => 'data', 'data_hash' => 'yaml_data'},
          hierarchy       =>  [
                                {'name' =>  'Per-node data', 'path'  =>  "nodes/%{trusted.certname}.yaml"},
                                {'name' =>  'Per-datacenter defaults', 'paths' =>  "datacenters/%{facts.datacenter}.yaml"},
                                {'name' =>  'Per-domain defaults', 'path' =>  "domains/%{facts.win_domain}.yaml"},
                                {'name' =>  'Default yaml file', 'path' =>  'common.yaml'},
                              ],
  }
}
