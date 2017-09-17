# == Class: profile::nameservers
class profile::nameservers (
  $nameservers,
) {

  $net_interfaces = split($facts['interfaces'], ',')

  $net_interfaces.each |String $net_interface| {
    dsc_xdnsserveraddress { $net_interface:
      dsc_address        => $nameservers,
      dsc_interfacealias => $net_interface,
      dsc_addressfamily  => 'IPv4',
    }
  }
}