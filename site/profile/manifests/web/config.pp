# == Class: profile::web::config
class profile::web::config (
  Optional[Boolean] $iis = undef
) {

  # configure IIS based on the application fact
  case $facts['application'] {
    'choco_server' : {
      include profile::web::iis::apps::choco_server
    }
    default: {
      notify { 'iis_config_applicatoin_blank':
        message => 'WARNING: The fact "applicatoin" is blank!',
      }
    }
  }

}
