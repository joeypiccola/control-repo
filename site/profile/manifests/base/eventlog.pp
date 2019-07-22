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

  exec { 'Puppet event log':
  # Check if there is already a log source called 'Puppet' and if so delete it. Then create a new log called 'Puppet' with source name 'Puppet'
  # and restart the event log service (and dependent services) to finalize the changes.
    command  => "if([System.Diagnostics.EventLog]::SourceExists(\"Puppet\")) {Remove-EventLog -Source Puppet}; New-EventLog -Source Puppet \
    -LogName Puppet -MessageResource \"C:\\Program Files\\Puppet Labs\Puppet\\bin\\puppetres.dll\"; Restart-Service EventLog -Force",
  # But don't perform the above exec if the node already has an event log with the name 'Puppet'.
    unless   => 'if([System.Diagnostics.EventLog]::Exists("Puppet")) { exit 0 } else { exit 1 }',
    provider => powershell,
  }

}
