# == Class: profile::cluster::test
class profile::cluster::test (
  String $dsc_psdscrunascredential_password,
  String $dsc_psdscrunascredential_user,
) {

  dsc_file {'makeme':
    dsc_type                 => 'file',
    dsc_destinationpath      => 'c:/mydir/file.txt',
    dsc_psdscrunascredential => {
      'user'     => $dsc_psdscrunascredential_user,
      'password' => Sensitive($dsc_psdscrunascredential_password)
    },
  }

}
