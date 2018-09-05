# profile::base::localaccounts
class profile::base::localaccounts (
  Hash $groups = {},
  Hash $users  = {},
) {
  $groups.each | String $group, Hash $attributes | {
    group { $group:
      * => $attributes
    }
  }

  $users.each | String $user, Hash $attributes | {
    user { $user:
      * => $attributes
    }
  }
}
