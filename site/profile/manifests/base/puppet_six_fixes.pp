# == Class: profile::base::puppet_six_fixes
class profile::base::puppet_six_fixes (
) {

  file { 'pxp-agent':
    ensure => present,
    path   => 'C:\ProgramData/PuppetLabs/pxp-agent/etc/pxp-agent.conf',
  }

  file { 'package_inventory_enabled':
    ensure => present,
    path   => 'C:\ProgramData/PuppetLabs/puppet/cache/state/package_inventory_enabled',
  }

  acl { 'C:/ProgramData/Puppetlabs/pxp-agent/etc/pxp-agent.conf':
    group                      => 'S-1-5-21-3043862061-291277752-2514396928-513',
    inherit_parent_permissions => false,
    owner                      => 'S-1-5-32-544',
    permissions                => [
      {'identity'                => 'BUILTIN\Administrators', 'rights' => ['mask_specific'], 'mask' => '2032031', 'affects' => 'self_only'},
      {'identity'                => 'AD\Domain Users', 'rights' => ['write', 'read'], 'affects' => 'self_only'},
      {'identity'                => 'Everyone', 'rights' => ['mask_specific'], 'mask' => '1179776', 'affects' => 'self_only'},
      {'identity'                => 'NT AUTHORITY\SYSTEM', 'rights' => ['full'], 'affects' => 'self_only'}
    ],
    require                    => File['pxp-agent'],
  }

  acl { 'C:/ProgramData/PuppetLabs/puppet/cache/state/package_inventory_enabled':
    group                      => 'S-1-5-21-3043862061-291277752-2514396928-513',
    inherit_parent_permissions => false,
    owner                     => 'S-1-5-32-544',
    permissions            => [
      {'identity'               => 'BUILTIN\Administrators', 'rights' => ['mask_specific'], 'mask' => '2032031', 'affects' => 'self_only'},
      {'identity'               => 'AD\Domain Users', 'rights' => ['write', 'read'], 'affects' => 'self_only'},
      {'identity'               => 'Everyone', 'rights' => ['read'], 'affects' => 'self_only'},
      {'identity'               => 'NT AUTHORITY\SYSTEM', 'rights' => ['full'], 'affects' => 'self_only'}
    ],
    require                   => File['package_inventory_enabled'],
  }

}
