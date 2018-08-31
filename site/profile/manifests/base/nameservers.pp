# == Class: profile::base::nameservers
class profile::base::nameservers (
  $nameservers,
) {
  # if we're on ps v5 then lets do stuff with DSC!
  $psmajor = split($facts['powershell_version'], '[.]')
  if $psmajor[0] == '5' {
    $net_interfaces = split($facts['interfaces'], ',')
    $net_interfaces.each |String $net_interface| {
      notice("Current working net_interface is: ${net_interface}")
      dsc_xdnsserveraddress { $net_interface:
        dsc_address        => $nameservers,
        dsc_interfacealias => $net_interface,
        dsc_addressfamily  => 'IPv4',
      }
    }
  }
}
