# == Class: failovercluster_win::localadmin
class failovercluster_win::localadmin (
) {

  if $failovercluster_win::manage_local_admin {
    group { 'Administrators':
      members => $failovercluster_win::local_admin_identity,
    }
  }

}
