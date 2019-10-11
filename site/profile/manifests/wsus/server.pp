# Class: profile::wsus::server
#
#
class profile::wsus::server (
) {
  class { 'wsusserver':
    package_ensure                     => 'present',
    include_management_console         => true,
    service_manage                     => true,
    service_ensure                     => 'running',
    service_enable                     => true,
    wsus_directory                     => 'W:\\WSUS',
    join_improvement_program           => false,
    sync_from_microsoft_update         => true,
    update_languages                   => ['en'],
    products                           => [
      'Windows Server 2016',
    ],
    product_families                   => [
      'SQL Server',
      'System Center',
    ],
    update_classifications             => [
        'Critical Updates'
    ],
    targeting_mode                     => 'Client',
    host_binaries_on_microsoft_update  => false,
    synchronize_automatically          => true,
    synchronize_time_of_day            => '03:00:00', # 3AM ( UTC ) 24H Clock
    number_of_synchronizations_per_day => 1,
  }
}
