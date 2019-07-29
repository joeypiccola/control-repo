# == Class: profile::base::smbv1
#
#
class profile::base::smbv1 {
  # disable sbmv1 via reg as this works across all windows OSs
  registry_value { 'HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\SMB1':
    ensure => present,
    type   => dword,
    data   => 0,
  }
  # if we're on something greater than Windows Server 2008 R2 then also remove the feature
  if $facts['os']['release']['full'] =~ /^2012|2016|2019/{
    windowsfeature { 'fs-smb1':
      ensure => absent,
    }
  }
}
