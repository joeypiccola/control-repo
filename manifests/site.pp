## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# Disable filebucket by default for all File resources:
#https://docs.puppet.com/pe/2015.3/release_notes.html#filebucket-resource-no-longer-created-by-default
File { backup => false }

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node default {
  # Detect which role to use
  if $trusted['extensions']['pp_role'] {
    # Trusted extension (fact) overrides regular fact
    $role = $trusted['extensions']['pp_role']
  } elsif $facts['role'] {
    $role = $facts['role']
  } else {
    notify { 'role_undefined':
      message => 'NOTICE: The fact "role" is not defined! Defaulting to agent_only',
    }
    $role = 'agent_only'
  }

  # Support specifying "role::blah" or just "blah" for role
  if $role =~ /^role::/ {
    $role_class = $role
  } elsif $role == '' { # Yes, we have seen blank roles (sigh)
    notify { 'role_blank':
      message => 'WARNING: The fact "role" is blank! Defaulting to agent_only',
    }
    $role_class = 'role::agent_only'
  } else { # assume it is just the role_name
    $role_class = "role::${role}"
  }

  # Validate that $role_class exists before including it
  if defined($role_class) {
    include $role_class
  } else {
    notify { 'role_not_exist':
      message => "WARNING: The fact \"role\" is set to \"${role}\", which does not exist. Defaulting to agent_only.",
    }
    include role::agent_only
  }

}
