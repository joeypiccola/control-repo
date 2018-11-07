# == Class: profile::base::uac_config
class profile::base::uac_config (
) {

  # enabled = 1, disabled = 1
  registry_value { 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\EnableLUA':
    ensure => present,
    type   => dword,
    data   => 0,
  }

  # disabled = 0, authprompt = 1, consentprompt = 2
  registry_value { 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\ConsentPromptBehaviorAdmin':
    ensure => present,
    type   => dword,
    data   => 0,
  }

}
