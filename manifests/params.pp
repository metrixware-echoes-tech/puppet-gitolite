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
          $version      = 2
        }
        default: {
          $package_name = 'gitolite3'
          $cmd_install  = 'gitolite setup -pk'
          $version      = 3
        }
      }
      $home_dir   = "/var/lib/${package_name}"
      $user_name  = $package_name
      $group_name = $package_name
    }
    'RedHat': {
      if versioncmp($::operatingsystemrelease, '6') < 0 {
        $package_name = 'gitolite'
        $cmd_install  = 'gl-setup -q'
        $version      = 2
      } else {
        $package_name = 'gitolite3'
        $cmd_install  = 'gitolite setup -pk'
        $version      = 3
      }
      $home_dir   = "/var/lib/${package_name}"
      $user_name  = $package_name
      $group_name = $package_name
    }
    'Suse': {
      $package_name = 'gitolite'
      $cmd_install  = 'gitolite setup -pk'
      $home_dir     = '/srv/git'
      $user_name    = 'git'
      $group_name   = 'git'
      $version      = 3
    }
    default: {
      fail("Unsupported OS family: ${::osfamily}")
    }
  }

  $manage_home_dir     = true
  $manage_user         = true
  $git_config_keys     = ''
  $umask               = 0077
  $allow_local_code    = false
  $local_code_in_repo  = false
  $repo_specific_hooks = false
}
