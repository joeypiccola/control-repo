# role::agent_only
class role::agent_only {
  include profile::puppet_agent
  include profile::base::puppet_log
  Class['profile::puppet_agent'] -> Class['profile::base::puppet_log']
}
