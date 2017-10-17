# == Class: profile::domain_join
class profile::domain_join (
  $domain,
  $username,
  $password,
  $join_options,
) {

  $win_domain = $facts['win_domain']

  if ($facts['domainrole'] == 'Standalone Workstation') or ($facts['domainrole'] == 'Standalone Server') {
    class { 'domain_membership':
      domain       => 'ad.piccola.us',
      username     => $username,
      password     => $password,
      join_options => $join_options,
    }
  }
}
