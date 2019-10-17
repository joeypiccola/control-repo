# == Class: profile::base::smbv1
class profile::base::smbv1 (
  Boolean $manage = true,
) {
  if $manage {
    # disable SMBv1 server
    registry_value { 'HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\SMB1':
      type => dword,
      data => 0,
    }

    # disable SMBv1 client
    # disable the start of MRxSMB10
    registry_key { 'HKLM\SYSTEM\CurrentControlSet\services\mrxsmb10':
      ensure => present,
    }
    registry_value { 'HKLM\SYSTEM\CurrentControlSet\services\mrxsmb10\Start':
      type    => dword,
      data    => 4,
      require => Registry_key['HKLM\SYSTEM\CurrentControlSet\services\mrxsmb10']
    }
    # remove LanmanWorkstation's dependency on MRxSMB10 so that it can start
    registry_value { 'HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\DependOnService':
      type => array,
      data => ['Bowser','MRxSmb20','NSI'],
    }

    # if we're on something greater than Windows Server 2008 R2 then also remove the feature
    if $facts['os']['release']['full'] =~ /^2012|2016|2019/ {
      windowsfeature { 'fs-smb1':
        ensure => absent,
      }
    }
  }
}
