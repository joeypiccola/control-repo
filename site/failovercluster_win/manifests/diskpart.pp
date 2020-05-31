# == Class: failovercluster_win::diskpart
class failovercluster_win::diskpart (
) {

  exec { 'automount':
    command  => "\"automount enable\" | diskpart",
    provider => 'powershell',
    onlyif   => "if ((\"automount\" | diskpart) -contains \'Automatic mounting of new volumes enabled.\') {exit 1}"
  }

  exec { 'sanpolicy':
    command  => "\"san policy=onlineall\" | diskpart",
    provider => 'powershell',
    onlyif   => "if ((\"san\" | diskpart) -contains \'SAN Policy  : Online All\') {exit 1}"
  }

}
