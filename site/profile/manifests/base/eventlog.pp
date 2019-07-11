# == Class: profile::base::eventlog
class profile::base::eventlog (
) {

  windows_eventlog { 'Application':
    log_size       => '62914560',
    max_log_policy => 'overwrite'
  }

  windows_eventlog { 'Security':
    log_size       => '62914560',
    max_log_policy => 'overwrite'
  }

  windows_eventlog { 'System':
    log_size       => '62914560',
    max_log_policy => 'overwrite'
  }

}
