# Class: profile::base::puppet_log
class profile::base::puppet_log {
  if $facts['os']['family'] == 'windows' {
    exec { 'Puppet event log':
    # Check if there is already a log source called 'Puppet' and if so delete it. Then create a new log called 'Puppet' with source name 'Puppet'
    # and restart the event log service (and dependent services) to finalize the changes.
    command  => "if([System.Diagnostics.EventLog]::SourceExists(\"Puppet\")) {Remove-EventLog -Source Puppet}; New-EventLog -Source Puppet \
    -LogName Puppet -MessageResource \"C:\\Program Files\\Puppet Labs\\Puppet\\puppet\\bin\\puppetres.dll\"; Restart-Service EventLog -Force",
    # But don't perform the above exec if the node already has an event log with the name 'Puppet'.
    unless   => 'if([System.Diagnostics.EventLog]::Exists("Puppet")) { exit 0 } else { exit 1 }',
    provider => powershell,
  }
}
