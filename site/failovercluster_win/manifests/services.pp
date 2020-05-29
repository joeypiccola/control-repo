# == Class: failovercluster_win::services
class failovercluster_win::services {

  windowsfeature { $failovercluster_win::service_names:
    ensure                 => present,
    installmanagementtools => true,
  }

}
