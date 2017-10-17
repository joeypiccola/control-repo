# == Class: profile::domain_join
class profile::domain_join (
  $domain,
  $username,
  $password,
  $join_options,
) {

  if ($facts['domainrole'] == 'Standalone Workstation') or ($facts['domainrole'] == 'Standalone Server') {
    class { 'domain_membership':
      domain       => $facts['win_domain'],
      username     => $username,
      password     => $password,
      join_options => $join_options,
    }
  }
}
