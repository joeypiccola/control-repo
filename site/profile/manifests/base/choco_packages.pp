# == Class: profile::base::choco_packages
class profile::base::choco_packages (
  $packages
) {
  include chocolatey

  $packages.each | String $package, Hash $attributes | {
    Package { $package:
      * => $attributes
    }
  }

}
