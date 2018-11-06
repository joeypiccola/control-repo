# == Class: profile::base::rdp_config
class profile::base::rdp_config (
) {

  # rdp
  registry_value { 'HKLM\System\CurrentControlSet\Control\Terminal Server\fDenyTSConnections':
    ensure => present,
    type   => dword,
    data   => 0,
  }

  # rdp-nla
  registry_value { 'HKLM\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp':
  ensure => present,
  type   => dword,
  data   => 0,
  }

}
