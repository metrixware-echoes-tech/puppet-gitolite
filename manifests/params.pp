# == Class: gitolite::params
#
# This is a container class with default parameters for gitolite classes.
class gitolite::params {
  $package_ensure = 'present'

  case $::osfamily {
    'Debian': {
    case $::lsbdistcodename {
      'squeeze', 'wheezy', 'lucid', 'precise': {
          $package_name = 'gitolite'
          $cmd_install  = 'gl-setup -q'
        }
        default: {
          $package_name = 'gitolite3'
          $cmd_install  = 'gitolite setup -pk'
        }
      }
    }
    'RedHat': {
      if versioncmp($::operatingsystemrelease, '6') < 0 {
        $package_name = 'gitolite'
        $cmd_install  = 'gl-setup -q'
      } else {
        $package_name = 'gitolite3'
        $cmd_install  = 'gitolite setup -pk'
      }
    }
    default: {
      fail("Unsupported OS family: ${::osfamily}")
    }
  }

  $home_dir            = "/var/lib/${package_name}"
  $manage_user         = true
  $git_config_keys     = undef
  $umask               = '0077'
  $allow_local_code    = false
  $local_code_in_repo  = false
  $repo_specific_hooks = false
}
