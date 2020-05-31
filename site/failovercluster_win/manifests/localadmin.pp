# == Class: failovercluster_win::localadmin
class failovercluster_win::localadmin (
) {

  group { $failovercluster_win::local_admin_identity:
    members => 'Administrators',
  }

}
