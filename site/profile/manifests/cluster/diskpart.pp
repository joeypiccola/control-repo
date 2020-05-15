# == Class: profile::cluster::diskpart
class profile::cluster::diskpart (
) {

  exec { 'automount':
    command  => "\"automount enable\" | diskpart",
    provider => 'powershell',
    onlyif   => "if ((\"automount\" | diskpart) -contains \'Automatic mounting of new volumes enabled.\') {exit 1}"
  }

}



