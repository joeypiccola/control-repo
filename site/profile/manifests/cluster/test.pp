# == Class: profile::cluster::test
class profile::cluster::test (
  String $dsc_psdscrunascredential_password,
  String $dsc_psdscrunascredential_user,
) {

  dsc_file {'makeme':
    dsc_type                 => 'file',
    dsc_destinationpath      => 'c:/mydir/file.txt',
    dsc_contents             => 'hi',
    dsc_psdscrunascredential => {
      'user'     => $dsc_psdscrunascredential_user,
      'password' => Sensitive($dsc_psdscrunascredential_password)
    },
  }

  dsc_xadcomputer {'computer_test':
    dsc_computername         => 'mySweetComputer',
    #dsc_enabledoncreation   => true,
    dsc_path                 => 'OU=Staging,OU=LabStuff,OU=Servers,DC=ad,DC=piccola,DC=us',
    dsc_domaincontroller     => 'dc04.ad.piccola.us',
    dsc_psdscrunascredential => {
      'user'     => $dsc_psdscrunascredential_user,
      'password' => Sensitive($dsc_psdscrunascredential_password)
    },
  }

}
