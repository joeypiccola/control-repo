# == Class: profile::test
class profile::test (
  $dir_names,
) {

  #file { 'create_a_dir_from_hiera':
  #  ensure => 'directory',
  #  path   => "c:/${dir_names}",
  #}

  $dir_names.each |String $dir_name| {
    file {'create_a_dir_from_hiera':
      ensure => 'directory',
      target => "c:/${dir_name}",
    }
  }

}


