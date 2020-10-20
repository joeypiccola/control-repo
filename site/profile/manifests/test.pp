# == Class: profile::test
class profile::test (
  String $dir_name,
) {

  file { 'create_a_dir_from_hiera':
    ensure => 'directory',
    path   => "c:/${dir_name}",
  }

}


