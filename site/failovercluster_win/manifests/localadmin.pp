# == Class: failovercluster_win::localadmin
class failovercluster_win::localadmin (
) {

  group { 'Administrators':
    members => $failovercluster_win::local_admin_identity,
  }

}
