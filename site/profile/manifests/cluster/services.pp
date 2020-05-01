# == Class: profile::cluster::services
class profile::cluster::services (
  Array $service_names = []
) {

  windowsfeature { $service_names:
    ensure                 => present,
    installmanagementtools => true,
  }

}
