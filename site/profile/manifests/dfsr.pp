# Class: profile::dfsr
#
#
class profile::dfsr {
  windowsfeature { 'FS-DFS-Replication':
    ensure                 => present,
    installmanagementtools => true,
  }
}
