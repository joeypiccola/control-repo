# == Class: profile::domain_join
class profile::domain_join (
  $username,
  $password,
  $join_options,
) {

  $win_domain = $facts['win_domain']

  if ($facts['domainrole'] == 'Standalone Workstation') or ($facts['domainrole'] == 'Standalone Server') {
    class { 'domain_membership':
      domain       => $facts['win_domain',
      username     => $username,
      password     => $password,
      join_options => $join_options,
    }
  }
}
